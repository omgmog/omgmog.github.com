#!/usr/bin/env ruby
# Applies the display policy (_plugins/webmention_policy.rb) to the stored
# webmention data, so personal details we won't display - names, avatars,
# text from silo and bridged mentions - aren't kept in the repo either.
#
# Idempotent and offline: safe to run on every build, on freshly fetched data
# or on data restored from the Actions cache.
#
#   ruby scripts/minimise_webmentions.rb            # rewrite _data/webmentions.json
#   ruby scripts/minimise_webmentions.rb --dry-run  # just report
require 'json'
require_relative '../_plugins/webmention_policy'

FILE    = File.join(__dir__, '..', '_data', 'webmentions.json')
dry_run = ARGV.include?('--dry-run')

data = JSON.parse(File.read(FILE))
modes = Hash.new(0)
before = File.size(FILE)

data.each_value do |mentions|
  mentions.each do |m|
    next unless m.is_a?(Hash) && m['wm-property']
    WebmentionPolicy.minimise!(m)
    modes[WebmentionPolicy.mode(m)] += 1
  end
end

json = JSON.pretty_generate(data)
File.write(FILE, json) unless dry_run
puts "#{dry_run ? 'Would write' : 'Wrote'} #{FILE} (#{before} -> #{json.bytesize} bytes)"
puts "full: #{modes['full']}, link: #{modes['link']}, count: #{modes['count']}"
