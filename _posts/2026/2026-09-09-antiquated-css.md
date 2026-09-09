---
title: Antiquated CSS and why we needed it
comments_issue: 169
tags: [web-development, css]
---

I came across a catalogue of [antiquated HTML snippets and artefacts](https://vale.rocks/posts/html-relics), the kind of markup we just accepted as necessary in the `<head>` of every site.

It got me thinking about the CSS side of that same period, the stylesheets rather than the markup. My first job in 2009 was building marketing campaign pages for an electronics distributor's B2B storefront, where dropping IE6 was not a conversation anyone was going to have. Developers eventually landed on one clean way to target different IE versions, but getting there took a lot of less elegant detours.

<!-- more -->

## The clean way to target IE

[HTML5 Boilerplate](https://html5boilerplate.com/) launched in 2010 with conditional IE classes on the [`<body>` tag](https://github.com/h5bp/html5-boilerplate/blob/60dab21756d567a3511c45ad6b9e961bbc53754d/index.html), then later moved the same idea up to wrap the whole `<html>` tag instead:

```html
<!--[if lt IE 7]><html class="no-js lt-ie9 lt-ie8 lt-ie7"><![endif]-->
<!--[if IE 7]><html class="no-js lt-ie9 lt-ie8"><![endif]-->
<!--[if IE 8]><html class="no-js lt-ie9"><![endif]-->
<!--[if gt IE 8]><!--><html class="no-js"><!--<![endif]-->
```

That gave you a real class to target, so you could write `.lt-ie8 .product-grid { }` in your ordinary stylesheet, next to the rule it was correcting. h5bp cut it in version 5.0 in February 2015, by which point the browsers that needed it were mostly gone.

That was the civilised way to do it. What it replaced was worse.

## Exploiting the parser

The box model was the disagreement that defined the era. IE5 and IE5.5 read `width` and `height` as the total size of the element with padding and border included, whereas the spec said they described the content box alone. IE6 did the same any time it fell into quirks mode, which it did without a correct doctype. A box with padding needed one declared width in IE and another everywhere else, and no browser offered a way to say so.

So people found their own ways, almost all of them built on parser bugs.

```css
* html .box {
  height: 1%;
}
```

That one worked because IE6 behaved as though there was a phantom element above `html` in the tree. A selector that could never match in a correct implementation gave you a free IE6-only branch.

```css
.box {
  height: 200px;    /* everyone */
  _height: 220px;   /* IE6 */
  *height: 210px;   /* IE6 and IE7 */
  height: 230px\9;  /* meant for IE8, read by more */
}
```

The underscore hack relied on IE dropping the leading character and applying the declaration anyway, while every other browser threw the whole thing out as invalid. The star hack was the same idea with a different character.

That works because of CSS error handling rather than the cascade alone. A browser has to throw out a declaration it can't parse and keep the rest of the block, which is there so that a browser meeting a property from some later version of CSS skips it and carries on rather than discarding the whole rule. The cascade does the rest, correct value first, malformed override after, and each browser keeps the last thing it understood. The whole technique was parasitic on the one feature designed to let CSS survive its own future.

`\9` was the same trick from the other end. It sits at the end of the value rather than the start of the property, and IE8 tolerated the trailing characters and used the value regardless, where a correct parser rejected the whole declaration. The trouble was that it wasn't just IE8. Later versions kept tolerating it too, unpredictably, so a hack aimed at one browser had a habit of following you into whichever one shipped next.

The box model hack itself worked differently again:

```css
.box {
  width: 400px;         /* IE5 and 5.5 */
  voice-family: "\"}\"";
  voice-family: inherit;
  width: 300px;         /* everyone else */
}
```

IE5 mis-parsed the escaped quotes, treated the `}` inside them as the end of the rule, and never reached the second `width`. Everything else read the string properly, ignored the pointless speech-synthesis property and took the later value. [Tantek Çelik](https://tantek.com/CSS/Examples/boxmodelhack.html) worked this one out in early 2001, while leading IE5 for Mac at Microsoft, the one browser in the family that actually got the box model right.

Silly as it looks, that hack mattered. Before it there was no safe way to build a padded, bordered layout that survived IE/Win, so anything commercial stayed on tables. It was [argued at the time](https://zeldman.com/daily/0204b.shtml) that without it, and the sleights of hand that followed it, even the people pushing hardest for standards might still have been laying out pages with tables.

None of this was designed. You were writing code whose correctness depended on someone else's mistake continuing to exist, and every IE release was a coin flip on whether your layout survived it.

## Clearing floats

Float a couple of columns inside a container and the container collapses to nothing. That's specified behaviour rather than a bug, and the fix everyone reached for was a clearfix:

```css
.clearfix:after {
  content: "";
  display: block;
  clear: both;
}

.clearfix {
  zoom: 1;
}
```

Nobody writing that was thinking about what the second rule did. The `:after` rule is the actual fix, and IE6 and IE7 didn't support generated content, so it did nothing for them. The `zoom: 1` underneath was there for those two, and it works for an entirely unrelated reason.

IE's Trident engine carried an internal flag called hasLayout, marking whether an element rendered itself or left the job to an ancestor. An element with layout contains its own floats, so `zoom: 1` clears them as a side effect. The same declaration also fixed disappearing backgrounds, doubled margins, and text that duplicated itself when you scrolled, and one contemporary write-up put [around eighty percent of IE bugs](https://www.haslayout.net/haslayout.html) down to an element not having layout.

There was no `has-layout: true`, so you set it with whichever property happened to imply it, and `zoom` was the one with no other effect on the element. It's proprietary to Microsoft and doesn't validate, which is why the advice was to tuck it inside conditional comments. I learned all this from a Position Is Everything article and then carried it around for years like a lucky charm.

By 2011 Nicolas Gallagher's ["micro clearfix"](https://nicolasgallagher.com/micro-clearfix-hack/) had trimmed the whole thing down to `:before` and `:after` with no `zoom` at all, a sign IE6 and IE7 were finally becoming someone else's problem.

## Faking things CSS couldn't do yet

IE6 had no support for alpha-transparent PNGs. Anything with soft edges or a drop shadow rendered with a solid grey or blue halo where the transparency should have been. The fix routed through another one of Microsoft's proprietary filters:

```css
.logo {
  background: url(image.png);
  _background: none;
  _filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='image.png', sizingMethod='scale');
}
```

`AlphaImageLoader` wasn't really CSS. `progid:` was IE reaching out to a COM component to composite the image itself, layered on top of the element rather than painted as an ordinary background. That's the underscore hack from earlier turning up again, on both `_background` and `_filter`, scoping the whole trick to IE6 alone.

IE7 and IE8 already rendered alpha-transparent PNGs correctly, so without the underscores they'd have run the filter needlessly too. Every other browser just uses `background` and ignores the invalid lines underneath it. Get the page's background colour slightly wrong and the transparent edges came out fringed. Use more than a couple on a page and it turned visibly sluggish, a rendering shortcut paid for in performance everywhere it touched.

Tools like IEPNGFix took a different route to the same fix, a `.htc` file attached to the element with `behavior: url(iepngfix.htc)`, another Microsoft-only mechanism, this one wiring a whole script into the element just to draw a picture properly.

Rounded corners were the same problem solved with markup instead of a filter. `border-radius` didn't exist yet, so a rounded box meant stacking several empty elements, each offset by a pixel or two, to build a curve out of straight edges. `<b>` tags were a popular choice purely because they were quick to type:

```html
<b class="rtop">
  <b class="r1"></b>
  <b class="r2"></b>
  <b class="r3"></b>
  <b class="r4"></b>
</b>
```

Generators like Nifty Corners spat this markup out for you so nobody had to hand-count pixels. None of those `<b>` tags meant anything beyond decoration, four or more of them per corner, on every rounded box on the page.

IE5 and IE6 had no `min-width` or `max-width` either, so this is how you got them:

```css
.box {
  width: expression(document.body.clientWidth > 800 ? "800px" : "auto");
}
```

This value is [recalculated continuously](https://robertnyman.com/2007/11/13/stop-using-poor-performance-css-expressions-use-javascript-instead/) while the page is in use, and moving the mouse was enough to set it off again. A handful on a page made scrolling stutter, the same trade the `AlphaImageLoader` filter above made, and plenty of sites that felt sluggish in IE were sluggish for exactly this reason.

It also meant your layout depended on JavaScript being enabled. A styling workaround had quietly become a scripting dependency.

That one wasn't even a bug. Microsoft built it on purpose, and it let a stylesheet run arbitrary script. IE8 dropped it.

## Where vendor prefixes fit in

Vendor prefixes were how a browser shipped an implementation while the spec was still being argued over, marked as unstable so nobody mistook it for settled, with the prefix dropped once it was. I [wrote about them back in March](/post/why-vendor-prefixes-are-still-in-your-css/) so I won't repeat all of it here.

What killed them was mobile. The mobile web was overwhelmingly WebKit, so everyone wrote `-webkit-` and stopped there, not from laziness, but because you were writing for the browser your users actually had. Which made `-webkit-` prefixes load-bearing, and meant other engines eventually had to honour them just to render the web correctly, precisely the outcome prefixes existed to prevent.

Flexbox got the worst of it. `display: box` with `-webkit-box-flex`, then the 2011 interim `display: flexbox`, then the modern `display: flex`. Three incompatible syntaxes, and I threw the work away twice.

Nobody ships prefixed properties for new features now. It's flags and origin trials instead, which keeps the experiments out of production rather than letting them leak in and set.

The instinct didn't die with the prefixes, though. When the iPhone X needed content kept clear of the notch, iOS 11 shipped `constant(safe-area-inset-*)`, usable only if you also set `viewport-fit=cover` in the viewport meta tag. Two point releases later it was [removed and renamed to `env()`](https://webkit.org/blog/7929/designing-websites-for-iphone-x/), breaking anyone who had adopted it early, and the advice became to ship both:

```css
padding-top: 12px;
padding-top: constant(safe-area-inset-top); /* iOS 11.0-11.2 */
padding-top: env(safe-area-inset-top); /* iOS 11.2+ */
```

Three declarations, one of them correct, and which one depends on the point release. The same problem the prefixes were meant to contain, without the prefix that would at least have flagged it as unstable.

## When it stopped being a skill

For a while this stuff was the job. Knowing that a vanished background meant hasLayout, and which property to reach for, was worth something, and I liked being the person who knew it. None of it was in a spec, and Microsoft never properly documented hasLayout at all. What existed was the community writing it up for each other, Quirksmode, Position Is Everything, A List Apart, Smashing Magazine, and a thousand personal blogs. You learned it from people who'd been bitten by it first, and then you wrote up your own.

Then a few things happened at once. Responsive design moved the interesting problems somewhere else, and I spent far more time on breakpoints and how a layout behaved at 320px than on which property triggered a rendering flag in Trident. Sass took another chunk, because once the awkward cross-browser bits lived in a mixin you wrote once, you stopped handling them daily. And Chrome went from curiosity to default, [overtaking IE globally in May 2012](https://gs.statcounter.com/press/chrome-overtakes-ie-globally-monthly), though IE was still dominant in the UK then, so it took longer to reach the work.

The last part was the work itself. Moving into industries that didn't have to support decade-old browsers meant the whole body of knowledge simply stopped coming up. It just quietly stopped being relevant, and I noticed some time later that I'd forgotten the exact syntax of things I'd once typed daily.

## What's actually been lost

Not much.

I don't miss any of it. I don't want to maintain an IE6 stylesheet or explain hasLayout to someone who joined the industry after it stopped mattering. Modern CSS is better in every practical way, and the tooling means most of the compatibility work now happens at build time.

Every example above has a dull modern answer, too. `box-sizing: border-box` turned IE's box model into the one most of us now opt into deliberately, which is a strange sort of vindication. `display: flow-root` contains floats with no `:after` rule and no `zoom`. Every browser has supported alpha-transparent PNGs for years, and `border-radius` replaced the nested-div staircase with one line. `min()`, `max()` and `clamp()` do what the expression was faking, without running script on every mouse move. And between custom properties and `calc()`, a stylesheet can work out its own values declaratively, which is roughly what `expression()` was groping towards fifteen years too early.

What has gone is legibility. A stylesheet used to tell you which browsers its author had been fighting. `* html` meant IE6, `\9` meant IE8 and whatever shipped after it, a stray `zoom: 1` meant a float had collapsed somewhere, each one a fossil of some vendor imposing something and a developer pushing back. Some of that's nothing to do with browsers now. Sass compiles, PostCSS rewrites, bundlers hash and minify, and view source, once how you learned this job, mostly shows the output of a pipeline.

There's some continuity in all this too. IE's `Page-Enter` and `Page-Exit` transitions never made it to the platform properly until the View Transition API, which I've [been using on this blog since July](/post/how-im-using-css-view-transitions-on-this-blog/). `filter` itself ended up doing the same job under the same name, `alpha()` and DX transforms gave way to a standard version, `blur()`, `drop-shadow()`, `grayscale()`, with no COM component anywhere in it.
