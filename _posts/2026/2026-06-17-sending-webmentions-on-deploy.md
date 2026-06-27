---
title: Sending webmentions on deploy
comments_issue: 153
tags: [indieweb, jekyll, programming]
series: webmentions
---

I've spent a fair bit of time on the receiving end of webmentions, from [adding support for them](/post/adding-support-for-webmentions/) in the first place through to [fetching them at build time](/post/baking-webmentions-into-the-build/) and rendering them server-side so the discussion section doesn't flicker in over JS. What I'd never actually done was send the other half. Every link I've ever made out to another IndieWeb site has just sat there, silently not telling anyone I'd linked to them.

<!-- more -->

Webmentions are two-sided. When I publish a post that links to someone else's site, I'm supposed to ping their webmention endpoint to say "hey, I mentioned you". That's how IndieWeb replies and references actually close the loop, rather than just being a one-way pull. I'd been shouting into the void for years. Hopefully now some of it gets heard.

## Hooking into the deploy

I'm already using [webmention.io](https://webmention.io) to receive mentions, but sending them needed something else. [webmention.app](https://webmention.app) has a simple `/check` endpoint that, given a URL, crawls the page, finds any outbound links, and sends webmentions to whichever of them support it. Point it at a post and it does the discovery and delivery for you.

So the new piece is a small Ruby script, `scripts/send_webmentions.rb`, that takes a list of post paths and pings webmention.app for each one:

```ruby
paths.each do |path|
  url = "#{SITE_URL}/post/#{slug_for(path)}/"
  uri = URI('https://webmention.app/check')
  params = { url: url }
  params[:token] = TOKEN if TOKEN
  uri.query = URI.encode_www_form(params)

  res = Net::HTTP.post(uri, nil)
  puts "#{url} -> #{res.code}"
end
```

I've added this as a new job in the existing `jekyll.yml` workflow, running after the deploy job finishes. It diffs `_posts` between the previous and current commit, and only sends webmentions for posts that actually changed in that push.

```yaml
- name: Send webmentions for changed posts
  run: |
    changed=$(git diff --name-only "${{ github.event.before }}" "${{ github.sha }}" -- _posts | tr '\n' ' ')
    if [ -n "$changed" ]; then
      bundle exec ruby scripts/send_webmentions.rb $changed
    else
      echo "No changed posts in this push"
    fi
```

{% include posts/figure.html src="2026-06/pipeline-webmention-send.png" %}

There's also a manual `workflow_dispatch` input to send webmentions for every post in one go, for backfilling everything I've published without ever notifying anyone. The usual build takes about a minute. The backfill run took twelve, working through all 268 posts one at a time and waiting on webmention.app to crawl each page and chase down its outbound links. Sorry, webmention.app, for landing 268 URLs on you in one go.

I'm now relying on three separate free services to make this all work. webmention.io receives mentions, brid.gy bridges Mastodon and other social replies into webmentions in the first place, and webmention.app sends them out on my behalf. None of it is self-hosted, none of it has an SLA, and if any one of the three quietly shuts down or changes its API I won't notice until mentions stop showing up or my GitHub Actions run starts failing. I touched on this same worry in the [previous post](/post/baking-webmentions-into-the-build/), and adding a third dependency hasn't made it go away. It's still better than the alternative of not bothering at all, but the whole thing is built on infrastructure I don't control.
