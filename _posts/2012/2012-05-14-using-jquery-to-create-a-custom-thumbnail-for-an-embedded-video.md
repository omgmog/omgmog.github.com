---
comments_issue: 25
title: Using jQuery to create a custom thumbnail for an embedded video
tags: [jquery, javascript, youtube, guide]
archived: true
archived_comments:
- author: "Kelsey Brookes"
  date: October 07, 2012
  content: |
    Hi there - this is exactly what I've been looking for, but have been unable to get it to work.No console errors and JQuery is being called. Clicking behaves as if the function was not present and redirects straight to YouTube - I'd appreciate any suggestions for tracking down the problem!
- author: "Max Glenister"
  date: December 11, 2012
  content: |
    Hi Kelsey, are you preventing default? You need to do this as the first thing inside the click function on the a, such as:$(this).find('a').on('click', function(e){ e.preventDefault(); // other stuff});
- author: "Kelsey Brookes"
  date: December 11, 2012
  content: |
    Hi Max, I can't even recall which project I wanted to use this on... it's likely that I was trying to use it with Viddler, Joomla/K2 and some kind of modal window.Glad you replied at this point tho, I have another project that will require YouTube and custom thumbs (and Joomla/K2 and modals) starting shortly.
- author: "Robbie"
  date: September 19, 2014
  content: |
    Doesn't seem to work on ipad. Looks like it looks for a flash player??
- author: "Max Glenister"
  date: September 19, 2014
  content: |
    Will depend entirely on what YouTube serve via the iframe.
---
Recently [Jenny](http://jennybroomfield.co.uk) asked me for a way to embed a YouTube video with a custom thumbnail that would play the video when clicked.

<!-- more -->

I'm aware that YouTube allows [Partners](http://support.google.com/youtube/bin/topic.py?hl=en&topic=1100428) to use a custom thumbnail for their videos, but standard users are restricted to a selection of random frames from their uploaded video. If you want your YouTube embed to look nice on your site, but are not a Partner, this isn't ideal.

I Googled around to look for a solution, but most solutions involve adding extra frames to the video at specific intervals, and trimming videos using YouTube once they've been uploaded. Again, not ideal.

I decided to approach this from a more technical angle then, and so I came up with the following `jQuery` snippet

```javascript
$(function () {
    $('.ytembed:not(.processed)').each(function () {
        var $embed = $(this),
            $img = $embed.find('img'),
            $anchor = $embed.find('a'),
            width = $img.width(),
            height = $img.height(),
            url = $anchor.attr('href'),
            $iframe = $('<iframe />', {
                'src': url,
                'width': width,
                'height': height,
                'frameborder': 0
            });

        $anchor.click(function (e) {
            e.preventDefault();
            $embed.html($iframe);
        });
    });
});
```

This needs to be used with the following `HTML` structure:

```html
<!-- you need a div with the class 'ytembed' -->
<div class="ytembed">
    <!-- put a link with the url of your video embed -->
    <a href="http://www.youtube.com/watch?v=dQw4w9WgXcQ">
        <!-- and an image with the width/height specified -->
        <img
            width="560"
            height="315"
            src="/path/to/custom_thumbnail.jpg"
            alt="Click to play"
        />
    </a>
</div>
```

And there you have it, a custom thumbnail for a YouTube embedded video.
