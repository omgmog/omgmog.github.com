require "cgi"
require "html_to_plain_text"
require "fileutils"

module Jekyll
  module TxtFormatFilters
    def iframes_to_urls(input)  = TxtGenerator.iframes_to_urls(input)
    def images_to_urls(input)   = TxtGenerator.images_to_urls(input, @context.registers[:site].config['url'])
    def unwrap_links(input)     = TxtGenerator.unwrap_links(input,   @context.registers[:site].config['url'])
    def html_to_plain_text_convert(input) = TxtGenerator.to_plain(input)
    def wrap_lines(input, width = 80)     = TxtGenerator.wrap_lines(input, width)
    def collapse_blank_lines(input)       = TxtGenerator.collapse_blank_lines(input)
  end

  module TxtGenerator
    SEP = "=" * 80

    def self.iframes_to_urls(input)
      return input unless input
      input = input.gsub(/<div[^>]+data-src=["']([^"']+)["'][^>]*>.*?<\/div>/im) do
        url = $1; url = "https:#{url}" unless url.start_with?('http')
        "\n#{url}\n"
      end
      input.gsub(/<iframe[^>]+src=["']([^"']+)["'][^>]*>.*?<\/iframe>/im) do
        url = $1; url = "https:#{url}" unless url.start_with?('http')
        "\n#{url}\n"
      end
    end

    def self.images_to_urls(input, site_url)
      return input unless input
      input.gsub(/<img[^>]+src=["']([^"']+)["'][^>]*>/i) do
        url = $1
        url = "#{site_url}#{url}" if url.start_with?('/')
        "\n[IMAGE: #{url}]\n"
      end
    end

    def self.unwrap_links(input, site_url)
      return input unless input
      input.gsub(/<a[^>]+href=["']([^"']+)["'][^>]*>(.*?)<\/a>/im) do
        url, text = $1, $2.strip
        url = "#{site_url}#{url}" if url.start_with?('/')
        text.downcase == url.downcase ? text : "#{text} (#{url})"
      end
    end

    def self.to_plain(input)
      return input unless input
      HtmlToPlainText.plain_text(input)
    end

    def self.wrap_lines(input, width = 80)
      return input unless input
      lines = input.split("\n")
      out   = []
      lines.each do |line|
        if line =~ /^```|^    |^(>\s|[=#-]{3,}|\[IMAGE:|^\s*$)/ || line.length <= width
          out << line
        elsif line =~ /^(\s*)([-*+•])\s+(.+)$/
          prefix, indent = "#{$1}#{$2} ", " " * "#{$1}#{$2} ".length
          out.concat wrap_words($3, width, prefix, indent)
        else
          out.concat wrap_words(line, width, "", "")
        end
      end
      out.join("\n")
    end

    def self.collapse_blank_lines(input)
      return input unless input
      input.gsub(/\n{3,}/, "\n\n")
    end

    def self.generate_txt(doc, site)
      site_url  = site.config['url'].to_s
      site_data = site.data

      body = doc.content.dup
      body = iframes_to_urls(body)
      body = images_to_urls(body, site_url)
      body = unwrap_links(body, site_url)
      body = to_plain(body)
      body = wrap_lines(body)
      body = collapse_blank_lines(body)

      author_bio  = wrap_lines(site_data.dig('author', 'bio').to_s)
      social_lines = (site_data.dig('author', 'urls') || [])
                       .map { |u| "- #{u['label']}: #{u['link']}" }.join("\n")
      synd = (doc.data['syndication'] || []).map { |u| "- #{u}" }.join("\n")
      synd_block = synd.empty? ? "" : "Post syndicated to:\n#{synd}\n\n"

      [
        doc.data['title'],
        "",
        SEP,
        "",
        body,
        "",
        SEP,
        "Published #{doc.date.strftime('%B %d, %Y')}",
        "",
        "Generated from the original post:",
        "#{site_url}#{doc.url}",
        "",
        synd_block,
        social_lines,
        author_bio,
      ].join("\n")
    end

    private_class_method def self.wrap_words(text, width, first_prefix, cont_prefix)
      url_map, idx = {}, 0
      text = text.gsub(/\([^)]{20,}\)/) do |m|
        k = "{{U#{idx}}}"
        url_map[k] = m
        idx += 1
        k
      end
      words = text.split(/\s+/).map { |w| w.gsub(/\{\{U\d+\}\}/) { |k| url_map[k] } }
      lines, cur = [], first_prefix
      words.each do |w|
        test = cur.empty? ? w : "#{cur} #{w}"
        if (cur == first_prefix ? test : test).length <= width
          cur = cur.empty? ? w : "#{cur} #{w}"
        else
          lines << cur
          cur = "#{cont_prefix}#{w}"
        end
      end
      lines << cur unless cur.strip.empty?
      lines
    end
  end
end

Liquid::Template.register_filter(Jekyll::TxtFormatFilters)

# ── Register .txt alternates before rendering ─────────────────────────────────
Jekyll::Hooks.register :site, :post_read do |site|
  docs = site.posts.docs.dup
  docs += site.collections['cardboctober']&.docs || []
  docs.each do |doc|
    next unless doc.output_ext == '.html' && doc.data['published'] != false
    col  = doc.collection.label == 'posts' ? 'post' : doc.collection.label
    slug = doc.data['slug']
    doc.data['alternates'] ||= []
    doc.data['alternates'].reject! { |a| a['type'] == 'text/plain' }
    doc.data['alternates'] << { 'type' => 'text/plain', 'href' => "/#{col}/#{slug}.txt", 'title' => 'plain text' }
  end
end

# ── Generate txt content after each post renders ──────────────────────────────
Jekyll::Hooks.register :posts, :post_render do |doc|
  next unless doc.output_ext == '.html' && doc.data['published'] != false
  doc.data['_txt'] = Jekyll::TxtGenerator.generate_txt(doc, doc.site)
end

Jekyll::Hooks.register :documents, :post_render do |doc|
  next unless doc.collection&.label == 'cardboctober'
  next unless doc.output_ext == '.html' && doc.data['published'] != false
  doc.data['_txt'] = Jekyll::TxtGenerator.generate_txt(doc, doc.site)
end

# ── Write txt files after site is written ────────────────────────────────────
Jekyll::Hooks.register :site, :post_write do |site|
  docs = site.posts.docs.dup
  docs += site.collections['cardboctober']&.docs || []
  docs.each do |doc|
    next unless (txt = doc.data['_txt'])
    col  = doc.collection.label == 'posts' ? 'post' : doc.collection.label
    slug = doc.data['slug']
    path = File.join(site.dest, col, "#{slug}.txt")
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, txt, encoding: 'utf-8')
  end
end
