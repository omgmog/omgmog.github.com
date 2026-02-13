---
title: High fidelity in low fidelity emails
comments_issue: 89
tags: [email, design]
archived: true
archived_comments:
- author: "Tomás Mayr"
  date: May 07, 2012
  content: |
    No one expects anything in HTML emails to be honest, as long as they look ok, I don't care, I think it is an interesting technique.
---
Recently it was pointed out to me that [Pizza Express](http://www.pizzaexpress.com/) provide a nice fallback for photos on their picture-heavy emails. Take the following example, from a promotional email they sent out earlier this year:

<!-- more -->

{% include posts/figure.html src="Screen Shot 2012-05-07 at 12.27.19.png" %}

And the same email with images disabled:

{% include posts/figure.html src="Screen Shot 2012-05-07 at 12.27.05.png" %}

And here's another example:

{% include posts/figure.html src="Screen Shot 2012-05-07 at 14.32.25.png" %}

{% include posts/figure.html src="Screen Shot 2012-05-07 at 14.31.28.png" %}

It looks as if they've used [this application from Style Campaign](http://stylecampaign.com/blog/2009/12/bypass-image-blocking-by-converting-images-to-html/) to produce the low-fi fallback. It's a java application that takes a pixel image and outputs either table-based or css-based styled markup, while allowing you to scale up your images. On the Style Campaign blog they've got lots more examples of the technique.

It's an interesting technique, either as a meaningful low-fidelity representation of the missing image, or a subtle easter-egg with a [Teletext](http://en.wikipedia.org/wiki/Teletext)-esque feel to it. Either way, the low-fidelity version resembles the original image somewhat.

The downside to this though is that there's a bunch of meaningless table markup behind that simple low-fidelity image, and the original image is then sliced up to fit these constraints, but it's a HTML email. I'm not surprised to see a couple of tables.
