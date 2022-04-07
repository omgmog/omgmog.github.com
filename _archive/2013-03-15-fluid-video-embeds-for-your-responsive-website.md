---
comments_issue: 31
title: Fluid video embeds for your responsive website
---
Recently I came across an interesting problem, fluidly scaling iframe/embed code on a responsive design.

{% include posts/figure.html src="responsive.png" %}{:.massive.center}

The problem surfaced because I was using a fluid width and a fixed height for my video embed, and so at some screen sizes the video would look fine, and at others it would have some black banding at the edges.

<!-- more -->

If you can bare to not just use the iframe code YouTube gives you for embedding video, then you can use this solution.

1. Wrap the video in a container
2. Give the container a fluid width
3. Add vertical padding to the container to get the correct aspect ratio
4. Make the video 100% width and height
5. Position everything


Here's an example:

```css
.embedded-video-wrapper {
    position: relative;

    /* Use percentage width, so it scales */
    width: 100%;

    /* and this is where the magic happens */
    height: 0;
    padding-bottom: 56.25%; /* a magic number! */
}

.embedded-video-wrapper > * {
    position: absolute;
    top: 0;
    left: 0;

    /* make the iframe/embed fill the wrapper */
    height: 100%;
    width: 100%;
}
```

You might notice that I've used a `magic number` in there, `56.25%` -- it's not that magic actually.. For a `16:9` aspect ratio video, `9` is `56.25%` of `16`. The key is to remember that the total height of a parent container (the wrapper) is the height plus the vertical padding.

Here's a lookup table for the various standard video aspect ratios:
- `4:3 : 75%      (SD)`
- `16:9 : 56.25%   (HD)`
- `1.85:1 : 54.05%   (Cinema)`

Taking it one step further, to make this easily reusable, you could create classes for each of the aspect ratios:

```css
.embedded-video-wrapper {
    position: relative;

    width: 100%;
    height: 0;
}

.embedded-video-wrapper > * {
    position: absolute;
    top: 0;
    left: 0;

    height: 100%;
    width: 100%;
}

/* aspect ratio classes */
/* N.B. these ratios assume 100% width, if a smaller width, scale down proportionally */
.sd {
    padding-bottom: 75%;
}
.hd {
    padding-bottom: 56.25%;
}
.cinema {
    padding-bottom: 41.84%;
}
```

And then you'd use the following `HTML`, the only adjustment from the code that YouTube provide is that I've wrapped it in a div, and removed the width/height properties (though it should work fine if you leave them as-is, because the CSS will override them)

```html
<div class="embedded-video-wrapper hd">
    <iframe
        src="http://www.youtube.com/embed/xEhaVhta7sI"
        frameborder="0"
        allowfullscreen
    ></iframe>
</div>
```

You could give your `.embedded-video-wrapper` any width you like now, and the video height will scale proportionately.

