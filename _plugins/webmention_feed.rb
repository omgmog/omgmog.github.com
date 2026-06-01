module Jekyll
  class WebmentionFeedGenerator < Generator
    safe true
    priority :low

    CONVERSATIONAL = %w[in-reply-to mention-of].freeze
    REACTIONS      = %w[like-of bookmark-of repost-of].freeze

    def generate(site)
      wm_data = site.data["webmentions"] || {}
      gh_data = site.data["github_comments"] || {}

      site.posts.docs.each do |post|
        next if post.data["published"] == false

        page_mentions = wm_data[post.url] || []

        wm_feed = page_mentions
          .select { |m| CONVERSATIONAL.include?(m["wm-property"]) }
          .sort_by { |m| m["wm-received"] || m["published"] || "" }

        wm_likes = page_mentions
          .select { |m| REACTIONS.include?(m["wm-property"]) }
          .sort_by { |m| m["wm-received"] || m["published"] || "" }
          .uniq { |m| m.dig("author", "url") || m.dig("author", "name") || m["url"] }

        issue_key  = post.data["comments_issue"].to_s
        static_issue    = issue_key != "" ? gh_data[issue_key] : nil
        static_comments = static_issue&.dig("comments") || []
        gh_state        = static_issue&.dig("state") || "closed"

        merged = (wm_feed + static_comments).sort_by do |m|
          m["sort_date"] || m["wm-received"] || m["created_at"] || ""
        end

        post.data["_wm_merged_feed"] = merged
        post.data["_wm_likes"]       = wm_likes
        post.data["_wm_js"] = {
          "wm_ids"   => page_mentions.map { |m| m["wm-id"] }.compact.join(","),
          "gh_ids"   => static_comments.map { |c| c["id"] }.compact.join(","),
          "wm_conv"  => wm_feed.size,
          "gh_state" => gh_state
        }
      end
    end
  end
end
