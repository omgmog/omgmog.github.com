---
layout: post
title: "Moving away from Twitter Bootstrap - Hello new design!"
description: ""
category: 
tags: ["jekyll", "css", "javascript", "jquery", "geekery", "projects", "software", "blog"]
---
{% include JB/setup %}

I decided it was time that I gave some attention to the design of my [Jekyll](http://jekyllbootstrap.com)-powered blog. I've been using a slightly modified version of the default [Twitter Bootstrap](twitter.github.com/bootstrap) theme since I moved to Jekyll, and that's just not good enough.

I've created the new theme from scratch, and I've thrown in some [PJAX](http://pjax.heroku.com/) wizardry to make page-loading fancier. Gone are the old post-banners, and thumbnails (which to be honest I was adding just to make things look a bit less-boring), say hello to the new, larger hero banner for the latest post!

You might notice some fancy effects on the homepage when you scroll, this is accomplished with a bit of jQuery and css3 to scale the title while parallaxing the hero banner.

I've also made a forray in to a responsive layout, so if you're viewing this on a screen smaller than 960px wide you will see some slight differences. But it's not that different.

Obviously the fancy stuff is dependant on your browser, but it should atleast look nice for anybody using Internet Explorer.
