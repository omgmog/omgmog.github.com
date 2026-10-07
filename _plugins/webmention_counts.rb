require "set"
require_relative "webmention_policy"

module Jekyll
  class WebmentionCountsGenerator < Generator
    safe true
    priority :low

    PROPERTY_MAP = {
      "in-reply-to"  => "replies",
      "mention-of"   => "mentions",
      "like-of"      => "likes",
      "bookmark-of"  => "bookmarks",
      "repost-of"    => "reposts"
    }.freeze

    REACTIONS = %w[like-of bookmark-of repost-of].freeze

    def tally_for(mentions)
      tally = Hash.new(0)
      seen_reaction_authors = Set.new

      mentions.each do |m|
        key = PROPERTY_MAP[m["wm-property"]]
        next unless key

        # Shares and link-only mentions are listed under Interactions as chips;
        # they are counted once, as "shared", not as bookmarks or mentions.
        if WebmentionPolicy.pointer?(m)
          tally["shared"] += 1
          next
        end

        if REACTIONS.include?(m["wm-property"])
          author_key = WebmentionPolicy.author_key(m)
          next if author_key && seen_reaction_authors.include?(author_key)
          seen_reaction_authors.add(author_key) if author_key
        end

        tally[key] += 1
      end

      tally
    end

    def generate(site)
      wm_data = site.data["webmentions"] || {}
      counts = {}

      site.posts.docs.each do |post|
        keys = [post.url, *post.data["alternate_urls"]].compact.uniq
        mentions = keys.flat_map { |url| wm_data[url] || [] }
          .uniq { |m| m["wm-id"] || m["url"] }
        synd = WebmentionPolicy.syndication_keys(post.data["syndication"])
        mentions = mentions.reject { |m| WebmentionPolicy.syndicated?(m, synd) }
        next if mentions.empty?

        tally = tally_for(mentions)
        counts[post.url] = tally unless tally.empty?
      end

      site.data["webmention_counts"] = counts
    end
  end
end
