module Jekyll
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      site.tags.each do |tag, posts|
        site.pages << TagPage.new(site, tag, posts)
      end
    end
  end

  class TagPage < Page
    def initialize(site, tag, posts)
      @site = site
      @base = site.source
      @dir  = File.join('tags', Utils.slugify(tag))
      @name = 'index.html'

      process(@name)
      read_yaml(File.join(@base, '_layouts'), 'tag.html')

      @data['tag']   = tag
      @data['hfeed'] = true
      @data['title'] = "##{tag}"

      # Categories the tagged posts are filed under, and tags that appear
      # alongside this one, both most-used first.
      top = ->(names) { names.tally.sort_by { |name, n| [-n, name] }.map { |name, n| { 'name' => name, 'count' => n } } }
      @data['categories']   = top.call(posts.map { |d| d.data['category'] }.compact)
      @data['related_tags'] = top.call(posts.flat_map { |d| Array(d.data['tags']) } - [tag]).first(10)
    end
  end
end
