# One page per year at /archive/YYYY/ (every post and Cardboctober post from that year; the link roundups are in /category/lwal/).
# The Archive lists recent years in full and links older years to these pages.
module Jekyll
  class YearPageGenerator < Generator
    safe true
    priority :lowest # after AllPostsGenerator (all_posts.rb) populates all_posts_and_lwal

    def generate(site)
      docs  = site.data["all_posts"] || []
      years = docs.map { |d| d.date.year }.uniq.sort.reverse
      years.each_with_index do |year, i|
        newer = i > 0 ? years[i - 1] : nil
        site.pages << YearPage.new(site, year, docs.select { |d| d.date.year == year }, newer, years[i + 1])
      end
    end
  end

  class YearPage < Page
    def initialize(site, year, docs, newer, older)
      @site = site
      @base = site.source
      @dir  = File.join("archive", year.to_s)
      @name = "index.html"

      process(@name)
      read_yaml(File.join(@base, "_layouts"), "archive_year.html")

      @data["year"]  = year
      @data["title"] = year.to_s
      @data["docs"]  = docs
      @data["newer_year"] = newer
      @data["older_year"] = older
    end
  end
end
