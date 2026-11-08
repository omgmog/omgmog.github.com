module Jekyll
  class CategoryPageGenerator < Generator
    safe true
    priority :lowest # after AllPostsGenerator (all_posts.rb) populates all_posts_and_lwal

    def generate(site)
      docs = site.data["all_posts_and_lwal"] || []
      keys = docs.map { |doc| doc.data["category"] }.compact.uniq

      keys.each do |key|
        site.pages << CategoryPage.new(site, key, docs.select { |d| d.data["category"] == key })
      end
    end
  end

  class CategoryPage < Page
    def initialize(site, key, docs)
      @site = site
      @base = site.source
      @dir  = File.join("category", key)
      @name = "index.html"

      process(@name)
      read_yaml(File.join(@base, "_layouts"), "category.html")

      cat = site.data.dig("categories", key)
      @data["key"]   = key
      @data["hfeed"] = true
      @data["cat"]   = cat
      @data["title"] = cat && cat["name"] || key

      years = docs.map { |d| d.date.year }
      @data["year_range"] = [years.min, years.max].uniq.join("–")
      @data["common_tags"] = docs.flat_map { |d| Array(d.data["tags"]) }
                                 .tally.sort_by { |name, n| [-n, name] }.first(10)
                                 .map { |name, n| { "name" => name, "count" => n } }
    end
  end
end
