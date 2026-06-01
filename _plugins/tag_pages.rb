module Jekyll
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      site.tags.each_key do |tag|
        site.pages << TagPage.new(site, tag)
      end
    end
  end

  class TagPage < Page
    def initialize(site, tag)
      @site = site
      @base = site.source
      @dir  = File.join('tags', Utils.slugify(tag))
      @name = 'index.html'

      process(@name)
      read_yaml(File.join(@base, '_layouts'), 'tag.html')

      @data['tag']   = tag
      @data['title'] = "##{tag}"
    end
  end
end
