module Jekyll
  class RecentWebmentionsGenerator < Generator
    safe true
    priority :low

    AUTHOR_DOMAINS    = %w[omgmog.net omgmog.github.io twitter.com/omgmog indieweb.social/@omgmog].freeze
    AUTHOR_GH_LOGIN   = "omgmog".freeze
    AUTHOR_DISPLAY    = "Max Glenister".freeze
    CONVERSATIONAL    = %w[in-reply-to mention-of like-of bookmark-of repost-of].freeze
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

      site.data["recent_webmentions"]      = recent
      site.data["sidebar_webmentions_html"] = render_sidebar_html(recent)
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
      elsif mention["wm-property"] == "like-of"
        "icon-heart"
      elsif mention["wm-property"] == "bookmark-of"
        "icon-bookmark"
      elsif mention["wm-property"] == "repost-of"
        "icon-repeat-2"
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

    def render_sidebar_html(recent)
      recent.map { |m| render_mention(m) }.compact.join("\n")
    end

    def render_mention(mention)
      source       = mention["_source"]
      related_post = mention["related_post"]

      if source == "github"
        return nil unless mention["author_name"].to_s != "" && mention["link_url"].to_s != ""
        css_class  = "webmention github#{" is-author" if mention["is_author"]}"
        data_attrs = "data-source=\"github\" data-platform=\"#{mention["platform"]}\""
      elsif mention["wm-target"] && mention["author_name"]
        wm_type    = case mention["wm-property"]
                     when "in-reply-to"  then "reply"
                     when "like-of"      then "like"
                     when "bookmark-of"  then "bookmark"
                     when "repost-of"    then "repost"
                     else "mention"
                     end
        css_class  = "webmention #{wm_type}#{" is-author" if mention["is_author"]}"
        data_attrs = "data-source=\"webmention\" data-platform=\"#{mention["platform"]}\""
      else
        return nil
      end

      post_href   = related_post ? related_post.url : mention["post_url"].to_s
      post_label  = related_post ? "<em>#{related_post.data["title"]}</em>" : "<code>#{mention["post_url"]}</code>"
      post_link   = "<a href=\"#{post_href}\" class=\"post-link\">#{post_label}</a>"
      author_link = "<a href=\"#{mention["link_url"]}\" class=\"author-link\"><strong>#{mention["author_name"]}</strong></a>"
      date_str    = begin; Date.parse(mention["date"]).strftime("%b %d, %Y"); rescue; mention["date"].to_s; end
      date_html   = "<small class=\"date\">#{date_str}</small>"

      content = if source == "github"
        "#{author_link} commented on #{post_link}"
      elsif mention["author_name"].to_s.empty?
        "#{post_link} shared on #{author_link}"
      elsif mention["wm-property"] == "in-reply-to"
        "#{author_link} replied to #{post_link}"
      elsif mention["wm-property"] == "like-of"
        "#{author_link} liked #{post_link}"
      elsif mention["wm-property"] == "bookmark-of"
        "#{author_link} bookmarked #{post_link}"
      elsif mention["wm-property"] == "repost-of"
        "#{author_link} reposted #{post_link}"
      else
        "#{author_link} mentioned #{post_link}"
      end

      <<~HTML.chomp
            <li class="#{css_class}" #{data_attrs}>
              <svg class="icon interaction-icon" aria-hidden="true"><use xlink:href="##{mention["icon"]}"></use></svg>
              <div class="mention-content">#{content} #{date_html}</div>
            </li>
      HTML
    end

    def post_url(mention)
      post = mention["related_post"]
      return post.url if post
      target = mention["wm-target"] || ""
      target.split(SITE_DOMAIN).last || target
    end
  end
end
