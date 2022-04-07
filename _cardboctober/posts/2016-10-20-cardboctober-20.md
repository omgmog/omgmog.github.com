---
title: "20: Which way is North? Part 2"
---

In [yesterday's post](/post/cardboctober-19) I talked about the problem of using Cardinal North with device orientation, and how Three.js' Device Orientation Camera provides a utility function for setting the `alphaOffsetAngle`, today we're going to cover building a device to use this function.

<!-- more -->

We're going to create a device that let's you change the orientation offset for the camera, so we can move the scene-relative North. This isn't something that you're likely to need to use a lot, so it doesn't need to be accessible from within VR-mode.

{% include posts/figure.html src="2016-10/20/safe-areas.png" %}{:.massive}

You can see in the diagram above two "safe areas", these are unlikely to be visible while using Cardboard, so either are a good place to put the device. I'm going to use the bottom safe area.

The device should show the position of our "North" as well as the current rotation. I created a couple of images that will help with this:

{% include posts/figure.html src="2016-10/20/images.png" %}{:.massive}

Now to make them actually rotate. I'll create the following markup for the device and inject it with JavaScript:

```html
<button class="calibrate-orientation">
  <span class="offset"></span>
  <span class="actual"></span>
</button>
```

And the following styles for the device:

```css
.calibrate-orientation {
  outline: none;
  background: #fff;
  border-radius: 100%;
  border: 0;
  padding: 0;
  box-shadow: 0 0 80px 20px #000;
  box-sizing: border-box;
  position: absolute;
  left: 0; right: 0; bottom: 0;
  width: 50px; height: 50px;
  margin: auto auto 20px;
}
.calibrate-orientation span {
  display: block;
  width: 100%;
  height: 100%;
  position: absolute;
  left: 0; top: 0;
  background-size: contain;
}
.calibrate-orientation .offset {
  background-image: url(../js/compass_current.png);
}
.calibrate-orientation .actual {
  background-image: url(../js/compass_actual.png);
}
```

{% include posts/figure.html src="2016-10/20/rotation.gif" %}{:.massive}

We actually create/inject all of the markup and styles using JavaScript, but what you see there is the end result.

We only want to show this device on hardware that supports device orientation, which we can _mostly assume_ is any mobile device, so we have a return early on in our function so that they don't bother running the function:

```javascript
var createOrientationCalibrationControl = function (controls) {
  // If we're not on mobile, get out of here
  if (!core.isPocketDevice()) return;

  // ... Rest of function
};
```

We use `requestAnimationFrame` to update the CSS transform property of our images to show the rotation:

```javascript
var elClass = '.calibrate-orientation';
window.updateCompassControl = function () {
  var alpha = controls.deviceOrientation.alpha;
  var alpha_offset = controls.alphaOffsetAngle || 0;
  var alpha_actual = T.Math.degToRad(-alpha);
  if (alpha !== undefined) {
    var el = document.querySelectorAll(elClass+' .offset')[0];
    el.setAttribute(
      'style',
      'transform: rotate('+alpha_offset+'rad)'
    );

    var el = document.querySelectorAll(elClass+' .actual')[0];
    el.setAttribute(
      'style',
      'transform: rotate('+alpha_actual+'rad)'
    );
  }
  requestAnimationFrame(window.updateCompassControl);
};
window.updateCompassControl();
```

To do the actual job of updating the `alphaOffsetAngle`, we set an event listener on the button we've created:

```javascript
button.addEventListener('click', function (e) {
  var alpha = controls.deviceOrientation.alpha;
  var offset = T.Math.degToRad(-alpha);
  controls.updateAlphaOffsetAngle(offset);
});
```

As I've implemented this in my `core.js` (you can see the code here: [core.js#L84](https://github.com/cardboctober/max/blob/master/js/core.js#L84)) this will automatically be carried over to all of the Cardboctober hacks that I've built so far, and will be available to any future hacks.

I need to play with the device a bit more to make it work perfectly, but for now it's pretty functional.
