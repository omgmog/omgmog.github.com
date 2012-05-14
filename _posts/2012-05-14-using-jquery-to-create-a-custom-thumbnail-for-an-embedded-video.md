---
layout: post
title: "Using jQuery to create a custom thumbnail for an embedded video"
description: ""
large_cover: http://f.cl.ly/items/0I2S2o0O1O1B0N3r3828/youtube.jpg
tags: ["jquery", "projects", "blog", "software", "javascript", "software"]
hasgist: true
---
{% include JB/setup %}

Recently [Jenny](http://twitter.com/jennybroomfield) asked me for a way to embed a YouTube video with a custom thumbnail that would play the video when clicked.

I'm aware that YouTube allows [Partners](http://support.google.com/youtube/bin/topic.py?hl=en&topic=1100428) to use a custom thumbnail for their videos, but standard users are restricted to a selection of random frames from their uploaded video. If you want your YouTube embed to look nice on your site, but are not a Partner, this isn't ideal.

I Googled around to look for a solution, but most solutions involve adding extra frames to the video at specific intervals, and trimming videos using YouTube once they've been uploaded. Again, not ideal.

I decided to approach this from a more technical angle then, and so I came up with the following jQuery snippet
<div class="gist"><a href="https://gist.github.com/2690184">https://gist.github.com/2690184</a></div>

This needs to be used with the following `HTML` structure:
<div class="gist"><a href="https://gist.github.com/2690199">https://gist.github.com/2690199</a></div>

And there you have it, a custom thumbnail for a YouTube embedded video.

<cite>Cover from <a href="http://artslope.com/wp-content/uploads/2010/07/buttons.jpg">http://artslope.com/wp-content/uploads/2010/07/buttons.jpg</a></cite>