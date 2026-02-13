---
comments_issue: 50
title: A simple 'stacked paper sheets' effect with CSS3
tags: [css, web-development, guide]
archived: true
archived_comments:
- author: "guido"
  date: February 04, 2013
  content: |
    very nice ! are you the one who posted that on code.io ? I was looking for it since then :) thank you
- author: "Ryan Hall"
  date: April 23, 2014
  content: |
    One caveat is that if you wrap the stack in a parent div with a background color, that background color will hide the bottom pieces of paper. This is because those are being positioned absolutely with a negative z-index. One way I found to fix this is to add `position: relative; z-index: 0;` to the parent div. Example: http://jsfiddle.net/YZ62u/8/
---
This is just a short post about an unobtrusive CSS3 effect that I"ve used on some projects lately. Using the `::before` and `::after` CSS pseudo elements and some CSS3 styles you can make a simple HTML element look like a stack of paper sheets.

<!-- more -->

Like the sound of that? read on.

{% include posts/figure.html src="by default 2012-10-11 at 14.30.45.png" %}

First of all, the HTML markup:

```html
<article>
    <h2>Article title here</h2>
    <p>Lorem ipsum dolor sit amet...</p>
</article>
```

This is only a fraction of what you might have on the page, but I"m sure you can figure that out. This isn"t limited to just the `article` element either, you can adjust this to use whatever you like. Now, the CSS:

```css
article {
    position: relative;
    margin: 100px auto;
    padding: 40px 0;
    width: 720px;
}
article::before,
article::after {
    content: "";
    width: 710px;
    height: 250px;
    position: absolute;
    left: -2px;
    top: -5px;
    z-index: -1;
    -moz-transform: rotate(-2deg);
    -webkit-transform: rotate(-2deg);
    transform: rotate(-2deg);
}
article::after {
    left: 0;
    -moz-transform: rotate(-1deg);
    -webkit-transform: rotate(-1deg);
    transform: rotate(-1deg);
}
article,
article::before,
article::after {
    background: #fff;
    -moz-box-shadow: 0 0 3px rgba(0,0,0,0.2);
    -webkit-box-shadow: 0 0 3px rgba(0,0,0,0.2);
    box-shadow: 0 0 3px rgba(0,0,0,0.2);
}
```

That"s the important stuff anyway, so let"s go over this step by step:

1. We"re setting the element (in our case, it"s an `article`) to `position: relative;`.
2. We"re using `::before` and `::after` to create an empty pseudo element (`content: "";`) and then positioning it absolutely behind (`z-index: -1;`) the `article`.
3. Next, we"re using a CSS3 `ransform`, in this case `transform: rotate();` to rotate the pseudo elements slightly, to give that awesome stacked paper effect.
4. We"re also applying a CSS3 `box-shadow` to make it look like the paper is stacked.

That's all there is to it really, you can tweak the colours and rotation however you like. The only limitation with using the `::before` and `::after` pseudo elements is that you're limited to just those two pseudo elements, but if you're feeling crazy you could use multiple CSS3 `box-shadow` to simulate more sheets of paper. You can read more about CSS3 `box-shadow` and `transform` over on [Sitepoint's guide for mastering box shadows](http://www.sitepoint.com/mastering-box-shadows/) and [Sitepoint's primer on CSS3 transforms](http://www.sitepoint.com/a-primer-on-css3-transforms/).

- You can play with the code here: [Code for demo on jsfiddle](http://jsfiddle.net/YZ62u/)
- And you can see the result here: [Stacked paper with CSS3 demo](http://jsfiddle.net/YZ62u/embedded/result/)
