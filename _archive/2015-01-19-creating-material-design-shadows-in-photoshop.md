---
comments_issue: 68
title: Creating 'Material Design' shadows in Photoshop
---

Somebody over on [Designer News](https://news.layervault.com/) asked how to re-create the various `z-height` shadow effects from [Google's Material Design](http://www.google.co.uk/design/spec/material-design/introduction.html) in Photoshop.

<!-- more -->

This is something I've been playing with a bit lately, so I dove in to the `CSS` from the [Polymer Project documentation](https://www.polymer-project.org/docs/elements/material.html#shadow-effect), found the `z-height` styles, and then whipped up a `.psd` to demonstrate how to achieve the effect:

{% include posts/figure.html src="pEevcJ5.png" %}{:.massive.center}

[Download the PSD](https://www.dropbox.com/s/vjupzyizfiinko2/material-z-height.psd?dl=0)

## An explanation of the styles

The Material Design shadows are actually comprised of two shadows on each element, as you can see below. This example shows the `z-height: 5` shadow. First the 'top shadow', then the 'bottom shadow', then the effect caused by composing them together:

{% include posts/figure.html src="fCeLGoe.png" %}{:.massive.center}

You'd use something like this to create the `z-height: 5` shadow effect using `CSS`:

```css
.paper-shadow-z-5 {
    box-shadow:
        0 40px 77px 0 rgba(0,0,0,.22),
        0 27px 24px 0 rgba(0,0,0,.2);
}
```

And in Photoshop... bottom on the left, top on the right:

{% include posts/figure.html src="ruwAkDd.png" %}{:.massive.center}

### Updated for Adobe Photoshop CC 2015

Today Adobe Photoshop CC 2015 was released, with support for multiple (up to 10) instances of each layer style per layer. This coupled with the ability to 'Copy CSS' for a layer means that we can do this a lot more easily.

Here's a preview of the same effect, but using the new functionality:

{% include posts/figure.html src="material-z-height-cc2015.png" %}{:.massive.center}

Here is an updated version of the PSD that will only work in CC2015+:

[Download the PSD for CC2015](https://dl.dropboxusercontent.com/u/19772/material-z-height-cc2015.psd)

### Update 2

[dbox](https://twitter.com/dbox) has created a CC Library and SCSS mixin to make things a little easier:

- [Material Shadows CC Library](http://adobe.ly/1QYDXAC)
- [Material Shadows SCSS mixin](http://codepen.io/dbox/pen/RawBEW)
