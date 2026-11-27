---
title: Giving every Jekyll post its own Open Graph image
comments_issue: 177
series: blog-internals
tags: [jekyll, site-related, guide, web-development]
category: blog
---

Paste a link into Mastodon, Slack or most social media sites and it usually turns into a card, with a title, a line of description and sometimes a big picture. The picture is what makes people notice the link in a busy feed. Without one, it's just a line of text.

For a long time, every post on this blog shared the same image: my avatar and name on a white card with a yellow dotted border. It looked fine, but it said nothing about the post, and a feed of my links was a feed of identical cards.

<!-- more -->

## But first, what the heck is Open Graph?

Those cards come from the [Open Graph protocol](https://ogp.me/), which Facebook introduced in 2010. It's a small set of `<meta>` tags in a page's `<head>` that describe the page, so anything that previews a link can build a card without guessing. The protocol sums up its purpose like this:

> The Open Graph protocol enables any web page to become a rich object in a social graph.

Four tags are required, and `og:description` is an optional extra that most platforms show as well:

```html
<meta property="og:title" content="Giving every Jekyll post its own Open Graph image">
<meta property="og:type" content="article">
<meta property="og:url" content="https://blog.omgmog.net/...">
<meta property="og:image" content="https://blog.omgmog.net/images/og/....png">
<meta property="og:description" content="..."> <!-- optional -->
```

The title, type and URL say what the page is and where it lives. The image is the part people see first, and the protocol describes it as:

> An image URL which should represent your object within the graph.

When someone shares a link, the platform's crawler fetches the page, reads those tags and downloads the image. 1200x630 is a size most of them are happy with.

Here is one link at each stage, from no tags at all to a full set. Some places show a compact card instead, with the image cropped square beside the text:

{% include posts/og-demo.html url="https://blog.omgmog.net/post/android-auto-on-an-android-4-head-unit/" caption="No Open Graph tags, so just the URL" class="wide" %}
{% include posts/og-demo.html title="Android Auto on my HR-V's Android 4.0.4 head unit" caption="`og:title` only" class="wide" %}
{% include posts/og-demo.html title="Android Auto on my HR-V's Android 4.0.4 head unit" description="I recently bought a 2018 Honda HR-V as our family car. It has a 7&quot; touchscreen running Android 4.0.4, a version so old it predates Android Auto by about three years." caption="With `og:description`" class="wide" %}
{% include posts/og-demo.html title="Android Auto on my HR-V's Android 4.0.4 head unit" description="I recently bought a 2018 Honda HR-V as our family car. It has a 7&quot; touchscreen running Android 4.0.4, a version so old it predates Android Auto by about three years." image="2026-11/ogimage-generic.png" caption="With `og:image`" class="wide" %}
{% include posts/og-demo.html title="Android Auto on my HR-V's Android 4.0.4 head unit" description="I recently bought a 2018 Honda HR-V as our family car. It has a 7&quot; touchscreen running Android 4.0.4, a version so old it predates Android Auto by about three years." image="2026-11/ogimage-generic.png" layout="square" caption="Compact layout, with the image cropped square" class="wide" %}

## Making an image for every post

A static site has no obvious place to make a different image for each post. I had three options. I could draw one by hand for every post, which I knew I wouldn't keep up. I could use a service that renders them on request, which means another dependency and another URL I don't control. Or I could render them at build time, from the data Jekyll already has about each post.

Whichever way they're made, what I wanted was a card per post. Four posts with the generic image look like this:

<div class="og-demos">
{% include posts/og-demo.html title="The Raspberry Pi Pico and the Pimoroni Pico RGB Keypad" description="In January the Raspberry Pi Pico was announced. The Pico is a RP2040 microcontroller featuring a dual-core Arm Cortex-M0+ processor with 264KB internal RAM and support for up to 16MB of off-chip Flash." image="2026-11/ogimage-generic.png" %}
{% include posts/og-demo.html title="Adding support for Webmentions" description="I've added Webmention support to the posts on this blog. Webmentions are a method for websites to know that they've been linked to (or mentioned) from elsewhere on the web." image="2026-11/ogimage-generic.png" %}
{% include posts/og-demo.html title="The Xteink X4 E-Ink Reader" description="I've had the Xteink X4 for a couple of months now, a £40 e-ink reader small enough to stick to the back of a phone." image="2026-11/ogimage-generic.png" %}
{% include posts/og-demo.html title="How I'm using CSS View Transitions on this blog" description="In the old days of the web, animating between pages meant faking it with jQuery. Then came pjax, which used pushState to swap in fetched content and fake a full navigation without one." image="2026-11/ogimage-generic.png" %}
</div>

And the same four with an image rendered for each post:

<div class="og-demos">
{% include posts/og-demo.html title="The Raspberry Pi Pico and the Pimoroni Pico RGB Keypad" description="In January the Raspberry Pi Pico was announced. The Pico is a RP2040 microcontroller featuring a dual-core Arm Cortex-M0+ processor with 264KB internal RAM and support for up to 16MB of off-chip Flash." image="og/the-raspberry-pi-pico-and-pimoroni-rgp-keypad.png" %}
{% include posts/og-demo.html title="Adding support for Webmentions" description="I've added Webmention support to the posts on this blog. Webmentions are a method for websites to know that they've been linked to (or mentioned) from elsewhere on the web." image="og/adding-support-for-webmentions.png" %}
{% include posts/og-demo.html title="The Xteink X4 E-Ink Reader" description="I've had the Xteink X4 for a couple of months now, a £40 e-ink reader small enough to stick to the back of a phone." image="og/xteink-x4-e-ink-reader.png" %}
{% include posts/og-demo.html title="How I'm using CSS View Transitions on this blog" description="In the old days of the web, animating between pages meant faking it with jQuery. Then came pjax, which used pushState to swap in fetched content and fake a full navigation without one." image="og/how-im-using-css-view-transitions-on-this-blog.png" %}
</div>

I went with build time, in the GitHub Actions build I already have. Jekyll writes out a list of the posts, and a [Node script](https://github.com/omgmog/omgmog.github.com/blob/main/scripts/og-images.mjs) reads that list and renders an image for each one. The layout then points at the results.

## Export the posts as JSON

The script needs each post's title, date and category, and Jekyll already has them. So I have Jekyll generate a JSON file, `og-manifest.json`, from a page that loops over every article with Liquid:

```liquid
{% raw %}---
permalink: /og-manifest.json
layout: null
---
{% assign og_docs = site.documents | where: "content_type", "article" %}
{
  "categories": {{ site.data.categories | jsonify }},
  "posts": [
{% for doc in og_docs %}    {
      "slug": {{ doc.slug | jsonify }},
      "title": {{ doc.title | jsonify }},
      "category": {{ doc.category | jsonify }},
      "date": {{ doc.date | date: "%-d %b %Y" | jsonify }}
    }{% unless forloop.last %},{% endunless %}
{% endfor %}  ]
}{% endraw %}
```

The manifest also includes the site's categories. Every post here belongs to one, each with its own colour and icon. I pass those along for the card template to use, so the image matches the category badges on the site. The real file has a few more fields, such as the reading time for the footer.

## Rendering them with Chrome

The script reads the manifest from the built `_site`. For each post, it builds a small HTML page (the category badge, the title, the date and the site name), then asks [headless Chrome](https://developer.chrome.com/docs/chromium/headless) to screenshot it. The GitHub runner image already has Chrome, so the script doesn't need any dependencies:

```js
spawn(chrome, ["--headless=new", "--window-size=1200,630", `--screenshot=${png}`, `file://${file}`])
```

Title length is the awkward part. A short title should be big and a long one has to shrink. A few lines of JavaScript in the page start at 136px and step down 2px at a time until the heading fits between the header and the footer. If a title doesn't fit even at 52px, the text is clamped to the last line that does.

<div class="og-demos og-demos--thirds">
{% include posts/og-demo.html layout="image" image="og/tea-weather.png" caption="A short title" alt="The card for a post titled Tea weather, with the title set very large on one line" %}
{% include posts/og-demo.html layout="image" image="og/o-cursor-where-art-thou.png" caption="A medium title" alt="The card for a post titled O cursor, where art thou?, set on two lines" %}
{% include posts/og-demo.html layout="image" image="og/rebuilding-wordle-stats-from-whatsapp.png" caption="A long title" alt="The card for a post titled Rebuilding and analysing 4 years of Wordle stats from WhatsApp chat logs, set smaller on three lines" %}
</div>

Each generated image is cached under a hash of what went into it (the post's manifest entry, its category, and a `TEMPLATE_VERSION` constant I bump when I change the design). If the hash matches a file in `.cache/og`, the script copies that file into place and Chrome never starts. A new or retitled post renders one image and everything else is a copy.

The site is [built and deployed by GitHub Actions](/post/moving-to-github-actions-and-adding-txt-posts/). The only addition is a step after the [Jekyll build](/post/chasing-build-speed-on-jekyll-4/) that runs the script and then deletes the manifest, which was only there for it:

```yaml
- name: Render social images
  run: |
    CHROME=google-chrome node scripts/og-images.mjs
    rm _site/og-manifest.json
```

The images are written straight into the built `_site/images/og/`. The `.cache/og` folder is saved between runs with the [cache action](https://github.com/actions/cache), so the hashes above have something to match.

## Using the image

The layout picks the image by slug and falls back to a default card for everything that isn't a post:

```liquid
{% raw %}{% if page.layout == 'post' %}{% capture og_image %}/images/og/{{ page.slug }}.png{% endcapture %}
{% else %}{% assign og_image = '/images/og/default.png' %}{% endif %}
{% assign og = page.ogimage | default: og_image %}{% endraw %}
```

A post can still set `ogimage` in its front matter to override it. The default card takes its headline from the home page, so it always matches the home page. The same path goes into each post's [JSON-LD](https://json-ld.org/), the structured data that search engines read.

Now every post gets its own card automatically on deploy, and sharing an old link in a feed finally looks like the post it points to rather than the same yellow-bordered avatar every time.
