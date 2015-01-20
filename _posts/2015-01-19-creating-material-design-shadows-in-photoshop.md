---
layout: post
title: "Creating 'Material Design' shadows in Photoshop"
tags: ["project", "design", "software", "hardware", "hackday", "development"]
---

Somebody over on [Designer News](https://news.layervault.com/) asked how to re-create the various `z-height` shadow effects from [Google's Material Design](http://www.google.co.uk/design/spec/material-design/introduction.html) in Photoshop.

<!-- more -->

This is something I've been playing with a bit lately, so I dove in to the `CSS` from the [Polymer Project documentation](https://www.polymer-project.org/docs/elements/material.html#shadow-effect), found the `z-height` styles, and then whipped up a `.psd` to demonstrate how to achieve the effect:

![Preview of psd](http://i.imgur.com/pEevcJ5.png)

[Download the PSD](https://www.dropbox.com/s/vjupzyizfiinko2/material-z-height.psd?dl=0)

## An explanation of the styles

The Material Design shadows are actually comprised of two shadows on each element, as you can see below. This example shows the `z-height: 5` shadow. First the 'top shadow', then the 'bottom shadow', then the effect caused by composing them together:

![Example of z5 shadow](http://i.imgur.com/fCeLGoe.png)

You'd use something like this to create the `z-height: 5` shadow effect using `CSS`:

```css
.paper-shadow-bottom-z-5 {
    box-shadow: 0 27px 24px 0 rgba(255,0,0,.2)
}
.paper-shadow-top-z-5 {
    box-shadow: 0 40px 77px 0 rgba(255,0,0,.22)
}
```

And in Photoshop... bottom on the left, top on the right:

![Settings in Photoshop](http://i.imgur.com/ruwAkDd.png)


Here are all of the drop shadow layer effect settings for each `z-height` level:

#### Z-height 1
##### Top shadow
- opacity: 16%
- angle: 90°
- distance: 2px
- size: 10px

##### Bottom shadow
- opacity: 26%
- angle: 90°
- distance: 2px
- size: 5px

#### Z-height 2
##### Top shadow
- opacity: 19%
- angle: 90°
- distance: 6px
- size: 20px

##### Bottom shadow
- opacity: 20%
- angle: 90°
- distance: 8px
- size: 17px

#### Z-height 3
##### Top shadow
- opacity: 19%
- angle: 90°
- distance: 17px
- size: 50px

##### Bottom shadow
- opacity: 24%
- angle: 90°
- distance: 12px
- size: 15px

#### Z-height 4
##### Top shadow
- opacity: 21%
- angle: 90°
- distance: 25px
- size: 55px

##### Bottom shadow
- opacity: 22%
- angle: 90°
- distance: 18px
- size: 28px

#### Z-height 5
##### Top shadow
- opacity: 22%
- angle: 90°
- distance: 40px
- size: 70px

##### Bottom shadow
- opacity: 20%
- angle: 90°
- distance: 27px
- size: 24px

