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

        scored.select! { |_, score| score > 0 }
        scored.sort_by! { |_, score| -score }

        post.data['related_posts'] = scored.first(LIMIT).map(&:first)
      end
    end
  end
end
