require "set"

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

    def generate(site)
      counts = {}

      (site.data["webmentions"] || {}).each do |url, mentions|
        next unless mentions.is_a?(Array)

        tally = Hash.new(0)
        seen_reaction_authors = Set.new

        mentions.each do |m|
          key = PROPERTY_MAP[m["wm-property"]]
          next unless key

          if REACTIONS.include?(m["wm-property"])
            author_key = m.dig("author", "url") || m.dig("author", "name") || m["url"]
            next if author_key && seen_reaction_authors.include?(author_key)
            seen_reaction_authors.add(author_key) if author_key
          end

          tally[key] += 1
        end

        counts[url] = tally unless tally.empty?
      end

      site.data["webmention_counts"] = counts
    end
  end
end
