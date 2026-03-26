#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'uri'

MORRIS_BASE = 'https://wm.omgmog.net/morris/data'
OUTPUT_FILE = File.join(__dir__, '..', '_data', 'webmentions.json')

def fetch_json(url)
  uri = URI(url)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    response = http.get(uri.request_uri)
    return nil unless response.code == '200'
    JSON.parse(response.body)
  end
rescue => e
  warn "Failed to fetch #{url}: #{e}"
  nil
end

puts "Fetching Morris index..."
index = fetch_json("#{MORRIS_BASE}/index.json")
unless index
  warn "Could not fetch Morris index, skipping webmentions"
  exit 0
end

webmentions = {}
total = 0

index.each do |path, hashes|
  mentions = hashes.filter_map do |hash|
    m = fetch_json("#{MORRIS_BASE}/mentions/#{hash}.json")
    next unless m
    m['sort_date'] = m['published'] || m['wm-received'] || ''
    m
  end
  unless mentions.empty?
    webmentions[path] = mentions
    total += mentions.length
  end
end

def sanitize(obj)
  case obj
  when String then obj.encode('UTF-8', invalid: :replace, undef: :replace, replace: '').scrub('').delete("\u0000")
  when Array  then obj.map { |i| sanitize(i) }
  when Hash   then obj.transform_values { |v| sanitize(v) }
  else obj
  end
end

File.write(OUTPUT_FILE, JSON.pretty_generate(sanitize(webmentions)))
puts "Wrote #{total} webmentions for #{webmentions.keys.length} pages"
