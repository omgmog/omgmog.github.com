# Plugin to automatically prefix external links with archive.org for archived posts
Jekyll::Hooks.register :posts, :post_render do |post|
  # Only process posts marked as archived
  next unless post.data['archived'] == true

  site_url = post.site.config['url'] || ''
  site_domain = site_url.gsub(/https?:\/\//, '')

  # Get the year from the post date
  post_year = post.date.year

  # Rewrite external links to point to archive.org
  rewrite_links = lambda do |html|
    html.gsub(/<a\s+([^>]*?)href=["']([^"']+)["']([^>]*?)>/i) do
      before_href = $1
      url = $2
      after_href = $3

      skip_link = url.start_with?('/') ||
                  url.start_with?('#') ||
                  url.include?('archive.org') ||
                  url.include?(site_domain) ||
                  url.start_with?('mailto:') ||
                  url.start_with?('javascript:')

      if skip_link
        "<a #{before_href}href=\"#{url}\"#{after_href}>"
      else
        archived_url = "https://web.archive.org/web/#{post_year}*/#{url}"
        "<a #{before_href}href=\"#{archived_url}\"#{after_href}>"
      end
    end
  end

  # Process links within the main article content
  if post.output =~ /(<article class="post h-entry[\w\-\s]*?">.*?<\/article>)/m
    before_article = $`
    matched_article = $1
    after_article = $'
    post.output = before_article + rewrite_links.call(matched_article) + after_article
  end

  # Process links within the archived comments section
  # Boundary: from <div id="archived-comments"> to the next <h3 (which starts Comments/Webmentions)
  if post.output.include?('id="archived-comments"')
    post.output = post.output.sub(/(<div id="archived-comments">)(.*?)(<h3 )/m) do
      opener = $1
      comments_html = $2
      closer = $3
      opener + rewrite_links.call(comments_html) + closer
    end
  end
end
