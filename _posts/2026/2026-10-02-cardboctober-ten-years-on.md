---
title: Cardboctober, ten years on
comments_issue: 171
tags: [vr, cardboctober, hardware]
---

It has been 10 years since I ran Cardboctober, a month-long hackathon in which I created something new for Google Cardboard each day and wrote about it. I considered doing it again this year, but my time is spread thinner these days than it was in 2016, so I thought I'd do a bit of a retrospective on the WebVR and Google Cardboard scene instead.

<!-- more -->

## It started with a hack day

Cardboctober didn't come out of nowhere. In July 2016, I had run [Game Dev Day](/gamedevday.club/) for JSOxford, a hack day at the Story Museum in Oxford for making games and VR in web tech, as part of Summer of Hacks. I gave the [intro to A-Frame](/talk-an-intro-to-aframe/talk.html), and people left with things like an [immersive VR art gallery](https://github.com/edent/aframedemo/tree/gh-pages) and a [maze of weeping angels](https://github.com/adjl/CryingAngels) that freeze when you look at them. [Cardboctober](/cardboctober/) was the follow-on, only with a month to fill instead of a day.

{% include posts/figure.html src="2016-09-29/cardboctober.jpg" %}{:.center}

## The stack underneath

Cardboctober ran on WebVR, or really on Three.js and a pile of polyfills. In my [post-mortem talk](/talk-cardboctober/talk.html) I boiled the whole setup down to a spinning cube in Three.js with the stereo effect plugin.

{% include posts/figure.html src="2016-10/01/giphy.gif" %}{:.center}

At the time it felt like the start of something. It wasn't, though I only clocked that in hindsight. What actually happened was a move away from VR-on-your-face experiences towards passthrough, looking at the real world through your screen instead. Not much changed in the years between: Google widened WebVR support to any Cardboard-compatible Android phone in 2017, A-Frame picked up glTF model support around the same time, and WebXR began quietly landing in A-Frame as an experimental option in late 2018, years before anyone outside the spec actually noticed. WebVR itself never became a standard, and [Chrome deprecated it in version 77](https://developer.chrome.com/blog/chrome-77-deps-rems) (September 2019) before pulling it soon after, in favour of WebXR.

WebXR is still around, though nobody's talking about it like we were in 2016. [Chrome and Edge ship it](https://caniuse.com/webxr), as does Chrome on [Android XR](https://developer.android.com/develop/xr/web), which is really aimed at smart glasses and headsets rather than a regular Android phone, where hand input is the default, and Safari on Vision Pro has it with a [gaze-and-pinch mode](https://9to5mac.com/2024/03/21/vision-webxr-input/). iOS Safari doesn't, and Firefox has it switched off, so if you're on an iPhone it still isn't there. The spec itself has barely moved either, still only a Candidate Recommendation Draft.

A-Frame went the same way, and I'd introduced a room full of people to it at Game Dev Day that same summer. Its [release notes](https://github.com/aframevr/aframe/releases) read like a slow unwinding: Cardboard mode off by default in late 2022, Gear VR and Daydream deprecated a year later, WebVR gone altogether by early 2025. It's still going, though, with 1.8.0 out in June, which is more than WebVR managed, probably because it's a general framework for 3D in the browser and never asked anyone to get too close to Three.js itself.

## Phone VR didn't last

