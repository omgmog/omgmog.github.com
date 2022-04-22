---
title: "03: Even better gazed based look interaction"
has_hack: true
---

Improving on yesterday's [Raycaster based look interaction](/post/cardboctober-02), I've improved the raycasting experience.

I'm using a library called [vreticle.js](https://github.com/neuman/vreticle), though I've [tweaked it a bit](https://github.com/omgmog/vreticle).

<!-- more -->

{% include posts/figure.html src="2016-10/03/giphy.gif" %}{:.massive}

Now when interacting with each ghost, you have the following gaze-based events:

### `ongazever`

This is used for a short interaction, the equivelant of an `onmouseover` with traditional mouse-based interaction.

In the demo I'm using the `ongazeover` event to trigger the first change where the ghost gets bigger.

You could use this event for adding hover states to elements, to indicate that they can be interacted with, without triggering an event every time the user looks at anything.

### `ongazelong`

This is used as your traditional action event, just like `onclick` with traditional mouse-based interaction. This is where you would fire your main event.

In the demo I'm using `ongazelong` to trigger the change from a scary ghost, to a ghost covering his eyes.

The `ongazelong` event is fired after a short timeout. In the original `vreticle.js` this was 3 seconds, but in my version you can specify this value. I've gone for 0.5 seconds.

### `ongazeout`

This is for ending the interaction. The equivelant of an `onmouseout` with traditional mouse-based interaction.

In the demo I' using `ongazeout` to reset the ghosts to their original state.


## Tweening states

Besides the improved gaze events, I'm using [Tween.js](https://github.com/tweenjs/tween.js/) to make the transitions between states smoother.

Tween lets you easily transition from one value to another. This is completely agnostic of the technology it's applied to, so it doesn't matter that I'm using Tween.js with Three.js.

To use Tween.js with Three.js, first load the library in your page:

```html
<script src="../js/threejs/Tween.js"></script>
```

Then set up any tweens you need. In this case I want to tween the `scale` property of some `Object3D`'s:

```javascript
var scale = {
    x: .5,
    y: .5,
    z: .5
};
var new_scale = {
    x: 1.0,
    y: 1.0,
    z: 1.0
};
var panel_tween = new TWEEN.Tween(scale).to(new_scale, 500);
panel_tween.onUpdate(function() {
    panels[i].scale.set(scale.x, scale.y, scale.z);
});
panel_tween.start();
```

And then ensure that Tween.js updates on every `requestAnimationFrame` call:

```javascript
var animateRenderer = function() {
    // ...
    TWEEN.update();
};
animateRenderer();
```
