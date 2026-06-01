require "json"
require "cgi"

module Jekyll
  class LdJsonGenerator < Generator
    safe true
    priority :low

    def generate(site)
      @site     = site
      site_url  = site.config['url'].to_s
      home_url  = "#{site_url}/"

      site.posts.docs.each do |doc|
        next if doc.data['published'] == false
        doc.data['ld_json'] = post_schema(doc, site_url)
      end

      site.pages.each do |page|
        url = page.url == '/index.html' ? home_url : "#{site_url}#{page.url}"
        if page.url == '/index.html' || page.url == '/'
          page.data['ld_json'] = website_schema(home_url)
        else
          page.data['ld_json'] = webpage_schema(page, url)
        end
      end
    end

    private

    def post_schema(doc, site_url)
      url = "#{site_url}#{doc.url}"

      description = CGI.unescapeHTML(
        if doc.data['description'].to_s != ''
          doc.data['description']
        elsif doc.data['excerpt']
          doc.data['excerpt'].content.gsub(/<[^>]+>/, '').strip.slice(0, 160)
        else
          @site.data.dig('author', 'bio').to_s
        end
      )

      data = {
        '@context'        => 'https://schema.org',
        '@type'           => 'BlogPosting',
        'mainEntityOfPage' => { '@type' => 'WebPage', '@id' => url },
        'headline'        => doc.data['title'],
        'datePublished'   => doc.date.xmlschema,
        'url'             => url,
        'description'     => description,
        'author'          => author_entity,
        'publisher'       => author_entity
      }

      data['dateModified'] = doc.data['last_modified_at'].xmlschema if doc.data['last_modified_at']

      JSON.pretty_generate(data)
    end

    def website_schema(home_url)
      JSON.pretty_generate(
        '@context' => 'https://schema.org',
        '@type'    => 'WebSite',
        'name'     => @site.config['title'],
        'url'      => home_url,
        'creator'  => author_entity
      )
    end

    def webpage_schema(page, url)
      data = {
        '@context' => 'https://schema.org',
        '@type'    => 'WebPage',
        'name'     => page.data['title'] || @site.config['title'],
        'url'      => url,
        'author'   => author_entity
      }
      data['description'] = page.data['description'] if page.data['description'].to_s != ''
      JSON.pretty_generate(data)
    end

    def author_entity
      {
        '@type'  => 'Person',
        'name'   => @site.data.dig('author', 'name'),
        'url'    => @site.data.dig('author', 'home'),
        'sameAs' => (@site.data.dig('author', 'urls') || []).map { |u| u['link'] }
      }
    end
  end
end
