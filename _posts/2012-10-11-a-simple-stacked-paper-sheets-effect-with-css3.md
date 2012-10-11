---
layout: post
title: "A simple 'stacked paper sheets' effect with CSS3"
description: ""
large_cover: http://f.cl.ly/items/0i3e2G0t3Y0s2Z07362z/paper.jpg
tags: ["blog", "chrome", "css", "projects", "software"]
---
{% include JB/setup %}

This is just a short post about an unobtrusive CSS3 effect that I"ve used on some projects lately. Using the `::before` and `::after` CSS pseudo elements and some CSS3 styles you can make a simple HTML element look like a stack of paper sheets.

Like the sound of that? read on.

![The end product](http://f.cl.ly/items/3i1b3a2t2f3I0M2N161O/by%20default%202012-10-11%20at%2014.30.45.png)

First of all, the HTML markup:

<pre>
<code class="html">&lt;article>
    &lt;h2>Article title here&lt;/h2>
    &lt;p>Lorem ipsum dolor sit amet...&lt;/p>
&lt;/article></code>
</pre>

This is only a fraction of what you might have on the page, but I"m sure you can figure that out. This isn"t limited to just the `article` element either, you can adjust this to use whatever you like. Now, the CSS:

<pre>
<code class="css">article {
    <strong>position: relative;</strong>
    margin: 100px auto;
    padding: 40px 0;
    width: 720px;
}
article::before,
article::after {
    <strong>content: "";</strong>
    width: 710px;
    height: 250px;
    <strong>position: absolute;</strong>
    left: -2px;
    top: -5px;
    <strong>z-index: -1;</strong>
    <strong>-moz-transform: rotate(-2deg);
    -webkit-transform: rotate(-2deg);
    transform: rotate(-2deg);</strong>
}
article::after {
    left: 0;
    <strong>-moz-transform: rotate(-1deg);
    -webkit-transform: rotate(-1deg);
    transform: rotate(-1deg);</strong>
}
article,
article::before,
article::after {
    background: #fff;
    <strong>-moz-box-shadow: 0 0 3px rgba(0,0,0,0.2);
    -webkit-box-shadow: 0 0 3px rgba(0,0,0,0.2);
    box-shadow: 0 0 3px rgba(0,0,0,0.2);</strong>
}</code>
</pre>

That"s the important stuff anyway, so let"s go over this step by step:

1. We"re setting the element (in our case, it"s an `article`) to `position: relative;`.
2. We"re using `::before` and `::after` to create an empty pseudo element (`content: "";`) and then positioning it absolutely behind (`z-index: -1;`) the `article`.
3. Next, we"re using a CSS3 `ransform`, in this case `transform: rotate();` to rotate the pseudo elements slightly, to give that awesome stacked paper effect.
4. We"re also applying a CSS3 `box-shadow` to make it look like the paper is stacked.

That's all there is to it really, you can tweak the colours and rotation however you like. The only limitation with using the `::before` and `::after` pseudo elements is that you're limited to just those two pseudo elements, but if you're feeling crazy you could use multiple CSS3 `box-shadow` to simulate more sheets of paper. You can read more about CSS3 `box-shadow` and `transform` over on [Sitepoint's guide for mastering box shadows](http://www.sitepoint.com/mastering-box-shadows/) and [Sitepoint's primer on CSS3 transforms](http://www.sitepoint.com/a-primer-on-css3-transforms/).

- You can play with the code here: [Code for demo on jsfiddle](http://jsfiddle.net/YZ62u/)
- And you can see the result here: [Stacked paper with CSS3 demo](http://jsfiddle.net/YZ62u/embedded/result/)
