#!/usr/bin/env ruby
require 'net/http'
require 'uri'

SITE_URL = 'https://blog.omgmog.net'
TOKEN = ENV['WEBMENTION_APP_TOKEN']
POSTS_DIR = File.join(__dir__, '..', '_posts')

def slug_for(path)
  File.basename(path, '.md').sub(/\A\d{4}-\d{2}-\d{2}-/, '')
end

if ARGV.include?('--all')
  paths = Dir.glob(File.join(POSTS_DIR, '**', '*.md'))
else
  paths = ARGV.select { |p| p.end_with?('.md') && p.include?('_posts') }
end

if paths.empty?
  puts "No posts to send webmentions for"
  exit 0
end

paths.each do |path|
  url = "#{SITE_URL}/post/#{slug_for(path)}/"
  uri = URI('https://webmention.app/check')
  params = { url: url }
  params[:token] = TOKEN if TOKEN
  uri.query = URI.encode_www_form(params)

  res = Net::HTTP.post(uri, nil)
  puts "#{url} -> #{res.code}"
rescue => e
  warn "Failed to send webmention for #{url}: #{e}"
end
