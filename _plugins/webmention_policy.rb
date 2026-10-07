require "set"
require "uri"
require "digest"

# Single source of truth for how a webmention may be displayed.
#
#   full  - the sender chose to send it (their own site pinged us), or it's
#           mine. Name and content are shown inline.
#   link  - it reached us through a silo, a bridge, or because we pulled it
#           from an API. Shown as "Reply on <host> - view reply" only: no
#           name, avatar or content.
#   count - a like/repost/bookmark from a silo. Counted, never listed.
#
# The mode is derived from the data on every build, so changing the rules
# here changes the site without refetching anything.
#
# scripts/minimise_webmentions.rb applies the same rules to
# _data/webmentions.json so personal data we won't display isn't kept in the
# (public) repo either. assets/interactions.js mirrors silo?/own? for
# mentions fetched live in the browser; keep the two in step.
module WebmentionPolicy
  OWN_MARKERS = %w[
    omgmog.net
    omgmog.github.io
    twitter.com/omgmog
    indieweb.social/@omgmog
  ].freeze

  # Hosts whose mentions arrive via a bridge or a silo rather than from the
  # author's own site. Matches the host and any subdomain (bsky.brid.gy).
  SILO_HOSTS = %w[
    brid.gy
    bsky.app
    twitter.com
    x.com
    reddit.com
    news.ycombinator.com
    lobste.rs
    indieweb.social
  ].freeze

  # Status URLs on fediverse servers (Mastodon, GoToSocial, Lemmy). A server
  # that sends a webmention on a user's behalf isn't the user choosing to.
  FEDIVERSE_PATH = %r{\A/(@[^/]+/(statuses/)?(\d+|[0-9A-HJKMNP-TV-Z]{26})|users/[^/]+/statuses/\d+|post/\d+|comment/\d+)/?\z}

  REACTIONS = %w[like-of bookmark-of repost-of].freeze

  # What survives minimising a silo mention: enough to count it, date it,
  # link to it and de-duplicate it. Nothing about the person.
  KEEP_KEYS = %w[
    type wm-property wm-id wm-source wm-target wm-received wm-private
    url published sort_date community _pulled _author_key _own
  ].freeze

  module_function

  # A bookmark/repost that is really "this was shared on Reddit / HN / Lobsters".
  def shared_link?(mention)
    src = mention["url"].to_s + mention["wm-source"].to_s
    case mention["wm-property"]
    when "bookmark-of" then src.match?(%r{reddit\.com/r/|news\.ycombinator\.com}i)
    when "repost-of"   then src.match?(%r{lobste\.rs}i)
    else false
    end
  end

  # Something that only points at the post from elsewhere and has nothing to
  # read: a share on Reddit/HN/Lobsters, a community post, or a mention that
  # is link-only (silo) or arrived without text. These are listed with the
  # reactions under Interactions; replies and mentions with content are the
  # Discussion. Mirrors isPointer() in assets/interactions.js.
  def pointer?(mention)
    return true if shared_link?(mention)
    return false unless mention["wm-property"] == "mention-of"
    return true if mention["community"]

    m = mode(mention)
    m == "link" || (m == "full" && !own?(mention) && mention.dig("content", "text").nil?)
  end

  # Where else a post lives (its `syndication:` front matter). A webmention that
  # is just that copy mentioning or replying to the post duplicates the "Also on"
  # row, so it is dropped. Scheme, fragment and a trailing slash are ignored.
  # Reactions are left alone: their url is the copy being liked, not a copy.
  def normalize_url(url)
    u = URI.parse(url.to_s.strip)
    return nil if u.host.to_s.empty?
    "#{u.host.downcase}#{u.path.to_s.chomp("/")}#{u.query ? "?#{u.query}" : ""}"
  rescue URI::InvalidURIError
    nil
  end

  def syndication_keys(*lists)
    lists.flat_map { |l| Array(l) }.map { |u| normalize_url(u) }.compact.to_set
  end

  def syndicated?(mention, keys)
    return false if keys.nil? || keys.empty?
    return false unless %w[in-reply-to mention-of].include?(mention["wm-property"])
    [mention["url"], mention["wm-source"]].any? do |u|
      k = normalize_url(u)
      k && keys.include?(k)
    end
  end

  def host_of(url)
    URI.parse(url.to_s).host.to_s.downcase
  rescue URI::InvalidURIError
    ""
  end

  def fediverse_url?(url)
    FEDIVERSE_PATH.match?(URI.parse(url.to_s).path.to_s)
  rescue URI::InvalidURIError
    false
  end

  def silo_host?(host)
    return false if host.empty?
    return true if host.split(".").include?("lemmy")
    SILO_HOSTS.any? { |d| host == d || host.end_with?(".#{d}") }
  end

  # Is this me? Looks at who wrote it (author URL) and where it was sent from.
  # Deliberately not the mention's own `url`: a like or repost of my toot has
  # a url under my account and would look like mine.
  def own?(mention)
    return true if mention["_own"]
    [mention.dig("author", "url"), mention["wm-source"]].any? do |s|
      OWN_MARKERS.any? { |d| s.to_s.include?(d) }
    end
  end

  def silo?(mention)
    return true if mention["_pulled"] || mention["_filler"]
    [mention["wm-source"], mention["url"]].any? { |u| silo_host?(host_of(u)) || fediverse_url?(u) }
  end

  def mode(mention)
    return "full" if own?(mention) || !silo?(mention)
    REACTIONS.include?(mention["wm-property"]) ? "count" : "link"
  end

  # Stable, non-reversible key for "same person" checks (one like per person
  # across alternate URLs) without keeping their profile URL around.
  def author_key(mention)
    return mention["_author_key"] if mention["_author_key"]
    raw = mention.dig("author", "url") || mention.dig("author", "name") ||
          mention["url"] || mention["wm-source"]
    raw && Digest::SHA256.hexdigest(raw.to_s)[0, 16]
  end

  # Idempotent. Returns the same hash, modified in place.
  def minimise!(mention)
    return mention unless mention.is_a?(Hash) && mention["wm-property"]

    key = author_key(mention)
    mention["_author_key"] = key if key
    mention["_own"] = true if own?(mention)

    if mode(mention) == "full"
      mention["author"].delete("photo") if mention["author"].is_a?(Hash)
    else
      mention.select! { |k, _| KEEP_KEYS.include?(k) }
    end
    mention
  end

  def host_label(mention)
    host_of(mention["url"] || mention["wm-source"])
  end

  # Up to two initials: the first letter of the first and last word ("Justin
  # Sherrill" -> "JS"), or one for a single word. Works on user-perceived
  # characters so emoji and combining marks stay whole. Words that don't start
  # with a letter or digit ("(he/him)", "|") are skipped. Mirrors initialOf()
  # in assets/interactions.js.
  def initial(name, fallback = "?")
    words = name.to_s.strip.split(/\s+/).reject(&:empty?)
    return fallback if words.empty?

    named = words.select { |w| w.match?(/\A[\p{L}\p{N}]/) }
    picks = named.size >= 2 ? [named.first, named.last] : [words.first]
    picks.map { |w| w.scan(/\X/).first }.join.upcase
  end

  # Same arithmetic as hueOf() in assets/interactions.js.
  def hue(name)
    name.to_s.each_byte.reduce(7) { |h, b| (h * 31 + b) % 360 }
  end
end

if defined?(Liquid::Template)
  module Jekyll
    module WebmentionPolicyFilters
      def avatar_initial(name)
        WebmentionPolicy.initial(name)
      end

      def avatar_hue(name)
        WebmentionPolicy.hue(name)
      end

      def wm_host(url)
        WebmentionPolicy.host_of(url)
      end
    end
  end

  Liquid::Template.register_filter(Jekyll::WebmentionPolicyFilters)
end
