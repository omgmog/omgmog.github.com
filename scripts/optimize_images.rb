#!/usr/bin/env ruby
require 'mini_magick'

dest = ARGV[0] || '_site'
source = '.'

image_files = Dir.glob(File.join(dest, 'images/**/*.{jpg,jpeg,png}')).reject { |f| f.include?('.webp') }

if image_files.empty?
  puts "Image Optimizer: No images to process"
  exit 0
end

total_webp_saved = 0
total_compressed_saved = 0
webp_count = 0
compressed_count = 0
skipped_count = 0

image_files.each do |image_file|
  begin
    webp_path = "#{image_file}.webp"

    # Check if source already has this exact WebP file
    source_webp = image_file.sub(dest, source) + '.webp'
    if File.exist?(source_webp)
      puts "Image Optimizer: Skipping #{File.basename(image_file)} - WebP exists in source"
      skipped_count += 1
      next
    end

    # Generate WebP version
    image = MiniMagick::Image.open(image_file)
    original_size = File.size(image_file)

    image.resize '800>'
    image.format 'webp'
    image.quality 85
    image.write webp_path

    webp_size = File.size(webp_path)
    total_webp_saved += (original_size - webp_size)
    webp_count += 1
    puts "Image Optimizer: Generated #{File.basename(webp_path)}"

    # Compress original
    original_size = File.size(image_file)
    image = MiniMagick::Image.open(image_file)

    if image.type =~ /jpe?g/i
      image.combine_options do |c|
        c.strip
        c.interlace "Plane"
        c.quality 85
      end
      image.write image_file
    elsif image.type =~ /png/i
      image.combine_options do |c|
        c.strip
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
    puts "Image Optimizer: Failed to optimize #{File.basename(image_file)}: #{e.message}"
  end
end

puts "Image Optimizer: Generated #{webp_count} WebP files (saved #{total_webp_saved} bytes)"
puts "Image Optimizer: Compressed #{compressed_count} originals (saved #{total_compressed_saved} bytes)"
puts "Image Optimizer: Skipped #{skipped_count} files"
puts "Image Optimizer: Total savings: #{total_webp_saved + total_compressed_saved} bytes"
