# Adds target="_blank" (and rel="noopener") to links to other sites inside a post's own content.
# The content is the block marked e-content. The Discussion (webmentions, comments) gets the same, with
# rel="nofollow noopener" on every outside link as well, since the people behind them aren't vouched for
# (assets/discussion-refresh.js does the same to what it adds). The rest of the page (sidebar) is left alone,
# as are internal, anchor, mailto and javascript links and links that already have a target.
Jekyll::Hooks.register :posts, :post_render do |post|
  site_domain = (post.site.config["url"] || "").sub(%r{\Ahttps?://}, "")

  start = post.output.index(/<div class="[^"]*\be-content\b[^"]*">/)
  next unless start

  # The content ends where the post pager, the discussion or the end of the article starts.
  stop = [post.output.index('<nav class="post-pager"', start),
          post.output.index('<section id="discussion"', start),
          post.output.index("</article>", start)].compact.min
  next unless stop

  content = post.output[start...stop].gsub(/<a\s+([^>]*?)href=["']([^"']+)["']([^>]*?)>/i) do
    before, url, after = $1, $2, $3
    internal = url.start_with?("/", "#", "mailto:", "javascript:") || (!site_domain.empty? && url.include?(site_domain))
    if internal || after.include?("target=") || before.include?("target=")
      "<a #{before}href=\"#{url}\"#{after}>"
    else
      rel = (before + after).include?("rel=") ? "" : ' rel="noopener"'
      "<a #{before}href=\"#{url}\"#{after} target=\"_blank\"#{rel}>"
    end
  end

  post.output = post.output[0...start] + content + post.output[stop..]

  d_start = post.output.index('<section id="discussion"')
  d_stop  = d_start && post.output.index("</section>", d_start)
  next unless d_stop

  discussion = post.output[d_start...d_stop].gsub(/<a\s+([^>]*?)href=["']([^"']+)["']([^>]*?)>/i) do
    before, url, after = $1, $2, $3
    if url.start_with?("/", "#", "mailto:", "javascript:") || (!site_domain.empty? && url.include?(site_domain))
      "<a #{before}href=\"#{url}\"#{after}>"
    else
      attrs = "#{before}href=\"#{url}\"#{after}".sub(/\s*\brel=["'][^"']*["']/i, "").strip
      attrs += ' target="_blank"' unless attrs.include?("target=")
      "<a #{attrs} rel=\"nofollow noopener\">"
    end
  end

  post.output = post.output[0...d_start] + discussion + post.output[d_stop..]
end
