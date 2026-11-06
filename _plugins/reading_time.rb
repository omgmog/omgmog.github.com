module Jekyll
  class ReadingTimeGenerator < Generator
    safe true
    priority :low

    WORDS_PER_MINUTE = 200

    # A Generator (pre-render), not a :post_render hook — a page needs its
    # own reading_time available while ITS layout renders, not just when
    # other, already-rendered pages look it up later (e.g. site.data.all_posts).
    def generate(site)
      site.documents.each do |doc|
        next unless doc.data["content_type"] == "article"

        words = doc.content.to_s.gsub(/<[^>]+>/, " ").split.length
        doc.data["reading_time"] = [(words / WORDS_PER_MINUTE.to_f).ceil, 1].max
      end
    end
  end
end
