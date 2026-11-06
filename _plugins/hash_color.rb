module Jekyll
  module HashColorFilter
    # Deterministic HSL hue (0-359) from a name/username, for avatar colour.
    # Fixed saturation/lightness (set where it's used) keeps white text
    # readable across the whole hue range.
    def hash_hue(input)
      # A plain byte sum clusters badly (most names land in a narrow band of
      # similar sums) — a polynomial hash (like Java's String#hashCode)
      # mixes each byte's position in, spreading names across the hue wheel.
      hash = 0
      input.to_s.each_byte { |b| hash = (hash * 31 + b) & 0xFFFFFFFF }
      hash % 360
    end
  end
end

Liquid::Template.register_filter(Jekyll::HashColorFilter)
