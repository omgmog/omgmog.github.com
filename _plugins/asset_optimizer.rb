require 'terser'
require 'htmlcompressor'

module Jekyll
  class AssetOptimizer < Generator
    safe true
    priority :low

    def generate(site)
      return unless ENV['JEKYLL_ENV'] == 'production'

      Jekyll::Hooks.register :site, :post_write do |site|
        optimize_javascript(site)
        optimize_html(site)
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
  end
end
