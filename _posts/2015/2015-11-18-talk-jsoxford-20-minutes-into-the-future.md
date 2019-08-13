---
comments_issue: 51
title: 20 Minutes into the Future with Google Cardboard and JavaScript
---

I gave this talk at [JS Oxford in November 2015](http://jsoxford.com/2015/Javascript-Story-Time/). The talk is about using JavaScript and various web APIs to create Google Cardboard experiences.

<!-- more -->

{% include figure.html src="jsoxford.jpg" %}{:.massive.center}

You can view the [slides online here](https://blog.omgmog.net/talk-jsoxford-20-minutes-into-the-future/), navigate the slides by clicking.

{% assign iframe_url = "https://www.youtube.com/embed/Ogn_cQ6F338" %}
{% include iframe_embed.html %}

I wrote the slideshow framework from scratch for the talk, using [marked.js](https://github.com/chjj/marked), [three.js](https://github.com/mrdoob/three.js/) and some custom JavaScript.

{% include figure.html src="jscardxyz.png" %}{:.massive.center}

To accompany the talk I also created some demos, these can be viewed online on [blog.omgmog.net/jscard.xyz](https://blog.omgmog.net/jscard.xyz). These are best viewed in Chrome on an Android device, but should work alright in Chrome on Mac/Windows too.

You can view the source for the slides and demos [here on Github](https://github.com/omgmog/talk-jsoxford-20-minutes-into-the-future).

To present the demos live, using an actual device, I used the Chrome extension/Android application [Vysor](http://www.vysor.io/). This allows you to stream your phone's screen over USB (via ADB), and it works really well.

<div style="width:500px; margin: auto">
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/adb?src=hash">#adb</a> with <a href="https://twitter.com/hashtag/vysor?src=hash">#vysor</a> is a great way to view/debug stuff on your <a href="https://twitter.com/hashtag/android?src=hash">#android</a> device <a href="https://twitter.com/hashtag/cardboard?src=hash">#cardboard</a> <a href="https://twitter.com/hashtag/vr?src=hash">#vr</a> <a href="https://t.co/uLLEq8DSUs">https://t.co/uLLEq8DSUs</a> <a href="https://t.co/8yoqcsY2uA">pic.twitter.com/8yoqcsY2uA</a></p>&mdash; Max Glenister (@omgmog) <a href="https://twitter.com/omgmog/status/664830711090819076">November 12, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>

Besides thinking about how to create Google Cardboard experiences using JavaScript, I've also been collecting resources about the UI/UX of VR, which I've put together as a useful list.

You can find out more about the [UI/UX in VR list here]({{ site.url }}/post/ux-in-virtual-reality/).
