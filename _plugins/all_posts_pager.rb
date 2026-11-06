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

      # Neighbours within a series (e.g. Cardboctober), for its own pager.
      all.select { |doc| doc.data['series'] }.group_by { |doc| doc.data['series'] }.each_value do |docs|
        chronological = docs.sort_by { |doc| doc.date.to_i }
        chronological.each_with_index do |doc, i|
          doc.data['series_part']     = i + 1
          doc.data['series_total']    = chronological.length
          doc.data['series_previous'] = i > 0 ? chronological[i - 1] : nil
          doc.data['series_next']     = i < chronological.length - 1 ? chronological[i + 1] : nil
        end
      end

      # Same-category neighbours, for the post pager ("Previous/Next in
      # <category>") and the "Filed under" sidebar thread.
      all.group_by { |doc| doc.data['category'] }.each_value do |docs|
        chronological = docs.sort_by { |doc| doc.date.to_i } # ascending

        chronological.each_with_index do |doc, i|
          doc.data['category_start']    = chronological.first
          doc.data['category_previous'] = i > 0 ? chronological[i - 1] : nil
          doc.data['category_next']     = i < chronological.length - 1 ? chronological[i + 1] : nil

          # Up to 3 consecutive posts (chronological), centred on this one,
          # shifted toward whichever side has more when near either end —
          # so a category with 3+ posts always shows 3, not fewer.
          window_size = [3, chronological.length].min
          start_idx = [i - 1, 0].max
          end_idx = start_idx + window_size - 1
          if end_idx > chronological.length - 1
            end_idx = chronological.length - 1
            start_idx = [end_idx - window_size + 1, 0].max
          end
          doc.data['category_thread'] = chronological[start_idx..end_idx]
          # Whether the category carries on past either end of that window, for the thread's fading lines
          doc.data['category_thread_before'] = start_idx > 0
          doc.data['category_thread_after']  = end_idx < chronological.length - 1
        end
      end
    end
  end
end
