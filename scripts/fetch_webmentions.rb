#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'uri'

MORRIS_BASE = 'https://wm.omgmog.net/morris/data'
OUTPUT_FILE = File.join(__dir__, '..', '_data', 'webmentions.json')

BLOCKED_DOMAINS = %w[
  beatonma.org
  muo.blogs.web.id
  ar.eastspace.net
  www.noise.my.id
  x.svenger.de
  z.kdrama.my.id
  io-max.one
  www.howtobuildclub.com
].freeze

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

BSKY_PROFILE_API = 'https://public.api.bsky.app/xrpc/app.bsky.actor.getProfile'
DID_PLC_REGEX = /did:plc:[a-z0-9]+/i

bsky_profile_cache = {}
lemmy_post_cache = {}

def fetch_bsky_profile(did, cache)
  return cache[did] if cache.key?(did)
  cache[did] = fetch_json("#{BSKY_PROFILE_API}?actor=#{did}")
end

def enrich_bsky_mention(m, cache)
  did = (m.dig('url').to_s + m.dig('wm-source').to_s)[DID_PLC_REGEX]
  return unless did

  profile = fetch_bsky_profile(did, cache)
  return unless profile && profile['handle']

  handle = profile['handle']
  m['url'] = m['url']&.sub(did, handle)
  m['author'] ||= {}
  m['author']['type'] = 'card'
  m['author']['name'] = profile['displayName'].to_s.empty? ? handle : profile['displayName']
  m['author']['photo'] = profile['avatar'] || m['author']['photo']
  m['author']['url'] = "https://bsky.app/profile/#{handle}"
end

LEMMY_URL_REGEX = %r{\Ahttps?://([^/]*lemmy[^/]*)/post/(\d+)}i

def enrich_lemmy_mention(m, cache)
  match = (m['url'] || m['wm-source']).to_s.match(LEMMY_URL_REGEX)
  return unless match

  instance, post_id = match[1], match[2]
  cache_key = "#{instance}/#{post_id}"
  return if cache.key?(cache_key) && cache[cache_key].nil?

  data = cache[cache_key] ||= fetch_json("https://#{instance}/api/v3/post?id=#{post_id}")
  creator = data&.dig('post_view', 'creator')
  return unless creator

  m['author'] ||= {}
  m['author']['type'] = 'card'
  m['author']['name'] = creator['display_name'].to_s.empty? ? creator['name'] : creator['display_name']
  m['author']['photo'] = creator['avatar'] || m['author']['photo']
  m['author']['url'] = creator['actor_id'] || m['author']['url']

  community = data&.dig('post_view', 'community')
  if community
    m['community'] = {
      'name' => community['name'],
      'url' => community['actor_id']
    }
  end
end

puts "Fetching Morris index..."
index = fetch_json("#{MORRIS_BASE}/index.json")
unless index
  warn "Could not fetch Morris index, skipping webmentions"
  exit 0
end

def canonical_path(path)
  path = path.sub(/\.txt\z/, '')
  path = "#{path}/" unless path.empty? || path.end_with?('/')
  path
end

webmentions = {}
total = 0

index.each do |path, hashes|
  canonical = canonical_path(path)
  next if canonical.empty?

  mentions = hashes.filter_map do |hash|
    m = fetch_json("#{MORRIS_BASE}/mentions/#{hash}.json")
    next unless m
    source_domain = URI.parse(m['wm-source'] || '').host rescue nil
    next if source_domain && BLOCKED_DOMAINS.include?(source_domain)
    m['sort_date'] = m['published'] || m['wm-received'] || ''
    enrich_bsky_mention(m, bsky_profile_cache)
    enrich_lemmy_mention(m, lemmy_post_cache)
    m
  end
  next if mentions.empty?

  existing = webmentions[canonical] ||= []
  existing.concat(mentions)
  existing.uniq! { |m| m['wm-id'] || m['url'] }
  total += mentions.length
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