In August 2019 the Note10 was the first Samsung phone not to support Gear VR, and the next month [Carmack gave it a eulogy at Oculus Connect](https://www.roadtovr.com/john-carmack-gear-vr-connect-6/): more users than any other Oculus headset, much worse retention, which he put down to the friction of getting started in the first place. The month after that, Google [dropped Daydream support with the Pixel 4](https://m.gsmarena.com/google_discontinues_daydream_vr_pixel_4_does_not_support_it-news-39657.php) and discontinued the headset, and it never came back on any Pixel after that. A year later, in September 2020, Samsung's [XR service switched off](https://engadget.com/samsung-is-killing-its-vr-applications-now-that-gear-vr-is-dead-181025444.html) too.

Standalone headsets took over instead, [Quest](/post/the-inevitable-oculus-quest-post/) first, then the Apple Vision Pro at £3,499, Samsung's [Galaxy XR](https://www.roadtovr.com/?p=125323) in October 2025 at $1,799, and most recently Valve's Steam Frame and Meta's Ray-Ban Display glasses. Five or six generations of hardware in ten years, and none of them with a proper grip, at prices that make a £4 bit of folded cardboard look like it's playing a different game entirely. A pandemic sat in the middle of it too, which can't have helped anyone's appetite for sharing a headset with friends. I've still got the Cardboard headsets, a Daydream with its remote and a Gear VR with its remote. I moved on from an [HTC Vive](/post/the-inevitable-htc-vive-post/) to an [Oculus Quest 1](/post/the-inevitable-oculus-quest-post/), which now sits unused.

And yet Cardboard refuses to go the same way. Google [open-sourced it in 2019](https://developers.googleblog.com/2019/11/open-sourcing-google-cardboard.html), after more than 15 million viewers had shipped, then stopped selling the viewer itself in 2021. That should have been the end of it. Instead the [SDK shipped a new release on 31 August 2026](https://github.com/googlevr/cardboard/releases), tested against a Pixel 9 Pro on Android 17 and an iPhone 17. Daydream and Gear VR are dead. A folded piece of cardboard still works, I checked it on my Pixel 11.

## Revisiting the UX week

The platforms Cardboctober was built for are mostly gone, but not everything from that month went with them. The part I'm still happiest with is the UX week, [days 15 to 21](/cardboctober/cardboctober-15/).

<div class="inline-grid two-columns">
{% include posts/figure.html src="2016-10/10/giphy.gif" %}
{% include posts/figure.html src="2016-10/09/giphy.gif" %}
</div>

- **[Day 15](/cardboctober/cardboctober-15/), comfort vs delight.** I argued that for a quick hack I could throw away comfort and interpretability and keep the delight. That was fair when the hardware couldn't do any better, but on a Quest or a Vision Pro comfort is the bare minimum, and "you can see every pixel" doesn't cut it. Delight still holds up. Stormtroopers would work just as well today.
- **[Day 17](/cardboctober/cardboctober-17/), getting information in front of someone.** I hung a HUD off the camera, and curved my [176-button beat sequencer](/cardboctober/cardboctober-11/) so every button was the same distance away and big enough for the reticle to hit from both eyes. The reticle has since given way to hands and eyes, but the rule hasn't changed (readable text, and targets big enough that it's hard to hit the wrong one). Both turn up again in the [ten tips talk](/talk-uxofvr-10-tips/talk.html) I later gave at JSOxford, as "keep text at a readable size" and "don't make UI that requires the user to turn their head a lot".
- **[Day 18](/cardboctober/cardboctober-18/), getting around.** I listed gamepad, teleport, voice and gesture as ways of moving around. My impression is that teleport and snap-turn won out and the other two never did.
- **[Days 19](/cardboctober/cardboctober-19/) and [20](/cardboctober/cardboctober-20/), which way is North.** Android reported orientation from magnetic North and iOS from wherever the phone was pointing at load, and I found out the hard way when I [presented at JS Oxford](/post/talk-jsoxford-20-minutes-into-the-future/) from a stage that faced South. I spent two posts on a calibration offset. Headsets track their own position now, and WebXR hands over a reference space that the device looks after, so it's not my problem any more.
- **[Day 21](/cardboctober/cardboctober-21/), fit.** In my talk the IPD was one hardcoded number, `effect.eyeSeparation = 1`, for everyone. Quest 3 has an IPD wheel now, Meta says its headsets cover [56 to 70mm](https://www.meta.com/en-gb/help/quest/261777072346131/), which is about 95% of adults, and Vision Pro [moves its displays on its own](https://www.macworld.com/article/2252026/how-to-apple-vision-pro-recalibrate-eye-tracking-ipd-adjustment.html).

## After Cardboctober

There was never a follow-up month. Instead, I took over the Oxford VR Crowd meetup in 2017. It ran every two months, and I hosted five of them. I also put together [uxofvr.com](http://uxofvr.com), a collection of resources I'd learned from and curated. I also built a small game, [We're Going to Space](https://github.com/omgmog/were-going-to-space), for Samsung's VR Together hackathon. It was a Three.js WebVR scene for phones and headsets, more or less what I'd been doing with Cardboard. I didn't leave myself enough time for it, and spent too much of what I had tweening objects along paths.

{% include posts/figure.html src="now/space.gif" %}{:.center}

Ten years on, the scene looks a lot like my cupboard: a stack of dead platforms and headsets I'm not getting rid of, and no obvious reason any of it should still matter. WebVR, Daydream, Gear VR, all gone. WebXR is alive but quiet. And the thing that's still going, the thing that cost the least and promised the least, is a folded piece of cardboard.
