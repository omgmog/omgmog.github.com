# Plugin to automatically add target="_blank" to external links
Jekyll::Hooks.register :posts, :post_render do |post|
  site_url = post.site.config['url'] || ''
  site_baseurl = post.site.config['baseurl'] || ''
  site_domain = site_url.gsub(/https?:\/\//, '')

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
    # - Link to same domain
    # - Mailto link
    # - JavaScript link
    skip_link = url.start_with?('/') ||
                url.start_with?('#') ||
                url.include?(site_domain) ||
                url.start_with?('mailto:') ||
                url.start_with?('javascript:')

    if skip_link
      # Return original link unchanged
      "<a #{before_href}href=\"#{url}\"#{after_href}>"
    else
      # Add target="_blank" if not already present
      if after_href.include?('target=')
        "<a #{before_href}href=\"#{url}\"#{after_href}>"
      else
        "<a #{before_href}href=\"#{url}\"#{after_href} target=\"_blank\">"
      end
    end
    end

    # Reconstruct the output with templates/interactions unchanged
    post.output = before_article + article_content + after_article
  else
    # If article tag not found, don't process anything
    # (this shouldn't happen in normal posts)
  end
end
