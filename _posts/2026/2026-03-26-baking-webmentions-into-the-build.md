---
title: Baking webmentions into the build
comments_issue: 144
tags: [indieweb, web-development, jekyll, programming]
---

Back in 2022 I [added webmention support to this blog](/post/adding-support-for-webmentions/). The implementation worked but it was entirely client-side, so the page would load, JS would fire, fetch from webmention.io, and render the results into the DOM. With JS disabled or on a slow connection, the discussion section was just empty.

It worked well enough that I didn't touch it for three years, but the rate-limit situation had been silently catching visitors out and eventually I started pulling at the thread.

<!-- more -->

The original setup fetched webmentions from webmention.io on every page load, caching the results in localStorage for 30 minutes. GitHub issue comments (my comment system) were fetched the same way. The result was a discussion section that would flicker in after a moment, or not appear at all if the API was rate-limited or slow.

The GitHub API rate limit is 60 requests per hour per IP for unauthenticated requests. That's per visitor, so anyone browsing through a few posts in quick succession would hit it pretty fast and suddenly find comments not loading. There was also no record of what mentions existed at build time. Anyone without JavaScript saw _nothing_.

## Fetching at build time

I run a small self-hosted service on my VPS called Morris that mirrors webmentions from webmention.io, indexing them by target URL and storing each one as a JSON file so I've got a local copy I control rather than depending on the API directly. ([webmention.io](https://webmention.io) receives and stores mentions sent to your site; [brid.gy](https://brid.gy) bridges social platforms like Mastodon and Twitter so their replies show up as webmentions too. Both are free and genuinely brilliant bits of IndieWeb infrastructure.)

Two scripts handle the fetching, a [webmention one](https://github.com/omgmog/omgmog.github.com/blob/main/scripts/fetch_webmentions.rb) and a [GitHub comments one](https://github.com/omgmog/omgmog.github.com/blob/main/scripts/fetch_github_comments.rb), each writing results to `_data/`. A [GitHub Actions workflow](https://github.com/omgmog/omgmog.github.com/blob/main/.github/workflows/interactions.yml) runs both at 4am daily and commits whatever's changed.

Fetching GitHub comments via Actions rather than client-side also means the requests go out authenticated with `GITHUB_TOKEN`, which has a [rate limit](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api) of 1,000 requests per hour per repository. That's more than enough for a daily cron job, and since the results are committed to the repo, visitors never touch the API at all unless new comments have arrived since the last build.

With the data files in the repo, Jekyll renders the mentions at build time using standard Liquid templates. The discussion section is in the HTML before anything loads. The JS still runs to pick up anything that's arrived since the last build, tracks which IDs were already rendered to avoid duplicates, and re-sorts the feed chronologically. The page passes the pre-rendered IDs to the JS as two Sets:

{% capture ids %}{% raw %}{{ output at build }}{% endraw %}{% endcapture %}
```javascript
const preRenderedWmIds = new Set([{{ ids }}]);
const preRenderedCommentIds = new Set([{{ ids }}]);
```

## One stream instead of three

Previously the discussion section had separate blocks for comments, replies, and mentions. I merged them into a single feed sorted by date, mixing GitHub comments and webmentions together. Archived comments (old ones I'd manually added to post front matter) slot in at the top since they're always the oldest.

Items are colour-coded by source, GitHub comments getting one accent and webmentions another, with further tints for Reddit, Mastodon, and Twitter. My own entries flip to a reversed bubble, like a sent message.

{% include posts/figure.html src="2026-03/webmentions/stream.png" %}{:.center}

Likes, reposts, and bookmarks are gone from the stream entirely. They used to show as a grid of avatars, which was mostly noise, and a row of ten identical silhouettes doesn't tell you much. The counts still show up in the interactions badge at the top of the post.

Interaction counts also appear on the post listing pages now. Since the data is baked into the build, the counts render statically alongside each post title with no JS involved.

{% assign demo_post = site.posts | where: "slug", "adding-support-for-webmentions" | first %}
{% include global/post-list-item.html hide_years=true hide_types=true post=demo_post tag="div" %}{:.massive}


## Tidying up

Webmention.io matches mentions against exact URLs, and I was losing some because people link with or without a trailing slash even though the canonical URL always has one. Webmention.io also has a `.txt` version of each post it can check against (I [added `.txt` support](/post/moving-to-github-actions-and-adding-txt-posts/) back in January). I added both variants to the set of URLs the JS uses when looking for matches, which recovered a few mentions that had been silently missing.

I swapped the various hand-rolled inline SVGs scattered through the interactions markup for a [Lucide](https://lucide.dev) icon sprite, one `<svg>` block in the page head with `<use href="#icon-name">` anywhere an icon is needed. A bit less markup noise and much easier to maintain.

Webmention.io's own blocklist doesn't catch everything. I found a cluster of scraper sites that had all syndicated the same "budget smart home" article and sent webmentions to an old post of mine. They were easy to spot since they all had the same URL path across different junk domains. I added a `BLOCKED_DOMAINS` list to the fetch script and purged them from the existing data.

The discussion section now loads with the page. No flicker, no comments quietly missing because someone linked without a trailing slash.
