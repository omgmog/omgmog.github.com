module Jekyll
  class RecentWebmentionsGenerator < Generator
    safe true
    priority :low

    AUTHOR_DOMAINS    = %w[omgmog.net omgmog.github.io twitter.com/omgmog indieweb.social/@omgmog].freeze
    AUTHOR_GH_LOGIN   = "omgmog".freeze
    AUTHOR_DISPLAY    = "Max Glenister".freeze
    CONVERSATIONAL    = %w[in-reply-to mention-of].freeze
    SITE_DOMAIN       = "blog.omgmog.net".freeze
    LIMIT             = 10

    def generate(site)
      mentions = collect_webmentions(site)
      mentions += collect_github_comments(site)

      mentions.sort_by! { |m| m["sort_date"] || "" }
      mentions.reverse!
      recent = mentions.first(LIMIT)

      # Resolve the related post for each mention once, here in Ruby
      recent.each do |m|
        m["related_post"] = find_post(site, m)
        m["is_author"]    = author?(m)
        m["platform"]     = platform(m)
        m["icon"]         = icon(m)
        m["author_name"]  = display_name(m)
        m["link_url"]     = link_url(m)
        m["date"]         = date(m)
        m["post_url"]     = post_url(m)
      end

      site.data["recent_webmentions"] = recent
    end

    private

    def collect_webmentions(site)
      result = []
      (site.data["webmentions"] || {}).each_value do |page_mentions|
        next unless page_mentions.is_a?(Array)
        page_mentions.each do |m|
          next unless CONVERSATIONAL.include?(m["wm-property"])
          next unless (m["wm-target"] || "").include?(SITE_DOMAIN)
          result << m.merge("_source" => "webmention")
        end
      end
      result
    end

    def collect_github_comments(site)
      result = []
      (site.data["github_comments"] || {}).each_value do |issue|
        next unless issue.is_a?(Hash) && issue["comments"].is_a?(Array)
        issue["comments"].each do |c|
          result << c.merge("_source" => "github", "sort_date" => c["created_at"])
        end
      end
      result
    end

    def find_post(site, mention)
      if mention["_source"] == "github"
        issue_num = nil
        (site.data["github_comments"] || {}).each do |num, issue|
          next unless issue.is_a?(Hash) && issue["comments"].is_a?(Array)
          if issue["comments"].any? { |c| c["id"] == mention["id"] }
            issue_num = num.to_s
            break
          end
        end
        return nil unless issue_num
        site.posts.docs.find { |p| p.data["comments_issue"].to_s == issue_num }
      else
        target = mention["wm-target"] || ""
        slug   = target.split("/").reject(&:empty?).last
        return nil unless slug
        site.posts.docs.find { |p| p.url.include?(slug) }
      end
    end

    def author?(mention)
      if mention["_source"] == "github"
        (mention.dig("user", "login") || "").downcase == AUTHOR_GH_LOGIN
      else
        url    = mention.dig("author", "url") || mention["url"] || ""
        source = mention["wm-source"] || ""
        AUTHOR_DOMAINS.any? { |d| url.include?(d) || source.include?(d) }
      end
    end

    def platform(mention)
      url    = mention["url"] || mention["wm-source"] || ""
      source = mention["wm-source"] || ""
      if url.include?("reddit.com")     then "reddit"
      elsif url.include?("twitter.com") then "twitter"
      elsif source.include?("brid.gy") then "mastodon"
      elsif mention["_source"] == "github" then "github"
      else "web"
      end
    end

    def icon(mention)
      if mention["_source"] == "github"
        "icon-message-circle"
      elsif mention["wm-property"] == "in-reply-to"
        "icon-reply"
      elsif display_name(mention) == (mention.dig("author", "name") || "")
        "icon-megaphone"
      else
        "icon-share"
      end
    end

    def display_name(mention)
      if mention["_source"] == "github"
        return AUTHOR_DISPLAY if (mention.dig("user", "login") || "").downcase == AUTHOR_GH_LOGIN
        mention.dig("user", "login") || ""
      else
        name = mention.dig("author", "name")
        return AUTHOR_DISPLAY if author?(mention)
        if name.nil? || name.empty?
          source = mention["wm-source"] || ""
          begin; URI.parse(source).host; rescue; source; end
        else
          name
        end
      end
    end

    def link_url(mention)
      if mention["_source"] == "github"
        mention["html_url"] || ""
      else
        mention["url"] || mention["wm-source"] || ""
      end
    end

    def date(mention)
      if mention["_source"] == "github"
        mention["created_at"] || ""
      else
        mention["published"] || mention["wm-received"] || ""
      end
    end

    def post_url(mention)
      post = mention["related_post"]
      return post.url if post
      target = mention["wm-target"] || ""
      target.split(SITE_DOMAIN).last || target
    end
  end
end
