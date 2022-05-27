---
title: A Bit of a Bodge To Make MASSIVE Emoji
tags: [indieweb, guide]
comments_issue: 116
syndication:
  - https://social.omgmog.net/2022/-i-was-complaining-about-css-not
  - https://indieweb.social/@omgmog/108250071839919233
---

I've been fiddling with an instance of [Known](https://withknown.com/opensource) over on [social.omgmog.net](https://social.omgmog.net). As part of my fiddling I've been trying out some of the plugins for Known. I came across the ["Render Emoji Unicode" plugin](https://github.com/mapkyca/KnownEmoji) but it was using an old library, and referencing an old version of Twemoji, so I updated it to use the latest [Twemoji](https://twemoji.twitter.com) library.

<!-- more -->

## Twe-who-ji?

> Twitter’s open source emoji has you covered for all your project's emoji needs. With support for the latest Unicode emoji specification, featuring 3,245 emojis, and all for free.

The nice thing about Twemoji is that you can parse a chunk of text and convert any matched emojis to their Twemoji-based `img` counterparts. Why would you want to do this? Well for me it's for consistency. I don't like the per-platform variation with emoji.

To get started, you first load the library from a CDN and then tell it what to parse:

```javascript
twemoji.parse(document.body);
```

By default it will use .png images, but you can tell it to use .svg. it will replace any emoji it finds with an `img` tag referencing the appropriate image:

```html
💩

becomes

{% raw %}<img draggable="false" class="emoji" alt="💩" src="https://twemoji.maxcdn.com/v/14.0.2/svg/1f4a9.svg">{% endraw %}
```

## Let me take you on a journey

I've always enjoyed how Slack makes the emoji in messages containing just emoji massive -- _JUMBOMOJI_ -- and so I thought it'd be cool to bring that feature to my site too.

{% include posts/figure.html src="2022-05/emoji-slack.png" %}{:.center}

My first thought was that I could use the `:only-child` pseudo-selector to select a solo `<img class="emoji" />`. It worked, sort of, except it also detected any single `img.emoji` amongst text nodes as being an `:only-child`.

[What't the deal with that?](https://social.omgmog.net/2022/its-2022-and-css-only-child-isnt-aware) Well CSS doesn't recognise the [`Text` node](https://developer.mozilla.org/en-US/docs/Web/API/Text) as being a distinct element like JavaScript does. It would cause all sorts of headaches if it did -- imagine having to consider how to handle chunks of whitespace in/around elements! (For now let's skip over the historical horrors of handling floated elements, inline elements, and the perils of space around them.)

We're already leveraging JavaScript to convert emoji to Twemoji, it probably wouldn't hurt too much to also process the surrounding DOM a little, would it?

## DOM traversial to keep you awake at night

So I arrived at wrapping any [non-whitespace `Text` nodes](https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType) in `<span>` tags to make it easier for CSS to explicitly recognise them as a first-class ~~citizen~~ node.

```javascript
document.querySelectorAll('.e-content').forEach(block => {
  twemoji.parse(block, {folder:'svg', ext:'.svg'});
  block.childNodes.forEach(child => {
    if (child.nodeType === 3 && child.textContent.trim().length) {
      const nodeWrapper = document.createElement('span');
      child.parentNode.insertBefore(nodeWrapper, child);
      nodeWrapper.appendChild(child);
    }
  });
});
```

It feels a bit dirty to be manipulating the DOM of all blocks containing non-whitespace text, even if there are no `img.emoji` present, but I don't imagine it will give to much of a performance hit.

Here's how it looks with my _extremely thorough test suite_:

{% include posts/figure.html src="2022-05/emoji-poop.png" %}{:.center}

> On an unrelated note, TIL that Jekyll (probably just Jekyll on Windows?) doesn't like emojis for filenames of images. At first I thought it was the way I was referencing the image in my post, so I tried the following forms: `💩`, `xn--ls8h`, `%F0%9F%92%A9` -- but none of those resolved the issue until I used a regular filename for the image. 🤷