# Plugin to automatically prefix external links with archive.org for archived posts
Jekyll::Hooks.register :posts, :post_render do |post|
  # Only process posts marked as archived
  next unless post.data['archived'] == true

  site_url = post.site.config['url'] || ''
  site_baseurl = post.site.config['baseurl'] || ''
  site_domain = site_url.gsub(/https?:\/\//, '')

  # Get the year from the post date
  post_year = post.date.year

  # Only process links within the main article content
  # Split at </article> to avoid processing templates and interactions
  if post.output =~ /(<article class="post h-entry">.*?<\/article>)/m
    before_article = $`
    article_content = $1
    after_article = $'

    # Parse and modify links only in the article content
    article_content = article_content.gsub(/<a\s+([^>]*?)href=["']([^"']+)["']([^>]*?)>/i) do
    before_href = $1
    url = $2
    after_href = $3

    # Skip if:
    # - Internal link (starts with / or #)
    # - Already an archive.org link
    # - Link to same domain
    # - Mailto link
    # - JavaScript link
    skip_link = url.start_with?('/') ||
                url.start_with?('#') ||
                url.include?('archive.org') ||
                url.include?(site_domain) ||
                url.start_with?('mailto:') ||
                url.start_with?('javascript:')

    if skip_link
      # Return original link unchanged
      "<a #{before_href}href=\"#{url}\"#{after_href}>"
    else
      # Wrap with archive.org using post year
      archived_url = "https://web.archive.org/web/#{post_year}*/#{url}"
      "<a #{before_href}href=\"#{archived_url}\"#{after_href}>"
    end
    end

    # Reconstruct the output with templates/interactions unchanged
    post.output = before_article + article_content + after_article
  else
    # If article tag not found, don't process anything
    # (this shouldn't happen in normal posts)
  end
end
