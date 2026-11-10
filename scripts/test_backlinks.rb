# Run: ruby scripts/test_backlinks.rb  (inside the jekyll container)
require "minitest/autorun"
require "tmpdir"
require "jekyll"
require_relative "../_plugins/backlinks"

class BacklinksTest < Minitest::Test
  B = Jekyll::Backlinks
  SITE = "https://blog.omgmog.net".freeze
  CFG = B::DEFAULTS
  INDEX = {"/post/a" => "/post/a/", "/post/b" => "/post/b/", "/lwal/week-1" => "/lwal/week-1/"}.freeze

  def src(url, html, date = Time.utc(2024, 1, 1))
    B::Source.new(url: url, title: url, date: date, html: "<main><div class='prose e-content'>#{html}</div></main>")
  end

  def build(*sources) = B.build(sources, INDEX, CFG, SITE)

  def test_relative_absolute_and_other_hosts
    m = build(src("/post/x/", '<p><a href="/post/a/">1</a> <a href="https://blog.omgmog.net/post/b">2</a> <a href="../b/">3</a> <a href="https://www.omgmog.net/post/a/">no</a> <a href="https://social.omgmog.net/post/a/">no</a></p>'))
    assert_equal ["/post/x/"], m["/post/a/"].map { _1["url"] }
    assert_equal ["/post/x/"], m["/post/b/"].map { _1["url"] }
  end

  def test_fragment_query_index_and_trailing_slash_stripped
    m = build(src("/post/x/", '<p><a href="/post/a/index.html?utm=1#frag">a</a></p>'))
    assert m.key?("/post/a/")
  end

  def test_self_link_excluded
    assert_empty build(src("/post/a/", '<p><a href="/post/a/#top">me</a></p>'))
  end

  def test_duplicates_collapse_and_snippet_is_plain_text
    m = build(src("/post/x/", '<p>See <em>this</em> <a href="/post/a/">post</a> and <a href="/post/a/">again</a>.</p>'))
    assert_equal 1, m["/post/a/"].size
    assert_equal %(See this <span class="backlinks__mark">post</span> and again.), m["/post/a/"][0]["snippet"]
  end

  def test_related_and_prev_next_ignored
    html = '<div class="e-content"><p>hi</p></div><nav class="post-pager"><a href="/post/a/">p</a></nav><section class="related"><a href="/post/a/">r</a></section>'
    assert_empty build(B::Source.new(url: "/post/x/", title: "x", date: Time.utc(2024), html: html))
    nested = src("/post/x/", '<nav class="post-pager"><a href="/post/a/">p</a></nav><p><a href="/post/b/">b</a></p>')
    m = build(nested)
    refute m.key?("/post/a/")
    assert m.key?("/post/b/")
  end

  def test_lwal_source_counts_internal_links_only
    html = '<div class="lwal-links"><p><a href="https://example.com/">out</a> <a href="/post/a/">in</a></p></div>'
    m = build(B::Source.new(url: "/lwal/week-1/", title: "w", date: Time.utc(2024), html: html))
    assert_equal ["/lwal/week-1/"], m["/post/a/"].map { _1["url"] }
    assert_equal ["/post/a/"], m.keys
  end

  def test_lwal_card_snippet_is_the_note
    html = '<div class="lwal-links"><div class="lwal-entry"><p class="lwal-note">Great read on boring sites.</p><div class="lwal-item"><span>host</span><a href="/post/a/">Title</a></div></div></div>'
    m = build(B::Source.new(url: "/lwal/week-1/", title: "w", date: Time.utc(2024), html: html))
    assert_equal "Great read on boring sites.", m["/post/a/"][0]["snippet"]
  end

  def test_oldest_first_and_long_snippet_truncated
    long = "Intro. " + ("word " * 60) + "<a href=\"/post/a/\">x</a>"
    m = build(src("/post/new/", '<p><a href="/post/a/">x</a></p>', Time.utc(2024)), src("/post/old/", "<p>#{long}</p>", Time.utc(2020)))
    assert_equal ["/post/old/", "/post/new/"], m["/post/a/"].map { _1["url"] }
    snip = m["/post/a/"][0]["snippet"]
    assert_includes snip, %(<span class="backlinks__mark">x</span>)
    assert_operator snip.gsub(/<[^>]+>/, "").length, :<=, 160
    assert snip.start_with?("…word"), snip # cut at a word boundary, never mid-word
  end

  # Renders the real template through Jekyll's Liquid with a stub post-item include.
  def render_group(count, show)
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "_includes/posts"))
      File.write(File.join(dir, "_includes/posts/post-item.html"), "<li>{{ include.post.title }}|{{ include.snippet }}</li>")
      site = Jekyll::Site.new(Jekyll.configuration("source" => dir, "destination" => File.join(dir, "_site"), "quiet" => true))
      docs = (1..count).map { |i| {"doc" => {"title" => "T#{i}"}, "snippet" => "s#{i}"} }
      B.render(site, docs, show)
    end
  end

  def test_render_splits_after_show_and_escapes
    html = render_group(7, 5)
    assert_includes html, "<details"
    assert_includes html, "Show 2 more"
    assert_includes html, "T1|s1"
    assert_equal 7, html.scan("<li>").size
    refute_includes render_group(5, 5), "<details"
  end

  RELATED = %(<p>x</p>\n<section aria-labelledby="related-heading" data-pagefind-ignore>\n<h2 id="related-heading">Related posts</h2>\n<ul>\n) +
            (1..5).map { |i| %(<li class="card"><a class="post-item__title" href="/post/#{i}/">#{i}</a></li>\n) }.join + %(</ul>\n</section>\n<p>y</p>)

  def test_related_drops_connected_and_backfills
    html = B.trim_related(RELATED, Set["/post/1/", "/post/3/"], 3)
    assert_equal %w[/post/2/ /post/4/ /post/5/], html.scan(%r{href="(/post/\d/)"}).flatten
    assert_includes html, "<p>x</p>"
    assert_includes html, "<p>y</p>"
    assert_includes html, "</ul>"
  end

  def test_related_section_removed_when_nothing_left
    html = B.trim_related(RELATED, Set.new((1..5).map { "/post/#{_1}/" }), 3)
    refute_includes html, "related-heading"
    assert_equal "<p>x</p>\n<p>y</p>", html
  end

  def test_related_untouched_without_section_and_outbound_collected
    assert_equal "<p>hi</p>", B.trim_related("<p>hi</p>", Set["/post/1/"], 3)
    out = Hash.new { |h, k| h[k] = Set.new }
    B.build([src("/post/x/", '<p><a href="/post/a/">a</a> <a href="/post/a/">again</a></p>')], INDEX, CFG, SITE, outbound: out)
    assert_equal Set["/post/a/"], out["/post/x/"]
  end
end
