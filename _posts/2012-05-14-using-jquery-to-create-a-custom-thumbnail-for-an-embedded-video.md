---
layout: post
title: "Using jQuery to create a custom thumbnail for an embedded video"
tags: ["jquery", "projects", "blog", "software", "javascript", "software"]
---
{% include JB/setup %}

Recently [Jenny](http://twitter.com/jennybroomfield) asked me for a way to embed a YouTube video with a custom thumbnail that would play the video when clicked.

I'm aware that YouTube allows [Partners](http://support.google.com/youtube/bin/topic.py?hl=en&topic=1100428) to use a custom thumbnail for their videos, but standard users are restricted to a selection of random frames from their uploaded video. If you want your YouTube embed to look nice on your site, but are not a Partner, this isn't ideal.

I Googled around to look for a solution, but most solutions involve adding extra frames to the video at specific intervals, and trimming videos using YouTube once they've been uploaded. Again, not ideal.

I decided to approach this from a more technical angle then, and so I came up with the following jQuery snippet

<script src="https://gist.github.com/2690184.js"> </script>

This needs to be used with the following `HTML` structure:

<script src="https://gist.github.com/2690199.js"> </script>

And there you have it, a custom thumbnail for a YouTube embedded video.
