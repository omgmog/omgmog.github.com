require "cgi"
require "html_to_plain_text"

module Jekyll
  module TxtFormatFilters
    # Replace iframes with their URLs before main conversion
    def iframes_to_urls(input)
      return input unless input

      # Handle YouTube lazy-loading divs with data-src
      input = input.gsub(/<div[^>]+data-src=["']([^"']+)["'][^>]*>.*?<\/div>/im) do
        url = $1
        # Add https: if missing (template strips it)
        url = "https:#{url}" unless url.start_with?('http')
        "\n#{url}\n"
      end

      # Handle regular iframes
      input = input.gsub(/<iframe[^>]+src=["']([^"']+)["'][^>]*>.*?<\/iframe>/im) do
        url = $1
        # Add https: if missing (template strips it)
        url = "https:#{url}" unless url.start_with?('http')
        "\n#{url}\n"
      end

      input
    end

    # Replace images with their URLs before main conversion
    def images_to_urls(input)
      return input unless input

      site_url = @context.registers[:site].config['url']

      input.gsub(/<img[^>]+src=["']([^"']+)["'][^>]*>/i) do
        url = $1
        url = "#{site_url}#{url}" if url.start_with?('/')
        "\n[IMAGE: #{url}]\n"
      end
    end

    # Unwrap links to show as: text (url)
    # Only show URL if different from text (fixes redundancy)
    def unwrap_links(input)
      return input unless input

      site_url = @context.registers[:site].config['url']

      input.gsub(/<a[^>]+href=["']([^"']+)["'][^>]*>(.*?)<\/a>/im) do
        url = $1
        text = $2.strip

        # Make relative URLs absolute
        url = "#{site_url}#{url}" if url.start_with?('/')

        # Only show URL if different from text
        if text.downcase == url.downcase || text == url
          text
        else
          "#{text} (#{url})"
        end
      end
    end

    # Main HTML to plain text conversion using gem
    # Handles: headings, lists (with nesting), blockquotes, code blocks,
    # paragraphs, HTML entities, and structure preservation
    def html_to_plain_text_convert(input)
      return input unless input
      HtmlToPlainText.plain_text(input)
    end

    # Wrap long lines to 80 characters
    def wrap_lines(input, width = 80)
      return input unless input

      lines = input.split("\n")
      wrapped_lines = []

      lines.each do |line|
        # Don't wrap code blocks, blockquotes, separators, image markers, or blank lines
        if line =~ /^```|^    / ||
           line =~ /^(>\s|[=#-]{3,}|\[IMAGE:|^\s*$)/ ||
           line.length <= width
          wrapped_lines << line
        # Handle list items specially - wrap with indented continuation
        elsif line =~ /^(\s*)([-*+•])\s+(.+)$/
          leading_space = $1
          marker = $2
          text = $3

          # First line has marker, continuation lines align under text
          prefix = "#{leading_space}#{marker} "
          indent = " " * prefix.length

          # Extract and restore long URLs (preserve URL integrity)
          url_map = {}
          placeholder_index = 0
          text.gsub!(/\([^)]{20,}\)/) do |url_part|
            placeholder = "{{URL_#{placeholder_index}}}"
            url_map[placeholder] = url_part
            placeholder_index += 1
            placeholder
          end

          words = text.split(/\s+/).map do |word|
            word.gsub(/\{\{URL_\d+\}\}/) { |ph| url_map[ph] }
          end

          # Start with marker + first word(s)
          current_line = prefix
          words.each do |word|
            test_line = current_line == prefix ? current_line + word : current_line + " #{word}"
            if test_line.length <= width
              current_line = test_line
            else
              wrapped_lines << current_line
              current_line = indent + word
            end
          end
          wrapped_lines << current_line unless current_line.strip == marker
        else
          # Wrap regular lines, keeping long URL patterns together
          words = []
          temp_line = line.dup

          # Extract long parenthesized patterns (URLs)
          url_map = {}
          placeholder_index = 0
          temp_line.gsub!(/\([^)]{20,}\)/) do |url_part|
            placeholder = "{{URL_#{placeholder_index}}}"
            url_map[placeholder] = url_part
            placeholder_index += 1
            placeholder
          end

          # Split and restore
          temp_line.split(/\s+/).each do |word|
            word.gsub!(/\{\{URL_\d+\}\}/) { |ph| url_map[ph] }
            words << word
          end

          # Wrap to width
          current_line = ""
          words.each do |word|
            if current_line.empty?
              current_line = word
            elsif (current_line.length + word.length + 1) <= width
              current_line += " #{word}"
            else
              wrapped_lines << current_line
              current_line = word
            end
          end
          wrapped_lines << current_line unless current_line.empty?
        end
      end

      wrapped_lines.join("\n")
    end

    # Collapse multiple consecutive blank lines
    def collapse_blank_lines(input)
      return input unless input
      input.gsub(/\n{3,}/, "\n\n")
    end
  end

  class TxtFormatPage < PageWithoutAFile
    def initialize(site, post)
      @site = site
      @base = site.source

      # Creates /post/slug.txt
      collection_path = post.collection.label == "posts" ? "post" : post.collection.label
      slug = post.data['slug']

      @dir = collection_path
      @name = "#{slug}.txt"

      self.process(@name)

      # Set layout and permalink
      self.data = {
        'layout' => 'plain',
        'permalink' => "/#{@dir}/#{@name}",
        'post_slug' => slug,
        'post_collection' => post.collection.label,
        'post' => post
      }

      # Generate Liquid content that references the original post
      self.content = <<~LIQUID
{% include txt-format.html %}
      LIQUID
    end
  end

  class TxtFormatGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Generate .txt pages for posts
      site.posts.docs.each do |post|
        next unless eligible?(post)

        # Generate /post/slug.txt format
        txt_page = TxtFormatPage.new(site, post)
        site.pages << txt_page

        # Add alternate link metadata
        add_alternate(post, txt_page)
      end

      # Generate .txt pages for cardboctober collection
      if site.collections.key?('cardboctober')
        site.collections['cardboctober'].docs.each do |post|
          next unless eligible?(post)

          # Generate /cardboctober/slug.txt format
          txt_page = TxtFormatPage.new(site, post)
          site.pages << txt_page

          # Add alternate link metadata
          add_alternate(post, txt_page)
        end
      end
    end

    private

    def eligible?(doc)
      doc.output_ext == ".html" && doc.data["published"] != false
    end

    def add_alternate(doc, txt_page)
      doc.data["alternates"] ||= []

      # Prevent duplicates (important in --watch mode)
      doc.data["alternates"].reject! { |a| a["type"] == "text/plain" }

      doc.data["alternates"] << {
        "type"  => "text/plain",
        "href"  => txt_page.url,
        "title" => "plain text"
      }
    end
  end
end

Liquid::Template.register_filter(Jekyll::TxtFormatFilters)
