module Jekyll
  class SortedTagsGenerator < Generator
    safe true
    priority :low

    def generate(site)
      now = Time.now
      sorted = site.tags.sort_by do |_name, posts|
        most_recent = posts.map(&:date).max
        years_since = (now - most_recent.to_time) / (365.25 * 86400)
        recency_weight = 1.0 / (years_since + 1.0)
        -(posts.length * recency_weight)
      end

      site.data['sorted_tags'] = sorted.map do |name, posts|
        { 'name' => name, 'count' => posts.length }
      end
    end
  end
end
