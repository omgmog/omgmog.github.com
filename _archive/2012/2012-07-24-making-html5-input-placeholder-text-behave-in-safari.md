---
comments_issue: 80
title: Making HTML5 input placeholder text behave in Safari
---
Making assumptions during web development is never a good idea -- especially if your assumptions are about the way a new feature will behave across modern browsers. This is an issue because of two things:

<!-- more -->

1. There are a large number of 'modern' browsers that need to be supported.
2. The HTML5 specification isn't fully supported by all of these browsers, or isn't supported in the same way from browser to browser.

This issue rears its ugly head in one way or another in my day to day life. First of all, regarding the 'modern' browsers that need to be supported, we've got:

1. Internet Explorer - 7, 8, 9
2. Firefox - 3.6, 4.0, 14.0-*
3. Chrome

These browsers all have their own implementations of new CSS/HTML5 features, some work out of the box, some need polyfills ([What is a polyfill?](http://remysharp.com/2010/10/08/what-is-a-polyfill/)), some need vendor-prefixes ([What are vendor-prefixes?](http://peter.sh/experiments/vendor-prefixed-css-property-overview/)).

Back to the context of `placeholder` text in Safari then, I had been developing in Chrome on Mac OS X, and I had assumed that as both Safari and Chrome use Webkit as their rendering engine, there would be little difference between them. I was quite wrong.

The issue here is how each browser supports styling of the `placeholder` text. Here's a matrix of the style support:

{% include posts/figure.html src="by%20default%202012-07-24%20at%2012.17.12.png" %}{:.massive.center}

(From [John Catterfeld's blog: Styling the HTML5 placeholder](http://blog.ajcw.com/2011/02/styling-the-html5-placeholder/))

As you can see we're given little in the way of actually styling `placeholder` text.

```scss
::-webkit-input-placeholder {
    // styles
}
::-moz-placeholder {
    // Firefox 19+
    // styles
}
:-ms-input-placeholder {
    // styles
}
:-moz-placeholder {
    // Firefox 18-
    // styles
}
```

These are the selectors you should use to actually style placeholder text.

Webkit has implemented `placeholder` text 'wrong'. Well, at least it's wrong according to the spec, as the `placeholder` text does not get cleared when you focus the `input` element.

> User agents should present this hint to the user, after having stripped line breaks from it, when the element's value is the empty string and/or the control is not focused (e.g. by displaying it inside a blank unfocused control and hiding it otherwise).

[WHATWG - the-placeholder-attribute](http://www.whatwg.org/specs/web-apps/current-work/multipage/common-input-element-attributes.html#the-placeholder-attribute)

Anyway, enough background, on to my problem. First of all, let's see how browsers handle `placeholder` text with and without a `line-height` applied to the `input`.

## Firefox

{% include posts/figure.html src="by%20default%202012-07-24%20at%2011.09.57.png" %}{:.massive.center}

## Opera

{% include posts/figure.html src="by%20default%202012-07-24%20at%2014.09.35.png" %}{:.massive.center}

## Chrome

{% include posts/figure.html src="by%20default%202012-07-24%20at%2011.08.57.png" %}{:.massive.center}

## Safari

{% include posts/figure.html src="by%20default%202012-07-24%20at%2011.08.48.png" %}{:.massive.center}

You can play with the [jsFiddle](http://jsfiddle.net/wfYFW/) that I made to test this here:

{% assign iframe_url = "http://jsfiddle.net/wfYFW/embedded/result/" %}
{% include posts/figure.html type="iframe" %}


I wrote this blog post after I found the cause for the issue I was having in Safari, so I've prepared these screenshots with the solution in place. As you can see, Safari messes up the alignment of `placeholder` text if you've set `line-height` on the `input` element. I believe this is a bug, because the `input` respects the line-height declaration as soon as you begin typing (and the `placeholder` text is cleared).

Then again, for an element that is only showing a single line of text (not wrapping like `textarea` maybe setting `line-height` is incorrect. In which case, it shouldn't be supported by any browser on the `input` element.)

Given the huge difference in how different browsers handle the rendering of `padding` and other box-model metrics for the `input` element, I'm not surprised.
