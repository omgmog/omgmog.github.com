---
title: Enriching webmentions from third-party platforms
comments_issue: 157
tags: [indieweb, jekyll, programming]
series: webmentions
---

I keep finding new gaps in my webmention implementation. Mentions coming in from Bluesky, Lemmy and Lobsters were showing up with no author at all, just a blank avatar and an empty name. Reddit and Hacker News bookmarks fared a bit better, with a username attached, but got flattened into a generic "bookmarked" icon with no indication of where the post had actually been shared. Lobsters mentions also carried the wrong published date. None of these felt like they were pulling their weight compared to a proper webmention from a blog or Mastodon.

<!-- more -->

What pushed me from "should fix this someday" to actually doing it was my [Xteink X4 post](/post/xteink-x4-e-ink-reader/) hitting Hacker News the day after I published it, then Lobsters the day after that. The traffic graph still has the spike sitting in it, from next to nothing to over 1,600 views an hour, 7,126 of those visits via news.ycombinator.com alone, and 13,414 of the site's 15,150 page views over those three days landing on that one post. Suddenly the gaps weren't theoretical, I had a stack of mentions to look at and most of them were the ones that rendered worst.

The root issue is that bridges like [brid.gy](https://brid.gy), which I've [relied on before](/post/baking-webmentions-into-the-build/), convert these platforms' posts into webmentions, but the conversion is lossy in different ways for each one. A Bluesky mention arrives with the author identified only by a `did:plc:` string, the underlying AT Protocol identifier rather than anything a human would recognise. A Lemmy mention arrives as a bare post URL with no author data whatsoever. Reddit and Hacker News fare better because brid.gy carries the username across, but my rendering logic was still treating them as likes and bookmarks, rather than things worth showing on their own.

Each platform also picks a different `wm-property` for what's functionally the same action, sharing a link to one of my posts, which means I can't just key off the property type to decide how to render something. Bluesky and Lemmy mentions both come in as `mention-of`. Reddit and Hacker News posts arrive as `bookmark-of`, the same property a plain like or favourite uses elsewhere, so a Reddit share and someone hitting the bookmark button on a Mastodon post are otherwise indistinguishable. Lobsters is the odd one out with `repost-of`, which on every other platform means an actual repost or boost.

Since the property alone doesn't tell me anything, I match on the URL instead, checking `bookmark-of` and `repost-of` mentions against each platform's domain before deciding how to render them. That groundwork done, fixing each platform meant tackling two separate problems (filling in missing author data, and getting the rendering to actually show the share rather than hiding it behind a generic icon).

## Resolving Bluesky's did:plc identifiers

Bluesky's public API will resolve a DID to a proper profile if you ask it nicely:

```ruby
def enrich_bsky_mention(m, cache)
  did = (m.dig('url').to_s + m.dig('wm-source').to_s)[DID_PLC_REGEX]
  return unless did

  profile = fetch_bsky_profile(did, cache)
  return unless profile && profile['handle']

  handle = profile['handle']
  m['url'] = m['url']&.sub(did, handle)
  m['author'] ||= {}
  m['author']['name'] = profile['displayName'].to_s.empty? ? handle : profile['displayName']
  m['author']['photo'] = profile['avatar'] || m['author']['photo']
  m['author']['url'] = "https://bsky.app/profile/#{handle}"
end
```

`getProfile` on `public.api.bsky.app` needs no auth and returns the handle, display name and avatar for any DID. I cache the lookup per run so the same author across multiple mentions only costs one request, then rewrite the post URL to use the handle instead of the DID so the permalink is actually readable too.

## Filling in Lemmy from the post API

Lemmy mentions had nothing to enrich from in the webmention itself, just the post URL. Lemmy's own API fills that in:

```ruby
LEMMY_URL_REGEX = %r{\Ahttps?://([^/]*lemmy[^/]*)/post/(\d+)}i

def enrich_lemmy_mention(m, cache)
  match = (m['url'] || m['wm-source']).to_s.match(LEMMY_URL_REGEX)
  return unless match

  instance, post_id = match[1], match[2]
  data = cache["#{instance}/#{post_id}"] ||= fetch_json("https://#{instance}/api/v3/post?id=#{post_id}")
  creator = data&.dig('post_view', 'creator')
  return unless creator

  m['author'] ||= {}
  m['author']['name'] = creator['display_name'].to_s.empty? ? creator['name'] : creator['display_name']
  m['author']['photo'] = creator['avatar']
  m['author']['url'] = creator['actor_id']
end
```

I deliberately scoped the regex to hosts containing "lemmy" rather than matching any `/post/<id>` URL pattern, since that's common enough across other sites that it would have fired on things with nothing to do with Lemmy. Lemmy's federated, so there's no fixed list of instances to check against, but requiring "lemmy" in the hostname catches the ones I've actually seen mentions from without sending stray requests everywhere. It won't catch instances that don't have "lemmy" in their name, like programming.dev, but I can add those as I spot them rather than trying to enumerate every Lemmy instance up front.

The same response also has the community a post was shared to, so I stash that alongside the author:

```ruby
community = data&.dig('post_view', 'community')
if community
  m['community'] = { 'name' => community['name'], 'url' => community['actor_id'] }
end
```

## Enriching Lobsters from the story and user APIs

Lobsters mentions had no author data and the wrong published date, both down to my own polling script sending the webmention via `indieweb_utils` rather than anything brid.gy related. I dug around and found that an individual story has its own JSON endpoint with everything I needed to enrich from:

```ruby
LOBSTERS_URL_REGEX = %r{\Ahttps?://lobste\.rs/s/([a-z0-9]+)}i

def enrich_lobsters_mention(m, cache)
  match = (m['url'] || m['wm-source']).to_s.match(LOBSTERS_URL_REGEX)
  return unless match

  short_id = match[1]
  data = cache[short_id] ||= fetch_json("https://lobste.rs/s/#{short_id}.json")
  return unless data

  m['published'] = data['created_at'] if data['created_at']

  username = data['submitter_user']
  return unless username

  user = cache["user:#{username}"] ||= fetch_json("https://lobste.rs/~#{username}.json")
  return unless user

  m['author'] ||= {}
  m['author']['name'] = username
  m['author']['photo'] = user['avatar_url'] ? "https://lobste.rs#{user['avatar_url']}" : m['author']['photo']
  m['author']['url'] = "https://lobste.rs/~#{username}"
end
```

The story endpoint gives me `created_at` for the actual submission date and the submitter's username, then a second request to that user's profile picks up their avatar. Same caching approach as Bluesky and Lemmy, one request per unique story and one per unique user, however many mentions reference them.

## Giving Reddit and Hacker News shares their own format

Reddit and Hacker News were the odd ones out because the data was already there, the author name and the post URL, it just wasn't being shown usefully. A bookmark webmention with a Reddit or Hacker News URL was rendering as a plain avatar in the likes row, same as a Mastodon like, telling me nothing about which subreddit it landed in or that it had hit the front page at all.

Both the build-time Liquid templates and the client-side JS needed the same treatment, since this site renders pre-fetched mentions statically at build time and then tops them up with live fetches in the browser. I added checks for `bookmark-of` webmentions matching `reddit.com/r/` or `news.ycombinator.com`, pulled them out of the generic reactions list, and rendered them as proper feed entries instead:

```ruby
def reddit_bookmark?(mention)
  return false unless mention["wm-property"] == "bookmark-of"
  !!((mention["url"].to_s + mention["wm-source"].to_s) =~ %r{reddit\.com/r/}i)
end

def hn_bookmark?(mention)
  return false unless mention["wm-property"] == "bookmark-of"
  !!((mention["url"].to_s + mention["wm-source"].to_s) =~ %r{news\.ycombinator\.com}i)
end
```

{% include posts/figure.html src="2026-06/improved-mentions.png" %}{:.center}

Hacker News bookmarks didn't need any API enrichment, brid.gy's webmention already carries the submitter's username, so it was just a case of routing them into the same rich rendering as Reddit. Lemmy mentions with community data got a similar format, just swapped for a `!community@instance` style link. Lobsters has no equivalent grouping to show, so it falls back to a plain "shared by" line with the author and date, with nothing to attribute it to beyond the site itself. All four now read like an actual share rather than disappearing into an icon that only stands out if you're actively looking for it.

With four platforms rendering as proper shares, the icon-only likes row was starting to look inconsistent, some entries had platform icons, some didn't. I pulled matching SVG icons for Hacker News, Reddit and the fediverse from [SuperTinyIcons](https://github.com/edent/SuperTinyIcons), and unified the wording so a Lemmy share reads "Shared on the !community@instance community by author" the same way a Reddit share reads "Shared on the /r/subreddit subreddit by author".

## Reddit and Lobsters don't send webmentions on their own

Unlike Bluesky, Lemmy and Mastodon, neither Reddit nor Lobsters pings a webmention endpoint when a post gets linked, so there's nothing for brid.gy to bridge in the first place. I run small polling scripts instead: one checks `reddit.com/domain/blog.omgmog.net/.rss` for new posts linking here, the other checks `lobste.rs/newest.json`, and both send a webmention to my own site on my behalf using `indieweb_utils`, much like [webmention.app does when I send mentions out](/post/sending-webmentions-on-deploy/), so the results flow through the same pipeline as everything else, no separate handling needed downstream.

## Two-sided rendering means twice the work

Keeping the build-time Liquid path and the runtime JS path in sync is the annoying bit. Any change to how mentions get classified (like pulling Reddit bookmarks out of the likes bucket) needs to happen in both `_plugins/webmention_feed.rb` and `assets/interactions.js`, with matching templates in `webmention-static-feed.html` and `webmention-templates.html`. It's the price of avoiding a flash of unstyled content while webmentions load, and so far it's been worth paying, but every fix is really two fixes wearing a trenchcoat.

I also had to fix a stale cache catching me out partway through. The GitHub Action that fetches webmentions keys its cache on a hash of the index from [Morris](/post/baking-webmentions-into-the-build/), my self-hosted service that mirrors mentions from webmention.io, but not on the script that processes it, so my first fix to the script ran against cached data and quietly did nothing. Adding the script's own hash into the cache key sorted that, and meant the existing backlog of Bluesky, Lemmy and Lobsters mentions got backfilled with their newly resolved authors the next time the job ran, rather than only enriching mentions from that point on.
