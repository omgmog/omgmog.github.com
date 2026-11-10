require "uri"
require "set"
require "cgi"
require "nokogiri"

# "Mentioned elsewhere on this site": for each post, the other posts that link to it.
#
# HOW IT WORKS
#   A post's backlinks depend on other documents' *rendered* bodies, and
#   Jekyll renders one document at a time (generators run before Liquid and
#   Markdown, so they only ever see raw source). So the layout emits a
#   placeholder, <!--linked-from-->, and a :site, :post_render hook (which
#   runs once every document has its final HTML) parses each source's output,
#   builds target URL => sources, and swaps the placeholder for the rendered
#   group (or for nothing). It works with a full build and with `jekyll serve`
#   regeneration, which re-runs the whole pipeline. With `--incremental`,
#   documents that were not re-rendered are not rewritten, so their backlinks
#   can lag until the next full build.
#
#   Because the data only exists after rendering, Liquid in the layout cannot
#   read it. It is stored afterwards in doc.data["backlinks"] (title, url,
#   date, snippet; oldest first) for later hooks, and is what the report uses.
#
# CONFIGURATION (_config.yml, `backlinks:`; every key is optional)
#   url:                the site's real URL; defaults to site.url. `jekyll serve` overwrites
#                       site.url with localhost in development, which would make every
#                       absolute link to the live site look external, so set it here
#   collections:        collections that are valid as both source and target
#   include:            CSS selectors; links are counted only inside these
#   exclude:            CSS selectors; links inside (or on) these are ignored
#   show:               rows shown before the <details>
#   related:            Related posts cards kept after dropping posts this one already links
#                       to or is linked from (the layout renders every candidate)
#   report_collections: collections listed in the zero/one-inbound report
#   report:             where the report is written (posts with 0-1 inbound links; scripts/backlink_suggestions.py reads it)
#   Related posts, prev/next, series, tags and the LWAL index all sit outside
#   .e-content, so they are already ignored; `exclude` is for anything that is
#   later placed inside a post body.
#
# RULES
#   Only links to this site count (the site.url host; other *.omgmog.net hosts
#   do not). Fragments and queries are stripped, relative links are resolved
#   against the source, and trailing slashes and index.html are normalised.
#   Self-links are dropped and a source appears once per target. LWAL index
#   pages are not documents, so they are never sources.
module Jekyll
  module Backlinks
    DEFAULTS = {
      "collections" => %w[posts lwal cardboctober],
      "include" => [".e-content", ".lwal-links"],
      "exclude" => [".post-pager", ".series", ".related", ".thread", ".tag-pills", ".feature-box", "nav", "aside", "[hidden]"],
      "show" => 5,
      "related" => 3,
      "report_collections" => %w[posts cardboctober],
      "report" => ".jekyll-cache/backlinks-report.txt"
    }.freeze

    TOKEN = "<!--linked-from-->".freeze
    BLOCKS = %w[p li blockquote dd td h1 h2 h3 h4 h5 h6].freeze
    SNIPPET_MAX = 160

    Source = Struct.new(:url, :title, :date, :html, :doc, keyword_init: true)

    module_function

    def config(site)
      DEFAULTS.merge(site.config["backlinks"] || {})
    end

    # Absolute-or-relative href => canonical path on this site, or nil.
    def normalize(href, source_url, site_url, baseurl = "")
      site = URI.parse(site_url)
      uri = URI.join(site_url.chomp("/") + source_url, href.to_s.strip)
      return nil unless %w[http https].include?(uri.scheme) && uri.host.to_s.downcase == site.host.downcase
      path = URI.decode_uri_component(uri.path.to_s)
      path = path.delete_prefix(baseurl) if baseurl.to_s != "" && path.start_with?(baseurl)
      path = path.sub(%r{/index\.html?\z}, "/")
      path = path.chomp("/") unless path == "/"
      path.empty? ? "/" : path
    rescue URI::Error, ArgumentError
      nil
    end

    MARK_OPEN = "\u0001".freeze
    MARK_CLOSE = "\u0002".freeze

    # About a sentence of text around the link, as safe HTML: markup stripped, the linked words
    # in <span class="backlinks__mark"> (a highlight, not a link).
    def snippet(anchor)
      # An LWAL link card is not a text block; its note (the sentence about the link) is the snippet, unmarked.
      entry = anchor.ancestors.find { |n| n["class"].to_s.split.include?("lwal-entry") }
      if (note = entry&.at_css(".lwal-note"))
        return html_snippet(*clip(note.text.gsub(/\s+/, " ").strip, "", ""))
      end

      block = anchor.ancestors.find { |n| BLOCKS.include?(n.name) } || anchor.parent
      saved = anchor.inner_html
      anchor.content = MARK_OPEN + anchor.text + MARK_CLOSE
      text = block.text.gsub(/\s+/, " ").strip
      anchor.inner_html = saved
      text = text.split(/(?<=[.!?])\s+/).find { |s| s.include?(MARK_OPEN) } || text if text.length > SNIPPET_MAX + 2
      before, rest = text.split(MARK_OPEN, 2)
      label, after = rest.to_s.split(MARK_CLOSE, 2)
      html_snippet(*clip(before.to_s, label.to_s.strip, after.to_s))
    end

    # Trim before/after to fit SNIPPET_MAX around the label, cutting at word boundaries.
    def clip(before, label, after)
      return [before, label, after] if before.length + label.length + after.length <= SNIPPET_MAX
      room = [SNIPPET_MAX - label.length, 0].max
      keep_after = [after.length, room / 2].min
      keep_before = [before.length, room - keep_after].min
      keep_after = [after.length, room - keep_before].min
      before = "…" + before[-keep_before, keep_before].sub(/\A\S*\s+/, "") if keep_before < before.length
      after = after[0, keep_after].sub(/\s+\S*\z/, "").sub(/[\s,;:.-]+\z/, "") + "…" if keep_after < after.length
      [before, label, after]
    end

    def html_snippet(before, label, after)
      mark = label.empty? ? "" : %(<span class="backlinks__mark">#{CGI.escapeHTML(label)}</span>)
      CGI.escapeHTML(before) + mark + CGI.escapeHTML(after)
    end

    # [[canonical_path, snippet], ...] for the counted links in one rendered page.
    def links(html, source_url, cfg, site_url, baseurl = "")
      doc = Nokogiri::HTML(html)
      # Drop excluded containers up front; Node#matches? searches the whole document per call.
      doc.css(cfg["exclude"].join(", ")).each(&:remove) unless cfg["exclude"].empty?
      anchors = doc.css(cfg["include"].map { |s| "#{s} a[href]" }.join(", "))
      anchors.filter_map do |a|
        path = normalize(a["href"], source_url, site_url, baseurl) or next
        [path, snippet(a)]
      end
    end

    # sources: [Source]; index: normalised path => canonical url of a target.
    # Returns canonical url => [{title,url,date,snippet}] oldest first.
    # outbound, if given, is filled with source url => Set of target urls it links to.
    def build(sources, index, cfg, site_url, baseurl = "", outbound: nil)
      map = Hash.new { |h, k| h[k] = {} }
      sources.each do |src|
        links(src.html, src.url, cfg, site_url, baseurl).each do |path, snip|
          target = index[path] or next
          next if target == src.url
          outbound[src.url] << target if outbound
          map[target][src.url] ||= {"title" => src.title, "url" => src.url, "date" => src.date, "doc" => src.doc, "snippet" => snip}
        end
      end
      map.transform_values { |h| h.values.sort_by { |b| b["date"] } }
    end

    RELATED_SECTION = %r{<section aria-labelledby="related-heading".*?</section>\n?}m
    RELATED_CARD = %r{<li class="card".*?</li>\s*}m

    # Drop Related posts cards for posts already connected by a link (exclude: urls), keep the first `keep`,
    # and drop the whole section if none are left. The layout renders every candidate so there is a spare to backfill.
    def trim_related(html, exclude, keep)
      html.sub(RELATED_SECTION) do |section|
        cards = section.scan(RELATED_CARD)
        kept = cards.reject { |c| exclude.any? { |u| c.include?(%(href="#{u}")) } }.first(keep)
        next "" if kept.empty?
        section[0...section.index(RELATED_CARD)] + kept.join + section[(section.rindex(cards.last) + cards.last.length)..]
      end
    end

    # Rows are the site's own posts/post-item.html (badge, colours, title, meta), so they match every other post list.
    # include.snippet (HTML, already escaped) replaces the excerpt with the sentence around the link.
    TEMPLATE = <<~LIQUID.freeze
      <section class="backlinks" aria-labelledby="linked-from-heading" data-pagefind-ignore>
      <h2 id="linked-from-heading">Mentioned elsewhere on this site</h2>
      <ul class="post-list" role="list">
      {% for b in backlinks limit: show %}{% include posts/post-item.html post=b.doc snippet=b.snippet noseries=true %}{% endfor %}
      </ul>
      {% if backlinks.size > show %}<details class="backlinks__more"><summary>Show {{ backlinks.size | minus: show }} more</summary>
      <ul class="post-list" role="list">
      {% for b in backlinks offset: show %}{% include posts/post-item.html post=b.doc snippet=b.snippet noseries=true %}{% endfor %}
      </ul></details>{% endif %}
      </section>
    LIQUID

    def render(site, backlinks, show)
      payload = site.site_payload
      payload["backlinks"] = backlinks
      payload["show"] = show
      site.liquid_renderer.file("backlinks").parse(TEMPLATE).render!(payload, registers: {site: site, page: {}})
    end
  end
end

Jekyll::Hooks.register :site, :post_render do |site, _payload|
  t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  cfg = Jekyll::Backlinks.config(site)
  site_url = (cfg["url"] || site.config["url"]).to_s
  baseurl = site.config["baseurl"].to_s
  docs = site.documents.select do |d|
    cfg["collections"].include?(d.collection.label) && d.output_ext == ".html" && d.data["published"] != false
  end

  index = {}
  docs.each do |d|
    [d.url, *d.data["alternate_urls"]].each do |u|
      p = Jekyll::Backlinks.normalize(u, "/", site_url, baseurl) and index[p] = d.url
    end
  end

  sources = docs.map { |d| Jekyll::Backlinks::Source.new(url: d.url, title: d.data["title"], date: d.date, html: d.output, doc: d) }
  outbound = Hash.new { |h, k| h[k] = Set.new }
  map = Jekyll::Backlinks.build(sources, index, cfg, site_url, baseurl, outbound: outbound)

  site.documents.each do |d|
    next unless d.output
    if d.output.include?(Jekyll::Backlinks::TOKEN)
      list = map[d.url]
      d.data["backlinks"] = list || []
      d.output = d.output.sub(Jekyll::Backlinks::TOKEN, list ? Jekyll::Backlinks.render(site, list, cfg["show"]) : "")
    end
    connected = outbound[d.url] | (map[d.url] || []).map { |b| b["url"] }
    d.output = Jekyll::Backlinks.trim_related(d.output, connected, cfg["related"])
  end

  # Posts nothing links to yet, for deciding what to link back to in new writing.
  rows = docs.select { |d| cfg["report_collections"].include?(d.collection.label) }
    .map { |d| [d, (map[d.url] || []).size] }
    .select { |_, n| n <= 1 }
    .sort_by { |d, _| d.date }.reverse
  report = rows.map { |d, n| "#{n}  #{d.date.strftime("%Y-%m-%d")}  #{d.url}  #{d.data["title"]}" }
  path = File.join(site.source, cfg["report"])
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, "inbound  date  url  title (newest first)\n#{report.join("\n")}\n")
  Jekyll.logger.info "Backlinks:", "#{map.size} posts linked to; #{rows.count { |_, n| n.zero? }} with none, #{rows.count { |_, n| n == 1 }} with one (#{cfg["report"]}), #{(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0).round(1)}s"
end
