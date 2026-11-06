require "cgi"
require_relative "webmention_policy"

module Jekyll
  class RecentWebmentionsGenerator < Generator
    safe true
    priority :low

    AUTHOR_DOMAINS    = WebmentionPolicy::OWN_MARKERS
    AUTHOR_GH_LOGIN   = WebmentionPolicy::POLICY["github_login"]
    AUTHOR_DISPLAY    = "Max Glenister".freeze
    CONVERSATIONAL    = %w[in-reply-to mention-of like-of bookmark-of repost-of].freeze
    SITE_DOMAIN       = "blog.omgmog.net".freeze
    LIMIT             = 5

    def generate(site)
      mentions = collect_webmentions(site)
      mentions += collect_github_comments(site)

      # The sidebar is about other people's interactions, not my own posts.
      # Filtered before the limit so the list still fills up.
      mentions.reject! { |m| author?(m) }

      # A copy of one of my posts mentioning it is not an interaction either.
      synd = WebmentionPolicy.syndication_keys(*site.posts.docs.map { |d| d.data["syndication"] })
      mentions.reject! { |m| m["_source"] == "webmention" && WebmentionPolicy.syndicated?(m, synd) }

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
          # Silo likes/reposts/bookmarks are only ever counted, never listed.
          next if WebmentionPolicy.mode(m) == "count"
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
      else
        # One icon for every plain mention. It used to switch to a megaphone when the mention had a named
        # author, which read as two kinds of "mentioned". (The megaphone is kept for my own social site.)
        "icon-share-2"
      end
    end

    def display_name(mention)
      if mention["_source"] == "github"
        return AUTHOR_DISPLAY if (mention.dig("user", "login") || "").downcase == AUTHOR_GH_LOGIN
        mention.dig("user", "login") || ""
      else
        name = mention.dig("author", "name")
        return AUTHOR_DISPLAY if author?(mention)
        if WebmentionPolicy.mode(mention) == "link"
          return "someone on #{WebmentionPolicy.host_label(mention)}"
        end
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

    # Every entry is a chip: the type icon and the post it relates to. Who did
    # what (and when) is in the tooltip and the screen-reader text. The chip
    # links to the post's interactions; the mention itself is listed there.
    def render_mention(mention)
      source       = mention["_source"]
      related_post = mention["related_post"]

      if source == "github"
        return nil unless mention["author_name"].to_s != "" && mention["link_url"].to_s != ""
        kind = "comment"
        data_attrs = "data-source=\"github\" data-platform=\"#{mention["platform"]}\""
      elsif mention["wm-target"] && mention["author_name"]
        wm_type    = case mention["wm-property"]
                     when "in-reply-to"  then "reply"
                     when "like-of"      then "like"
                     when "bookmark-of"  then "bookmark"
                     when "repost-of"    then "repost"
                     else "mention"
                     end
        css_class  = "activity__item #{wm_type}#{" is-author" if mention["is_author"]}"
        data_attrs = "data-source=\"webmention\" data-platform=\"#{mention["platform"]}\""
      else
        return nil
      end

      post_href   = related_post ? related_post.url : mention["post_url"].to_s
      post_label  = related_post ? related_post.data["title"].to_s : "<code>#{mention["post_url"]}</code>"
      post_link   = "<a href=\"#{post_href}\" class=\"post-link\">#{post_label}</a>"
      # The link goes to wherever the mention lives, which is another site: open it in a new tab and tell search
      # engines not to follow it. (My own sites, which can appear here when I reply, stay as plain links.)
      external    = mention["link_url"].to_s =~ %r{\Ahttps?://} && AUTHOR_DOMAINS.none? { |d| mention["link_url"].include?(d) }
      link_attrs  = external ? " rel=\"nofollow noopener\" target=\"_blank\"" : ""
      author_link = "<a href=\"#{mention["link_url"]}\"#{link_attrs} class=\"author-link activity__who\">#{mention["author_name"]}</a>"
      date_str    = begin; Date.parse(mention["date"]).strftime("%-d %B %Y"); rescue; mention["date"].to_s; end

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
              <div>
                <p>#{content}</p>
                <time class="meta" datetime="#{mention["date"]}">#{date_str}</time>
              </div>
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
