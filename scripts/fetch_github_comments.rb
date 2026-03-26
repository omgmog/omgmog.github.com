#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'yaml'

REPO      = 'omgmog/omgmog.github.com'
TOKEN     = ENV['GITHUB_TOKEN']
OUTPUT    = File.join(__dir__, '..', '_data', 'github_comments.json')
POSTS_DIR = File.join(__dir__, '..', '_posts')

unless TOKEN
  warn "GITHUB_TOKEN not set, skipping comment fetch"
  exit 0
end

def github_get(path, token)
  uri = URI("https://api.github.com#{path}")
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = "Bearer #{token}"
  req['Accept'] = 'application/vnd.github.v3.full+json'
  Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
rescue => e
  warn "Request failed for #{path}: #{e}"
  nil
end

# Collect all comments_issue values from post front matter
issue_numbers = Dir.glob("#{POSTS_DIR}/**/*.md").filter_map do |path|
  content = File.read(path)
  next unless content.start_with?('---')
  data = YAML.safe_load(content.split('---', 3)[1])
  data['comments_issue']&.to_i
rescue => e
  warn "Failed to read #{path}: #{e}"
  nil
end.uniq.compact

puts "Found #{issue_numbers.length} posts with comment issues"

result = {}

issue_numbers.each do |n|
  issue_res = github_get("/repos/#{REPO}/issues/#{n}", TOKEN)
  next unless issue_res&.code == '200'
  issue = JSON.parse(issue_res.body)

  comments = []
  page = 1
  loop do
    res = github_get("/repos/#{REPO}/issues/#{n}/comments?per_page=100&page=#{page}", TOKEN)
    break unless res&.code == '200'
    batch = JSON.parse(res.body)
    batch.each do |c|
      comments << {
        'id'           => c['id'],
        'user'         => { 'login' => c['user']['login'], 'avatar_url' => c['user']['avatar_url'], 'html_url' => c['user']['html_url'] },
        'body'         => c['body'],
        'body_html'    => c['body_html'],
        'created_at'   => c['created_at'],
        'html_url'     => c['html_url'],
        'sort_date'    => c['created_at']
      }
    end
    break if batch.length < 100
    page += 1
  end

  result[n.to_s] = { 'state' => issue['state'], 'comments' => comments }
  puts "Issue ##{n}: #{comments.length} comments (#{issue['state']})"
end

File.write(OUTPUT, JSON.pretty_generate(result))
puts "Done — #{result.length} issues written"
