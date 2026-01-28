---
title: Plugins instead of patches
comments_issue: 131
tags: [known, indieweb, php]
---

I've been running [Known](https://withknown.com/) as [my social posting hub](https://social.omgmog.net) for a while now. It's a solid IndieWeb-friendly CMS that handles status updates, photos, and syndication to various silos. Recently I upgraded my instance for the first time in about four years, which meant dealing with all the little tweaks I'd made to core templates over that time.

Previously I'd just edited core files directly, which meant upgrades would wipe my changes. After four years I had no idea what I'd even modified (I'll go into the archaeology of that in another post). This time I decided to do it properly, and ended up writing [four plugins](https://github.com/omgmog?tab=repositories&q=Known-).

<!-- more -->

## LikeLabels

Known calls likes "stars". The button says "star", the count says "stars". This is fine, but I wanted mine to say "likes" instead. A small thing, but it _bugged_ me.

The [LikeLabels](https://github.com/omgmog/Known-LikeLabels) plugin overrides the template that renders these labels and pulls the text from a config setting instead. There's an admin page where I can set the singular and plural forms to whatever I want. "Like/likes", "heart/hearts", "fave/faves", whatever.

## CustomMenu

Jumping into a template file every time I want to tweak the navigation isn't ideal, so I made the [CustomMenu](https://github.com/omgmog/Known-CustomMenu) plugin to handle it through the admin UI instead.

It adds an admin page with a table of menu items. Each one has a label, URL, and an optional `rel` attribute (handy for `rel="me"` verification). I can drag them around to reorder, and mark one as "active" to highlight which site I'm currently on. The plugin then injects these into the toolbar template.

## RichFeed

The [RichFeed](https://github.com/omgmog/Known-RichFeed) plugin adds OpenGraph metadata to the JSON Feed output for any URLs in posts. It also renders Markdown and strips out bare URLs that have been unfurled (so they don't appear twice).

The plan is to use this data to create richer embeds of my timeline on my blog. This plugin is doing a bit much (unfurling, Markdown, URL stripping), but it works for what I need.

## UnfurlManager

Sometimes I don't _want_ a URL to be unfurled. Maybe the preview card looks rubbish, or maybe I'm linking to something where the URL itself is the point. The [UnfurlManager](https://github.com/omgmog/Known-UnfurlManager) plugin lets me hide individual unfurls on a per-post basis.

Each post stores a list of URLs that shouldn't be unfurled. The RichFeed plugin checks this list and excludes those URLs from the `_unfurls` data. The URL still appears as a link in the post, it just doesn't get a preview card.
