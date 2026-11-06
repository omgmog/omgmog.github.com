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

    # Rendered as a chip rather than a full row.
    def chip_item?(mention)
      WebmentionPolicy.pointer?(mention) || mention["_mode"] == "link"
    end

    def archived_sort_date(comment)
      Date.parse(comment["date"].to_s).iso8601
    rescue ArgumentError, TypeError
      ""
    end

    def generate(site)
      wm_data = site.data["webmentions"] || {}
      gh_data = site.data["github_comments"] || {}

      site.documents.each do |post|
        next unless post.data["content_type"] == "article"
        next if post.data["published"] == false

        keys = [post.url, *post.data["alternate_urls"]].compact.uniq
        page_mentions = keys.flat_map { |url| wm_data[url] || [] }
          .uniq { |m| m["wm-id"] || m["url"] }

        page_mentions.each { |m| m["_mode"] = WebmentionPolicy.mode(m) }

        # Copies of this post that mention it are the "Syndicated on" row, not discussion.
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

        by_date = ->(m) { m["sort_date"] || m["wm-received"] || m["published"] || m["created_at"] || "" }

        external = wm_feed.sort_by(&by_date)
        pointers, discussion = external.partition { |m| WebmentionPolicy.pointer?(m) }
        reply_chips, replies = discussion.partition { |m| chip_item?(m) }
        comments = static_comments.sort_by(&by_date)
        archived = (post.data["archived_comments"] || []).map do |c|
          c.merge("sort_date" => archived_sort_date(c))
        end

        # Interactions: shares and link-only mentions (chips), next to the
        # reaction counts. Discussion: link-only replies as chips, then replies
        # and mentions that carry content, then the comment thread; each part in
        # date order.
        post.data["_wm_shared"]      = pointers
        post.data["_wm_external"]    = reply_chips + replies
        post.data["_wm_comments"]    = comments
        # Pointers (_wm_shared) and link-only replies (_wm_reply_chips) are rendered
        # as chips; the discussion timeline is date-ordered with archived comments.
        page_mentions.each { |m| m["_pointer"] = false }
        pointers.each { |m| m["_pointer"] = true }
        timeline = archived + pointers + reply_chips + replies + comments
        post.data["_wm_merged_feed"] = timeline.sort_by(&by_date)
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
