#!/usr/bin/env ruby
require 'mini_magick'
require 'digest'
require 'fileutils'

dest = ARGV[0] || '_site'
source = '.'
cache_dir = ARGV[1] || '.cache/images'

FileUtils.mkdir_p(cache_dir)

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
cached_count = 0

image_files.each do |image_file|
  begin
    webp_path = "#{image_file}.webp"

    # Honour a hand-committed WebP alongside the source image
    source_webp = image_file.sub(dest, source) + '.webp'
    if File.exist?(source_webp)
      puts "Image Optimizer: Skipping #{File.basename(image_file)} - WebP exists in source"
      skipped_count += 1
      next
    end

    # Content-hash the pre-optimization bytes so the cache survives across
    # checkouts (mtimes reset on every checkout, so those can't be the key)
    ext = File.extname(image_file)
    digest = Digest::SHA256.hexdigest(File.binread(image_file))
    cached_webp = File.join(cache_dir, "#{digest}.webp")
    cached_original = File.join(cache_dir, "#{digest}#{ext}")

    if File.exist?(cached_webp) && File.exist?(cached_original)
      FileUtils.cp(cached_webp, webp_path)
      FileUtils.cp(cached_original, image_file)
      puts "Image Optimizer: Using cached derivative for #{File.basename(image_file)}"
      cached_count += 1
      next
    end

    # Generate WebP version
    original_size = File.size(image_file)
    image = MiniMagick::Image.open(image_file)

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

    FileUtils.cp(webp_path, cached_webp)
    FileUtils.cp(image_file, cached_original)

  rescue => e
    puts "Image Optimizer: Failed to optimize #{File.basename(image_file)}: #{e.message}"
  end
end

puts "Image Optimizer: Generated #{webp_count} WebP files (saved #{total_webp_saved} bytes)"
puts "Image Optimizer: Compressed #{compressed_count} originals (saved #{total_compressed_saved} bytes)"
puts "Image Optimizer: Used #{cached_count} cached derivatives"
puts "Image Optimizer: Skipped #{skipped_count} files"
puts "Image Optimizer: Total savings: #{total_webp_saved + total_compressed_saved} bytes"
