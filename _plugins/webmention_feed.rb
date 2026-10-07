require_relative "webmention_policy"

module Jekyll
  class WebmentionFeedGenerator < Generator
    safe true
    priority :low

    CONVERSATIONAL = %w[in-reply-to mention-of].freeze
    REACTIONS      = %w[like-of bookmark-of repost-of].freeze

    def reddit_bookmark?(mention)
      return false unless mention["wm-property"] == "bookmark-of"
      !!((mention["url"].to_s + mention["wm-source"].to_s) =~ %r{reddit\.com/r/}i)
    end

    def hn_bookmark?(mention)
      return false unless mention["wm-property"] == "bookmark-of"
      !!((mention["url"].to_s + mention["wm-source"].to_s) =~ %r{news\.ycombinator\.com}i)
    end

    def lobsters_repost?(mention)
      return false unless mention["wm-property"] == "repost-of"
      !!((mention["url"].to_s + mention["wm-source"].to_s) =~ %r{lobste\.rs}i)
    end

    def rich_bookmark?(mention)
      WebmentionPolicy.shared_link?(mention)
    end

    # Link-only items from the same host collapse into one chip ("reddit.com
    # x6") that expands to the individual links, so a host never appears twice.
    # Called separately for the pointers (mentions) and for the link-only replies.
    # The group sits where its first item was. That item carries _group_size,
    # _group_kind and _group_rest; the rest are flagged _grouped so the template
    # skips them. Flags are cleared first because site.data persists between
    # regenerations.
    def group_link_hosts!(feed)
      feed.each do |m|
        %w[_group_size _group_kind _group_rest _grouped].each { |k| m.delete(k) }
      end

      feed.select { |m| groupable?(m) }.group_by { |m| WebmentionPolicy.host_label(m) }.each_value do |items|
        next if items.size < 2
        items.first["_group_size"] = items.size
        items.first["_group_kind"] = items.first["wm-property"] == "in-reply-to" ? "replies" : "mentions"
        items.first["_group_rest"] = items.drop(1)
        items.drop(1).each { |m| m["_grouped"] = true }
      end
    end

    # Rendered as a chip rather than a full row.
    def chip_item?(mention)
      WebmentionPolicy.pointer?(mention) || mention["_mode"] == "link"
    end

    # Chips that are not shares or community posts, so same-host ones can merge.
    def groupable?(mention)
      return false if mention["community"] || WebmentionPolicy.shared_link?(mention)
      return false unless CONVERSATIONAL.include?(mention["wm-property"])

      WebmentionPolicy.pointer?(mention) || mention["_mode"] == "link"
    end

    def generate(site)
      wm_data = site.data["webmentions"] || {}
      gh_data = site.data["github_comments"] || {}

      site.posts.docs.each do |post|
        next if post.data["published"] == false

        keys = [post.url, *post.data["alternate_urls"]].compact.uniq
        page_mentions = keys.flat_map { |url| wm_data[url] || [] }
          .uniq { |m| m["wm-id"] || m["url"] }

        page_mentions.each { |m| m["_mode"] = WebmentionPolicy.mode(m) }

        # Copies of this post that mention it are the "Also on" row, not discussion.
        synd = WebmentionPolicy.syndication_keys(post.data["syndication"])

        wm_feed = page_mentions
          .reject { |m| WebmentionPolicy.syndicated?(m, synd) }
          .select { |m| CONVERSATIONAL.include?(m["wm-property"]) || rich_bookmark?(m) }
          .sort_by { |m| m["wm-received"] || m["published"] || "" }

        # Only reactions the sender chose to send are listed. Silo reactions
        # are counted (see webmention_counts.rb) but never shown.
        wm_likes = page_mentions
          .select { |m| REACTIONS.include?(m["wm-property"]) && !rich_bookmark?(m) && m["_mode"] == "full" }
          .sort_by { |m| m["wm-received"] || m["published"] || "" }
          .uniq { |m| WebmentionPolicy.author_key(m) }

        issue_key  = post.data["comments_issue"].to_s
        static_issue    = issue_key != "" ? gh_data[issue_key] : nil
        static_comments = static_issue&.dig("comments") || []
        gh_state        = static_issue&.dig("state") || "closed"

        by_date = ->(m) { m["sort_date"] || m["wm-received"] || m["created_at"] || "" }

        external = wm_feed.sort_by(&by_date)
        pointers, discussion = external.partition { |m| WebmentionPolicy.pointer?(m) }
        group_link_hosts!(pointers)
        group_link_hosts!(discussion)
        reply_chips, replies = discussion.partition { |m| chip_item?(m) }
        comments = static_comments.sort_by(&by_date)

        # Interactions: shares and link-only mentions (chips), next to the
        # reaction counts. Discussion: link-only replies as chips, then replies
        # and mentions that carry content, then the comment thread; each part in
        # date order.
        post.data["_wm_shared"]      = pointers
        post.data["_wm_external"]    = reply_chips + replies
        post.data["_wm_comments"]    = comments
        post.data["_wm_merged_feed"] = pointers + reply_chips + replies + comments
        post.data["_wm_likes"]       = wm_likes
        post.data["_wm_js"] = {
          "wm_ids"   => page_mentions.map { |m| m["wm-id"] }.compact.join(","),
          "gh_ids"   => static_comments.map { |c| c["id"] }.compact.join(","),
          "wm_conv"  => discussion.size,
          "gh_state" => gh_state
        }
      end
    end
  end
end
