---
title: "12: AAAAH! Zombies"
redirect_from:
  - /post/cardboctober-12/
has_hack: true
---

Today's hack was going to be built around the `gamepad` API -- but I utterly failed to get it working nicely with any of my USB or Bluetooth controllers. Not to mention that support seems patchy at best across all platforms/browsers. So I decided to make a little game instead.

<!-- more -->

{% include figure.html src="2016-10/12/giphy.gif" %}{:.massive.center}

Today's game is quite simple and quite bodged together. I stole the raycaster-based movement from [Pete's day 11 hack](https://cardboctober.github.io/pete/11/) to make it possible to move around the "level".

When you hit "Start" a hoard of zombies start moving towards you. You can move around to avoid them and if you stare at a zombie while touching the screen (or holding the button) you have a (high) chance of killing them.

I'm going to work on this some more for day 13, so keep your eyes peeled for that update!
