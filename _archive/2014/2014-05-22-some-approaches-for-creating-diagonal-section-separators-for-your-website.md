---
title: Some approaches for creating diagonal section separators for your website
comments_issue: 97
---

In their simplest form, web pages are made of stacked rectangles. Every [block-level element](https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements) takes up as much vertical space as the content requires, and fills as much horizontal space as is available. Additionally, block-level elements can have their width/height specified. When you have absolutely positioned, or floated elements this changes a bit but the rule pretty much sticks.

<!-- more -->

How can we break up the monotony of stacked rectangles in our designs? CSS3 gives us [border-radius](https://developer.mozilla.org/en-US/docs/Web/CSS/border-radius) and [box-shadow](https://developer.mozilla.org/en-US/docs/Web/CSS/box-shadow), and they do quite a good job at taking the *edge* off of those rectangles, but at the end of the day they're still rectangles.

What about more dynamic shapes? How about diagonal separations between content? In this article I'm going to go over a couple of methods I've found to create the illusion of diagonal separations, to break up (or perhaps knock-over) the stacked rectangles that we're so used to seeing.


### Approach #1: Simply using a background image

This is the first approach that you might try when trying to achieve this effect. If you're working with a fixed width site this is very easy to do, you can just make a static image and apply it as a background.

When it comes to scaling though you'll have some problems, take the following example. First a fixed width, and then a fluid %-based width:

{% include posts/figure.html src="Ca2hBff.png" %}{:.massive.center}

The background works fine in the first example, but as soon as your element exceeds the width of the image you're going to have a bad time.

### Approach #2: Using a background image that scales

You can use `background-size` to make a background fill the element it's applied to, this works quite nicely for creating fluid/scalable backgrounds, and fixes our scaling problem. Used in combination with a small amount of maths, it can be quite powerful!

```html
<div class="diagonal-background">
    <!-- this is an empty element -->
</div>
```

```css
.diagonal-background {
    width: 100%;
    height: 0;
    padding: 7% 0 0;
    background-size: cover;
    background-image: url(diagonal-bg.png);
    background-position: 50%;
    background-repeat: no-repeat;
}
```

To make a background image that will scale to the dimensions of the element it's applied to you need to give the background a `background-size` of `cover`, and then calculate the height needed to display the full image without cutting anything off.

Here is the image:

{% include posts/figure.html src="ZR0qEPI.png" %}{:.massive.center}

This dimensions of the image are 1000 x 60 px. To work out the height as a percentage of the width, you can use the following:

`((height/width)*100) + 1` = `((60/1000)*100) + 1` = `7`.

For this image then, we need the height of the element to be 7%. You can't just apply this using the `height` property though, as that will make the height 7% of the parent of the element, so we set the height to 0 and give the element a top padding of 7%:

```css
.diagonal-background {
    height: 0;
    padding: 7% 0 0;
    background-size: cover;
    background-image: url(diagonal-bg.png);
    ...
}
```

Lastly we need to position the `.diagonal-background` element absolutely at the bottom of the parent element.

```css
left: 0;
right: 0;
bottom: 0;
position: absolute;
```

{% assign iframe_url = "https://jsfiddle.net/U7vMH/embedded/result" %}
{% include posts/figure.html type="iframe" %}

### Approach #3: Using SVG for a background image that scales _well_

If you spend any time looking at the diagonal background, or if you're using a retina screen, you might notice that the more you scale the image (above the original size) the fuzzier the edges get.

Fuzzy PNG:

{% include posts/figure.html src="HbmCtVP.png" %}{:.massive.center}

Crisp SVG:

{% include posts/figure.html src="g249Exx.png" %}{:.massive.center}

SVG or "[scalable vector graphics](http://en.wikipedia.org/wiki/Scalable_Vector_Graphics)", means that the image is a vector (rather than a raster) and is designed to scale. You can scale an SVG to any size without losing any quality. SVG is supported in all modern browsers (even IE9+) [http://caniuse.com/svg](http://caniuse.com/svg).

There's an added bonus here, as SVG is scalable, you can create an even smaller starting image (100x6 for example) which will mean that the SVG is 35% (403 bytes vs 1183 bytes) of the size of the PNG used earlier. See the example:

{% assign iframe_url = "https://jsfiddle.net/3zt98/embedded/result" %}
{% include posts/figure.html type="iframe" %}

### Approach #4: Improving this by using CSS pseudo elements

Now you've got working diagonal backgrounds, but it's not ideal as you've got to insert an extra element for the sake of aesthetics. Let's improve that by using a pseudo element (`::before`, or `::after`).

Change the selector from

```css
.diagonal-background {
    ...
```

to

```css
.section::after {
    ...
```

And then as it's a pseudo element, you need to give it the `content` property:

```css
.section::after {
    content: '';
    ...
```


### Approach #4: Using the power of Sass mixins

If you're planning to use multiple different diagonal separator backgrounds, it can be annoying to have to set each one up individually. Wouldn't it be be better if you could apply one of these background using a single line? (*in modern browsers, that support SVG)


Introducing the power of Sass:

```scss
@mixin diagonal-background($width, $height, $color) {
    position: relative;
    &::after {
        $w_int: $width/1px;
        $h_int: $height/1px;
        $v_pad: ($height / $width) * 100 + 1;
        // we must use rgb because the # in hex doesn't work in some browsers
        $rgb_color: 'rgb(#{red($color)}, #{green($color)}, #{blue($color)})';

        padding: #{$v_pad}% 0 0;
        background-position: 50%;
        background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="#{$w_int}" height="#{$h_int}"><polygon points="0,#{$h_int} #{$w_int},0 #{$w_int},#{$h_int}" style="fill:#{$rgb_color};stroke:#{$rgb_color};stroke-width:0"></polygon></svg>');
        background-repeat: no-repeat;
        background-size: cover;
        position: absolute;
        width: 100%;
        height: 0;
        bottom: 0;
        content: '';
    }
}
```

This Sass mixin will let you specify the width/height/color of your diagonal separator background, and then it will generate an SVG and apply it using a pseudo element as I've described above.

```scss
.section {
    @include diagonal-background(1000px, 60px, #2ECC71);
}
```

Not bad!

{% assign iframe_url = "https://jsfiddle.net/ves2g/embedded/result" %}
{% include posts/figure.html type="iframe" %}

This works pretty perfectly in Chrome, but it may have some issues in other browsers. If you can't see the nice diagonal lines in the example above, here is a picture to illustrate how the final result looks:

{% include posts/figure.html src="dKWd4V7.png" %}{:.massive.center}
