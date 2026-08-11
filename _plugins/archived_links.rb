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
  # Split at the interactions section to avoid processing webmention/comment templates
  if post.output =~ /(<div class="page-content e-content">.*?)(<section id="interactions")/m
    before_article = $`
    matched_article = $1
    after_article = $2 + $'
    post.output = before_article + rewrite_links.call(matched_article) + after_article
  end

  # Process links within archived comments (frontmatter-sourced, pre-2012 posts);
  # these are the author's own copy of comments from the old commenting system,
  # not live third-party content, so they get the same archive.org treatment.
  post.output = post.output.gsub(/(<article class="reply[^"]*" data-source="archived">.*?<\/article>)/m) do
    rewrite_links.call($1)
  end
end
