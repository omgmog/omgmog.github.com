---
title: "19: Which way is North? Part 1"
---

When developing for Google Cardboard VR with JavaScript we're depending on the browser's support of device orientation to know which way the user is looking. You can't guarantee the user is always looking in the direction you've oriented your scene.

<!-- more -->

This is probably one of the most glaring problems you'll encounter when you finally get your VR experience in to the hands of a real user, and you'll kick yourself for not noticing it sooner.

For me this happened while presenting some demos as part of my "[20 Minutes into the Future with Google Cardboard and JavaScript](/post/talk-jsoxford-20-minutes-into-the-future/)" in 2015.

{% include posts/figure.html src="2016-10/19/presenting.png" %}{:.massive}

The problem is that I didn't account for the direction I would be presenting in when I created the demos. All of my demos were created with the default orientation of cardinal North, but the stage I was presenting from was facing South.

On Android devices, device orientation measures this starting at North. On iOS devices, this is measured starting from the direction the phone is facing when the page is loaded.

So what can you do? Well it's not easy to simply fix the way device orientation (or the way the browser reports rotation on the y-axis while in a landscape orientation) is reported to our JavaScript.

We could create a calibration device to provide an offset delta, and then use that whenever we do anything with the device orientation data.

I'm using Three.js' DeviceOrientationControls.js plugin to provide my device orientation controlled camera. Helpfully, since Three.js `r77` DeviceOrientationControls has a property `alphaOffsetAngle`, and a method `updateAlphaOffsetAngle` that allow you to specify the offset to use:

```javascript
// angle is in radians
controls.updateAlphaOffsetAngle( angle );
```

Tomorrow I'll look at creating a device to allow the `alphaOffsetAngle` to be easily set by the user.
