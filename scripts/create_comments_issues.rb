#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'yaml'

REPO       = 'omgmog/omgmog.github.com'
TOKEN      = ENV['GITHUB_TOKEN']
POSTS_DIR  = File.join(__dir__, '..', '_posts')
SITE_URL   = 'https://blog.omgmog.net'

unless TOKEN
  warn "GITHUB_TOKEN not set, skipping"
  exit 0
end

def github_get(path, token)
  uri = URI("https://api.github.com#{path}")
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = "Bearer #{token}"
  req['Accept'] = 'application/vnd.github.v3+json'
  Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
end

def github_post(path, token, body)
  uri = URI("https://api.github.com#{path}")
  req = Net::HTTP::Post.new(uri)
  req['Authorization'] = "Bearer #{token}"
  req['Accept'] = 'application/vnd.github.v3+json'
  req['Content-Type'] = 'application/json'
  req.body = body.to_json
  Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
end

paths = ARGV.empty? ? Dir.glob("#{POSTS_DIR}/**/*.md") : ARGV

posts = paths.filter_map do |path|
  content = File.read(path)
  next unless content.start_with?('---')
  data = YAML.safe_load(content.split('---', 3)[1])
  next unless data['comments_issue'] && data['title']
  { number: data['comments_issue'].to_i, title: data['title'], path: path }
rescue => e
  warn "Failed to read #{path}: #{e}"
  nil
end

posts.each do |post|
  res = github_get("/repos/#{REPO}/issues/#{post[:number]}", TOKEN)
  if res.code == '200'
    next
  elsif res.code != '404'
    warn "Unexpected response checking issue ##{post[:number]}: #{res.code}"
    next
  end

  # derive the permalink slug the same way Jekyll does: strip date prefix from filename
  slug = File.basename(post[:path], '.md').sub(/\A\d{4}-\d{2}-\d{2}-/, '')
  url = "#{SITE_URL}/post/#{slug}/"

  body = {
    title: %(Comments for "#{post[:title]}"),
    labels: ['Comments'],
    body: <<~TEXT
      You can view the blog post here: [#{post[:title]}](#{url})

      Any replies to this issue will be viewable at the end of the post.
    TEXT
  }

  create_res = github_post("/repos/#{REPO}/issues", TOKEN, body)
  if create_res.code == '201'
    issue = JSON.parse(create_res.body)
    puts "Created issue ##{issue['number']} for \"#{post[:title]}\" (front matter said ##{post[:number]})"
  else
    warn "Failed to create issue for \"#{post[:title]}\": #{create_res.code} #{create_res.body}"
  end
end
