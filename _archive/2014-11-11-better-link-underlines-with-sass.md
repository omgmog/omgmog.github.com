---
comments_issue: 57
title: Better link underlines with Sass
---

There has been some talk lately about how iOS 8 has started to handle typography descenders when text is underlined. They've done away with the usual overlapping line intersect in favour of a more aesthetically pleasing line crop.

<!-- more -->

{% include posts/figure.html src="mSVkI40.png" %}{:.massive.center}

You can see the differences of these two methods below:

{% include posts/figure.html src="9o1Y2RU.png" %}{:.massive.center}

That's great for the particular apps on iOS 8 on iPhones that use the new descenders, but what about everybody else?

I came across [this article from Eager](https://eager.io/blog/smarter-link-underlines/) where they detail their journey of coming up with a solution for nice descenders, and they provided a nice example using Stylus.

The solution uses a combination of background linear gradients and text shadows to give the effect of underlined text, with the descenders cutting through the underline, just as in iOS 8.

Without the effect:

{% include posts/figure.html src="9nitT8Q.png" %}{:.massive.center}

With the effect:

{% include posts/figure.html src="Syx7s6c.png" %}{:.massive.center}

I've re-created their mixin using Sass, so now you can use it in your projects:

```scss
// set this to whichever text selection color you use
$selectionColor: #b4d5fe;

// this mixin is used to add the outline to the text
@mixin textShadowToCropUnderline($color) {
  text-shadow:
    .03em 0 $color,
    -.03em 0 $color,
    0 .03em $color,
    0 -.03em $color,

    .06em 0 $color,
    -.06em 0 $color,
    .09em 0 $color,
    -.09em 0 $color,

    .12em 0 $color,
    -.12em 0 $color,
    .15em 0 $color,
    -.15em 0 $color;
}
// this puts it all together
@mixin linkUnderlines($background, $color) {
  color: $color;
  text-decoration: none;
  @include textShadowToCropUnderline($background);

  background-image:
    linear-gradient($background, $background),
    linear-gradient($background, $background),
    linear-gradient($color, $color);
  background-size:
    .05em 1px,
    .05em 1px,
    1px 1px;
  background-repeat:
    no-repeat,
    no-repeat,
    repeat-x;
  background-position:
    0% 90%,
    100% 90%,
    0% 90%;

  &::selection {
    @include textShadowToCropUnderline($selectionColor);
    background-color: $selectionColor;
  }
  &::-moz-selection {
    @include textShadowToCropUnderline($selectionColor);
    background-color: $selectionColor;
  }
  &:before,
  &:after,
  *,
  *:before,
  *:after {
    text-shadow: none;
  }
  &:visited {
    color: $color;
  }
}
```

You can use this mixin quite easily be either invoking it on your site-wide `a` styles, or targetting your `a`'s in a specific part of your styles:

```scss
.content a {
  @include linkUnderlines(#fff, #00f);
}
```

The effect does have some caveats however, but they're not major:

- The effect only really works for text on a solid background color, because of the use of backgrounds to create the underline effect, and the text shadow
- You must specify your text selection color upfront, to ensure that the effect is retained when selecting text
- There may be some slight performance issues on mobile, if you've got a lot of links with the effect applied.

To extend the mixin, you might want to provide additional vendor prefixed versions of the background size and linear gradients used above, and perhaps additional styles for `:active` and `:hover` states of links.

Coverage is pretty good, as a all modern browsers support [css3 gradients](http://caniuse.com/#feat=css-gradients) and [text shadows](http://caniuse.com/#feat=css-textshadow).
