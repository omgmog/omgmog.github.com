module Jekyll
  class RecentPostsGenerator < Generator
    safe true
    priority :low

    LIMIT = 6

    def generate(site)
      site.data['recent_posts'] = site.posts.docs.sort_by { |p| -p.date.to_i }.first(LIMIT)
    end
  end
end
