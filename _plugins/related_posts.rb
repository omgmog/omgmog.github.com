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

        min_score = tags.length >= 3 ? 2 : 1
        scored.select! { |_, score| score >= min_score }
        scored.sort_by! { |candidate, score| [-score, -candidate.date.to_i] }

        post.data['related_posts'] = scored.first(LIMIT).map(&:first)
      end
    end
  end
end
