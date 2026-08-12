module Jekyll
  class PostsByUrlIndexGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.data['posts_by_url'] = site.posts.docs.each_with_object({}) do |post, index|
        index[post.url] = post
      end
    end
  end
end
