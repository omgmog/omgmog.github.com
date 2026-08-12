module Jekyll
  class AllPostsPagerGenerator < Generator
    safe true
    priority :low

    def generate(site)
      all = site.posts.docs + (site.collections['cardboctober']&.docs || []) + (site.collections['lwal']&.docs || [])
      all.sort_by! { |doc| -doc.date.to_i }

      all.each_with_index do |doc, i|
        doc.data['all_next'] = i > 0 ? all[i - 1] : nil
        doc.data['all_previous'] = i < all.length - 1 ? all[i + 1] : nil
      end
    end
  end
end
