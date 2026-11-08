require "json"
require "cgi"

# Builds each page's JSON-LD (schema.org) just before it renders, so generated pages (tags, categories, years) and the
# lwal and cardboctober collections get it too. _layouts/core.html prints page.ld_json.
module Jekyll
  module LdJson
    ARTICLE_COLLECTIONS = %w[posts lwal cardboctober].freeze
    PERSON_ID = "https://omgmog.net/#me".freeze   # the same Person on omgmog.net and social.omgmog.net

    module_function

    def home(site)
      "#{site.config['url']}/"
    end

    def person(site)
      urls = (site.data.dig("author", "urls") || []).map { |u| u["link"] }.reject { |l| l.to_s.start_with?("mailto:") }
      {
        "@type"  => "Person",
        "@id"    => PERSON_ID,
        "name"   => site.data.dig("author", "name"),
        "url"    => site.data.dig("author", "home"),
        "image"  => "#{site.config['assets_url']}/images/max-2025.webp",
        "sameAs" => urls + [home(site)]
      }
    end

    def site_ref(site)
      { "@type" => "WebSite", "@id" => "#{home(site)}#website", "name" => site.config["title"], "url" => home(site) }
    end

    def clean_description(text, limit = 160)
      CGI.unescapeHTML(text.to_s.gsub(/<[^>]+>/, "").strip).slice(0, limit)
    end

    def article(doc)
      site = doc.site
      url  = "#{site.config['url']}#{doc.url}"
      description =
        if doc.data["description"].to_s != ""
          CGI.unescapeHTML(doc.data["description"])
        elsif doc.data["excerpt"]
          clean_description(doc.data["excerpt"].content)
        else
          site.data.dig("author", "bio").to_s
        end

      data = {
        "@context"         => "https://schema.org",
        "@type"            => "BlogPosting",
        "@id"              => "#{url}#article",
        "mainEntityOfPage" => { "@type" => "WebPage", "@id" => url },
        "headline"         => doc.data["title"],
        "datePublished"    => doc.date.xmlschema,
        "url"              => url,
        "description"      => description,
        "inLanguage"       => "en-GB",
        "author"           => person(site),
        "publisher"        => person(site),
        "isPartOf"         => site_ref(site)
      }
      data["dateModified"] = doc.data["last_modified_at"].xmlschema if doc.data["last_modified_at"]
      data["image"]        = "#{url_base(site)}/images/og/#{doc.data['slug']}.png" if doc.data["slug"] && doc.data["layout"] == "post"
      tags = Array(doc.data["tags"])
      data["keywords"]     = tags.join(", ") unless tags.empty?
      section = site.data.dig("categories", doc.data["category"], "name")
      data["articleSection"] = section if section
      JSON.pretty_generate(data)
    end

    def url_base(site)
      site.config["url"].to_s
    end

    def website(site)
      JSON.pretty_generate(
        "@context"        => "https://schema.org",
        "@type"           => "WebSite",
        "@id"             => "#{home(site)}#website",
        "name"            => site.config["title"],
        "url"             => home(site),
        "inLanguage"      => "en-GB",
        "creator"         => person(site),
        "publisher"       => { "@id" => PERSON_ID },
        "potentialAction" => {
          "@type"       => "SearchAction",
          "target"      => "#{home(site)}search/?q={search_term}",
          "query-input" => "required name=search_term"
        }
      )
    end

    # Tag, category and year pages list posts
    def collection_page(page)
      site = page.site
      data = {
        "@context"   => "https://schema.org",
        "@type"      => "CollectionPage",
        "name"       => page.data["title"],
        "url"        => "#{site.config['url']}#{page.url}",
        "isPartOf"   => site_ref(site),
        "author"     => person(site)
      }
      data["description"] = page.data["description"] if page.data["description"].to_s != ""
      JSON.pretty_generate(data)
    end

    def webpage(page)
      site = page.site
      data = {
        "@context" => "https://schema.org",
        "@type"    => "WebPage",
        "name"     => page.data["title"] || site.config["title"],
        "url"      => "#{site.config['url']}#{page.url}",
        "isPartOf" => site_ref(site),
        "author"   => person(site)
      }
      data["description"] = page.data["description"] if page.data["description"].to_s != ""
      JSON.pretty_generate(data)
    end
  end

  Hooks.register :documents, :pre_render do |doc|
    next unless doc.collection && LdJson::ARTICLE_COLLECTIONS.include?(doc.collection.label)
    next if doc.data["published"] == false
    doc.data["ld_json"] = LdJson.article(doc)
  end

  # A Page's liquid data is a snapshot made before this hook runs, so the JSON-LD goes into the payload's page too.
  Hooks.register :pages, :pre_render do |page, payload|
    next if page.data["layout"].nil? || page.data["layout"].to_s == "null"   # redirect stubs, feeds, etc. have no layout
    json =
      if page.url == "/index.html" || page.url == "/"
        LdJson.website(page.site)
      elsif page.data["tag"] || page.data["key"] || page.data["year"]
        LdJson.collection_page(page)
      else
        LdJson.webpage(page)
      end
    page.data["ld_json"] = json
    payload["page"]["ld_json"] = json
  end
end
