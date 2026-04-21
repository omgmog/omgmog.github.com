---
title: "It's 2026, why are vendor prefixes still in your CSS?"
comments_issue: 141
tags: [web-development, css]
---

I've spent more time over the last 20 years working on front-end asset pipelines than I'd care to admit. One thing that kept coming up when inheriting older codebases was CSS full of vendor prefixes that hadn't been necessary for years - `-webkit-border-radius` sitting above `border-radius`, `-moz-box-shadow` doubling up on `box-shadow`.

<!-- more -->

Some of it made sense historically. One project had to support an embedded Internet Explorer 7 browser, and when your floor is IE7 you add all the prefixes, just in case. The tool to handle this automatically was there - [Autoprefixer](https://github.com/postcss/autoprefixer) - just not trusted or configured properly. So developers worked around it manually, inconsistently, and the CSS showed it.

## What vendor prefixes were for

Through the early 2010s, the alternative to `-webkit-border-radius` was slicing corner images in Photoshop and wiring them up with a pile of nested divs. Browsers were shipping experimental CSS features under vendor prefixes - `-webkit-` for Safari and Chrome, `-moz-` for Firefox, `-ms-` for IE, `-o-` for Opera - so you could use them before they were standardised. A prefixed property was still far better than corner images.

```css
.box {
  -webkit-border-radius: 10px;
  -moz-border-radius: 10px;
  border-radius: 10px;
}
```

The idea was that once the spec settled, the unprefixed version became the standard and the prefixed ones could be dropped. That worked in principle. In practice, nobody dropped them. The Sass approach was to [bundle the prefixed variants into a mixin](/post/getting-started-with-using-sass-in-your-existing-website/) so at least you only wrote them once - but the mixin still needed maintaining as browser support changed.

The CSSWG keeps a [list of CSS design mistakes](https://wiki.csswg.org/ideas/mistakes) - decisions that made sense at the time but created problems that outlasted their usefulness. Vendor prefixes would fit right in.

## The dead ones

Most of what I find in old CSS files doesn't need prefixes at all. `border-radius` and `box-shadow` have been supported without prefixes since 2011. `transition` since 2013. `transform` since 2014. `flexbox` since 2015. Flexbox is a good example of how bad it got:

```css
display: -webkit-box;
display: -webkit-flex;
display: -moz-box;
display: -ms-flexbox;
display: flex;
```

Five lines. One of them is correct. The other four are extra bytes that have done nothing for a decade. The [CSS Selection 2026](https://www.projectwallace.com/the-css-selection/2026) report found the median website still has 140 vendor-prefixed properties. `-ms-input-placeholder` - an IE-only prefix, for a browser that's been dead since 2022 - still shows up in _44% of sites_.

## The browser landscape in 2026

Part of why those prefixes are dead is just the browser market. [As of early 2026](https://gs.statcounter.com/browser-market-share/#monthly-202501-202601-bar), Chrome has around 69% of global traffic. Add Edge, Samsung Internet, and Opera - all Chromium-based - and it's closer to 78%. Safari sits at 16%, Firefox at 2.3%.

The diversity of rendering engines that made vendor prefixes necessary in the first place has largely gone. `-o-` died when Opera switched to Blink in 2013. `-ms-` died with IE. `-moz-` is barely relevant at 2.3% market share, and Firefox has dropped prefix requirements for almost everything anyway.

Which leaves `-webkit-`, and really that means Safari.

## The ones still needed

Almost all modern prefix requirements are `-webkit-` only - `tab-size` is the [one exception](https://weser.io/blog/vendor-prefixes-in-2024), still needing `-moz-`. Everything else is Safari.

Some properties need `-webkit-` because they're transitional - the standard exists but Safari hasn't dropped the prefix yet. `appearance`, `backdrop-filter`, `user-select` fall into this category.

```css
-webkit-appearance: none;
-moz-appearance: none;
appearance: none;

-webkit-backdrop-filter: blur(10px);
backdrop-filter: blur(10px);
```

Then there's a smaller set that are `-webkit-` _forever_ - no standard equivalent exists. `-webkit-text-stroke` and `-webkit-text-fill-color` for text outlines. `-webkit-tap-highlight-color` for controlling the tap flash on iOS. `-webkit-box-reflect` for reflection effects. These aren't going anywhere.

The problem is keeping track of which category a property falls into, and in which browsers. That changes over time. I'm not going to remember that.

## Copilot is making it worse

Old codebases carrying this stuff around makes sense. What I didn't expect was vendor prefixes turning up in _new_ code, written in 2025 and 2026.

A lot of it traces back to autocomplete. Copilot and tools like it are trained on the whole history of the web - including years of CSS written before Autoprefixer existed, when manually adding `-webkit-` and `-moz-` was the only way to get cross-browser support. The model has _no_ sense of what year it is. It sees a `border-radius` and it's seen thousands of examples where the prefixed versions came first, so it suggests them.

The completion looks plausible. It's not wrong in some obvious way. A developer who doesn't already know the history accepts it, commits it, and the dead code is back - not from 2012 habits, but from tooling that confidently reproduces them.

## Autoprefixer handles this

Autoprefixer with [PostCSS](https://postcss.org/) is the right answer. Write unprefixed CSS, the build step adds whatever prefixes are actually needed for the target browsers.

```css
/* write this */
.box {
  appearance: none;
  backdrop-filter: blur(10px);
  user-select: none;
}
```

```css
/* build outputs this */
.box {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  -webkit-backdrop-filter: blur(10px);
  backdrop-filter: blur(10px);
  -webkit-user-select: none;
  user-select: none;
}
```

It's driven by a [browserslist](https://github.com/browserslist/browserslist) config - either in `package.json` or a `.browserslistrc` file:

```
last 2 versions
> 1%
not dead
```

Autoprefixer checks that and adds only the prefixes those browsers need. As browsers update and drop old requirements, a target list update is all it takes - obsolete prefixes come out automatically.

PostCSS config is minimal:

```js
// postcss.config.js
module.exports = {
  plugins: [
    require('autoprefixer')
  ]
}
```

For the codebase I mentioned earlier, the migration was two things: configuring Autoprefixer properly, and going through the existing CSS to strip out all the manually-written prefixed properties. Once both were done, the CSS went from full of manual prefixes to zero.

Autoprefixer handles everything, and it knows what it's doing in a way that a developer copy-pasting from Stack Overflow doesn't. The [CSS Selection 2026](https://www.projectwallace.com/the-css-selection/2026) report noted that vendor prefixes in modern CSS "are primarily managed by CSS toolchains rather than hand-authored" - which tracks. When we finally dropped IE support, we updated the browserslist config and the prefixes came out automatically. No manual cleanup pass needed.

The broader point is that what you write in your source files doesn't have to be what gets served. The CSS you author is just input - the build step produces whatever the browser actually needs. Hand-writing vendor prefixes into source CSS is solving a problem at the wrong layer.

## Stylelint catches what slips through

Autoprefixer sorts the build output, but it doesn't stop prefixes getting committed in the first place. That's where [Stylelint](https://stylelint.io/) comes in. It has rules specifically for vendor prefixes - add them to `.stylelintrc` and any manually written prefix is a lint error.

```json
{
  "rules": {
    "property-no-vendor-prefix": true,
    "value-no-vendor-prefix": true,
    "selector-no-vendor-prefix": true,
    "media-feature-name-no-vendor-prefix": true
  }
}
```

The webkit-forever properties from earlier - `-webkit-tap-highlight-color` and the rest - need an exemption, since they're legitimately needed and Stylelint would otherwise flag them. An inline disable comment is the cleanest way to handle it, since it stays with the code that needs it:

```css
/* stylelint-disable-next-line property-no-vendor-prefix */
-webkit-tap-highlight-color: transparent;
```

It also runs as a PostCSS plugin, so if PostCSS is already in the pipeline for Autoprefixer, Stylelint can sit alongside it:

```js
// postcss.config.js
module.exports = {
  plugins: [
    require('stylelint'),
    require('autoprefixer')
  ]
}
```

Or wire it up with [husky](https://typicode.github.io/husky/) and [lint-staged](https://github.com/lint-staged/lint-staged) and it runs on commit against staged files only:

```json
{
  "lint-staged": {
    "*.css": "stylelint --fix"
  }
}
```

The `--fix` flag strips the prefixes automatically rather than just erroring. So a Copilot suggestion that sneaks in a `-webkit-border-radius` gets cleaned up before it ever hits the repo. Autoprefixer adds what's needed, Stylelint removes what isn't.
