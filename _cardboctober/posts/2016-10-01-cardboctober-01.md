---
title: "01: Basic VR"
has_hack: true
redirect_from:
  - /post/cardboctober-01/
---

Kicking off Cardboctober I've decided to go with something very simple.

This is actually pretty much one of the [JSCard](https://blog.omgmog.net/jscard.xyz) demos that I created last November for my [20 Minutes into the Future with Google Cardboard and JavaScript](/post/talk-jsoxford-20-minutes-into-the-future/) talk.

<!-- more -->

I'm using Three.js (as I will be for pretty much all of the Cardboctober hacks), along with the `StereoEffect.js` and `DeviceOrientationControls.js` plugins to provide a VR experience.

## So what does this do?

Not a lot actually, it's just a spinning/bouncing red cube. If you view it through Google cardboard it will be stereoscopically 3D, and you will be able to look around.

{% include figure.html src="2016-10/01/giphy.gif" %}{:.massive.center}

Some caveats you'll find with this very primitive 3D scene are that you can't actually move from the fixed position that I've stuck the camera in, and the whole scene is oriented based on Cardinal North, so if you're facing in the wrong direction you might not see the cube.
