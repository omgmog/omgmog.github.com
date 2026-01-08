require 'terser'
require 'htmlcompressor'
require 'mini_magick'

module Jekyll
  class AssetOptimizer < Generator
    safe true
    priority :low

    def generate(site)
      return unless ENV['JEKYLL_ENV'] == 'production'

      Jekyll::Hooks.register :site, :post_write do |site|
        optimize_javascript(site)
        optimize_html(site)
        optimize_images(site)
      end
    end

    def optimize_javascript(site)
      js_files = Dir.glob(File.join(site.dest, 'assets/*.js')).reject { |f| f.end_with?('.min.js') }
      return if js_files.empty?

      total_saved = 0
      js_files.each do |js_file|
        original = File.read(js_file)
        minified = Terser.new.compile(original)
        File.write(js_file, minified)

        saved = original.size - minified.size
        total_saved += saved
        Jekyll.logger.info "Asset Optimizer:", "Minified #{File.basename(js_file)} (#{original.size} → #{minified.size} bytes)"
      end

      Jekyll.logger.info "Asset Optimizer:", "Total JS saved: #{total_saved} bytes across #{js_files.size} file(s)"
    end

    def optimize_html(site)
      html_files = Dir.glob(File.join(site.dest, '**/*.html'))

      compressor = HtmlCompressor::Compressor.new({
        remove_comments: true,
        remove_intertag_spaces: true,
        remove_multi_spaces: true,
        preserve_line_breaks: false
      })

      total_saved = 0
      html_files.each do |file|
        original = File.read(file)
        minified = compressor.compress(original)
        File.write(file, minified)

        total_saved += (original.size - minified.size)
      end

      Jekyll.logger.info "HTML Minifier:", "Minified #{html_files.size} files (saved #{total_saved} bytes)"
    end

    def optimize_images(site)
      image_files = Dir.glob(File.join(site.dest, 'images/**/*.{jpg,jpeg,png}')).reject { |f| f.include?('.webp') }
      return if image_files.empty?

      # Track existing WebP files to avoid conflicts
      existing_webp = Dir.glob(File.join(site.dest, 'images/**/*.webp')).map { |f| File.basename(f, '.webp') }.to_set

      total_webp_saved = 0
      total_compressed_saved = 0
      webp_count = 0
      compressed_count = 0
      skipped_count = 0

      image_files.each do |image_file|
        begin
          # Generate WebP with full original filename to prevent conflicts
          # e.g., cardboctober.jpg -> cardboctober.jpg.webp
          #       cardboctober.png -> cardboctober.png.webp
          webp_path = "#{image_file}.webp"

          # Check if source already has this exact WebP file
          source_webp = image_file.sub(site.dest, site.source) + '.webp'
          if File.exist?(source_webp)
            Jekyll.logger.debug "Image Optimizer:", "Skipping #{File.basename(image_file)} - WebP exists in source"
            skipped_count += 1
            next
          end

          # Generate WebP version
          unless File.exist?(webp_path)
            image = MiniMagick::Image.open(image_file)
            original_size = File.size(image_file)

            # Resize to max 800px width (maintain aspect ratio, don't upscale)
            image.resize '800>'
            image.format 'webp'
            image.quality 85
            image.write webp_path

            webp_size = File.size(webp_path)
            total_webp_saved += (original_size - webp_size)
            webp_count += 1
          end

          # Compress original losslessly
          original_size = File.size(image_file)
          image = MiniMagick::Image.open(image_file)

          if image.type =~ /jpe?g/i
            # JPEG lossless optimization
            image.combine_options do |c|
              c.strip              # Remove EXIF data
              c.interlace "Plane"  # Progressive JPEG
              c.quality 85         # Good quality/size balance
            end
            image.write image_file
          elsif image.type =~ /png/i
            # PNG lossless optimization
            image.combine_options do |c|
              c.strip              # Remove metadata
            end
            image.write image_file
          end

          new_size = File.size(image_file)
          saved = original_size - new_size
          if saved > 0
            total_compressed_saved += saved
            compressed_count += 1
          end

        rescue => e
          Jekyll.logger.warn "Image Optimizer:", "Failed to optimize #{File.basename(image_file)}: #{e.message}"
        end
      end

      Jekyll.logger.info "Image Optimizer:", "Generated #{webp_count} WebP files (saved #{total_webp_saved} bytes)"
      Jekyll.logger.info "Image Optimizer:", "Compressed #{compressed_count} originals (saved #{total_compressed_saved} bytes)"
      Jekyll.logger.info "Image Optimizer:", "Skipped #{skipped_count} files (source WebP exists)"
      Jekyll.logger.info "Image Optimizer:", "Total image savings: #{total_webp_saved + total_compressed_saved} bytes"
    end
  end
end
