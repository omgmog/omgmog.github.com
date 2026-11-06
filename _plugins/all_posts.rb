module Jekyll
  class AllPostsGenerator < Generator
    safe true
    priority :low

    COLLECTIONS = %w[cardboctober lwal].freeze

    def generate(site)
      all = site.posts.docs + (site.collections['cardboctober']&.docs || [])
      site.data["all_posts"] = all.sort_by! { |doc| -doc.date.to_i }

      all_with_lwal = all  + (site.collections['lwal']&.docs || [])
      site.data["all_posts_and_lwal"] = all_with_lwal.sort_by! { |doc| -doc.date.to_i }
      site.data["category_counts"] = all_with_lwal.map { |doc| doc.data["category"] }.tally   # posts per category, for the counts in the templates
    end
  end
end
