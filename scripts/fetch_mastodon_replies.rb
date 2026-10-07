#!/usr/bin/env ruby
# Walks Mastodon reply threads for posts' own syndicated toots (post.syndication
# front matter) and fills in replies that never produced a webmention - e.g.
# because the replying account doesn't bridge ActivityPub to the web at all.
#
# These replies were pulled by us, not sent by their author, so they're stored
# as link-only entries (url, date, host) for every account - never the
# person's name, avatar or text. The exception is my own replies in the thread,
# which are kept in full. See _plugins/webmention_policy.rb.
require 'net/http'
require 'json'
require 'yaml'
require 'cgi'
require 'set'
require_relative '../_plugins/webmention_policy'

SITE_URL        = 'https://blog.omgmog.net'
POSTS_DIR       = File.join(__dir__, '..', '_posts')
WEBMENTIONS_FILE = File.join(__dir__, '..', '_data', 'webmentions.json')
MASTODON_URL_REGEX = %r{\Ahttps?://([^/]+)/@[^/]+/(\d+)\z}

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

def slug_for(path)
  File.basename(path, '.md').sub(/\A\d{4}-\d{2}-\d{2}-/, '')
end

def strip_html(html)
  CGI.unescapeHTML(html.to_s.gsub(/<[^>]+>/, ' ')).gsub(/\s+/, ' ').strip
end

def build_mention(status, target_url)
  mention = {
    'type' => 'entry',
    'wm-property' => 'in-reply-to',
    'wm-target' => target_url,
    'url' => status['url'],
    'wm-source' => status['url'],
    'published' => status['created_at'],
    'wm-received' => status['created_at'],
    'sort_date' => status['created_at']
  }

  if WebmentionPolicy.own?('wm-source' => status['url'])
    account = status['account'] || {}
    mention['author'] = {
      'type' => 'card',
      'name' => account['display_name'].to_s.empty? ? account['username'] : account['display_name'],
      'url' => account['url']
    }
    mention['content'] = { 'html' => status['content'], 'text' => strip_html(status['content']) }
  else
    mention['_pulled'] = true
  end

  mention
end

webmentions = File.exist?(WEBMENTIONS_FILE) ? JSON.parse(File.read(WEBMENTIONS_FILE)) : {}

Dir.glob(File.join(POSTS_DIR, '**', '*.md')).each do |path|
  content = File.read(path)
  next unless content.start_with?('---')

  data = YAML.safe_load(content.split('---', 3)[1]) || {}
  syndication = Array(data['syndication']).compact
  next if syndication.empty?

  mastodon_urls = syndication.select { |u| u.to_s.match?(MASTODON_URL_REGEX) }
  next if mastodon_urls.empty?

  target_url = "#{SITE_URL}/post/#{slug_for(path)}/"
  key = "/post/#{slug_for(path)}/"
  existing = webmentions[key] || []
  existing_urls = Set.new(existing.map { |m| m['url'] }.compact)

  mastodon_urls.each do |toot_url|
    match = toot_url.match(MASTODON_URL_REGEX)
    host, id = match[1], match[2]

    context = fetch_json("https://#{host}/api/v1/statuses/#{id}/context")
    next unless context

    statuses = (context['ancestors'] || []) + (context['descendants'] || [])
    new_mentions = statuses.reject { |s| existing_urls.include?(s['url']) }
                            .map { |s| build_mention(s, target_url) }

    next if new_mentions.empty?

    existing.concat(new_mentions)
    existing_urls.merge(new_mentions.map { |m| m['url'] })
    puts "#{key}: found #{new_mentions.length} reply(ies) missing a webmention"
  end

  webmentions[key] = existing unless existing.empty?
end

File.write(WEBMENTIONS_FILE, JSON.pretty_generate(webmentions))
puts "Done"
