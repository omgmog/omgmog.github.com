module Jekyll
  class RelatedPostsGenerator < Generator
    safe true
    priority :low

    LIMIT = 8

    def generate(site)
      posts = site.posts.docs

      posts.each do |post|
        tags = post.data['tags'] || []

        scored = posts.reject { |p| p.url == post.url }.map do |candidate|
          shared = ((candidate.data['tags'] || []) & tags).length
          [candidate, shared]
        end

        # Any shared tag qualifies, strongest first: the layout shows 3, after dropping posts this one already
        # links to or is linked from (see backlinks.rb), so one-tag matches only backfill what is left.
        scored.select! { |_, score| score >= 1 }
        scored.sort_by! { |candidate, score| [-score, -candidate.date.to_i] }

        post.data['related_posts'] = scored.first(LIMIT).map(&:first)
      end
    end
  end
end
