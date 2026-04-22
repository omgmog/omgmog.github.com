module Jekyll
  module TagFilters
    def sort_tags_by_count(tags)
      now = Time.now
      tags.sort_by do |_name, posts|
        most_recent = posts.map(&:date).max
        years_since = (now - most_recent.to_time) / (365.25 * 86400)
        recency_weight = 1.0 / (years_since + 1.0)
        -(posts.length * recency_weight)
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::TagFilters)

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
