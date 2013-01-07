---
layout: post
title: "High fidelity in low fidelity emails"
tags: ["blog", "geekery", "usability"]
---
{% include JB/setup %}

Recently it was pointed out to me that [Pizza Express](http://www.pizzaexpress.com/) provide a nice fallback for photos on their picture-heavy emails. Take the following example, from a promotional email they sent out earlier this year:

![High-quality curves](http://f.cl.ly/items/413Q173i2E1P3i3A0I1d/Screen%20Shot%202012-05-07%20at%2012.27.19.png)

And the same email with images disabled:

![Look ma: no images!](http://f.cl.ly/items/15013H3u1V2c0l2B2e1s/Screen%20Shot%202012-05-07%20at%2012.27.05.png)

And here's another example:

![with images](http://f.cl.ly/items/2u0u2p3F073s3O0O1i26/Screen%20Shot%202012-05-07%20at%2014.32.25.png) 

![sans-images](http://f.cl.ly/items/0Y3B1s1E071K3P0Z3H0k/Screen%20Shot%202012-05-07%20at%2014.31.28.png)

It looks as if they've used [this application from Style Campaign](http://stylecampaign.com/blog/2009/12/bypass-image-blocking-by-converting-images-to-html/) to produce the low-fi fallback. It's a java application that takes a pixel image and outputs either table-based or css-based styled markup, while allowing you to scale up your images. On the Style Campaign blog they've got lots more examples of the technique.

It's an interesting technique, either as a meaningful low-fidelity representation of the missing image, or a subtle easter-egg with a [Teletext](http://en.wikipedia.org/wiki/Teletext)-esque feel to it. Either way, the low-fidelity version resembles the original image somewhat.

The downside to this though is that there's a bunch of meaningless table markup behind that simple low-fidelity image, and the original image is then sliced up to fit these constraints, but it's a HTML email. I'm not surprised to see a couple of tables.
