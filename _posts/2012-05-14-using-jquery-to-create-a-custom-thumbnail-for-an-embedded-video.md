---
layout: post
title: "Using jQuery to create a custom thumbnail for an embedded video"
tags: ["jquery", "projects", "blog", "software", "javascript", "software"]
---
Recently [Jenny](http://twitter.com/jennybroomfield) asked me for a way to embed a YouTube video with a custom thumbnail that would play the video when clicked.

<!-- more -->

I'm aware that YouTube allows [Partners](http://support.google.com/youtube/bin/topic.py?hl=en&topic=1100428) to use a custom thumbnail for their videos, but standard users are restricted to a selection of random frames from their uploaded video. If you want your YouTube embed to look nice on your site, but are not a Partner, this isn't ideal.

I Googled around to look for a solution, but most solutions involve adding extra frames to the video at specific intervals, and trimming videos using YouTube once they've been uploaded. Again, not ideal.

I decided to approach this from a more technical angle then, and so I came up with the following jQuery snippet

{% highlight javascript linenos %}
$(function(){
  $('.ytembed:not(.processed)').addClass('processed').each(function() {
    $(this).find('a').click(function(e) {
      e.preventDefault();
      var width = $(this).find('img').width();
      var height = $(this).find('img').height();
      var url = $(this).attr('href');
      var $iframe = $('<iframe src="'+url+'" width="'+width+'"
       height="'+height+'" frameborder="0"/>');
      $(this).parent().html($iframe);
    });
  });
});
{% endhighlight %}

This needs to be used with the following `HTML` structure:

{% highlight html linenos %}
<!-- you need a div with the class 'ytembed' -->
<div class="ytembed">
    <!-- put a link with the url + embed options of your video -->
    <a href="http://www.youtube.com/watch?v=dQw4w9WgXcQ?rel=0&showinfo=0&autohide=1&autoplay=1&wmode=transparent">
        <!-- and a thumbnail, with the width/height specified -->
        <img
            width="560"
            height="315"
            src="/path/to/custom_thumbnail.jpg"
            alt="Click to play"
        />
    </a>
</div>
{% endhighlight %}

And there you have it, a custom thumbnail for a YouTube embedded video.
