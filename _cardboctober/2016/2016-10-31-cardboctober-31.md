---
title: "31: Something in the Shadows"
has_hack: true
---

Today is the last day of Cardboctober! And less surprisingly, it's also Halloween 🎃 - For today's hack I've made something spooky. If you don't like spiders, you should look away now.

<!-- more -->

{% include posts/figure.html src="2016-10/31/giphy.gif" %}{:.massive}

The spider is simply made of some `SphereGeometry` and `CylinderGeometry` meshes, that have been scaled/rotated:

{% include posts/figure.html src="2016-10/31/spider.png" %}{:.massive}

To make the fog effect, I'm using Three's `THREE.Fog()`:

```
scene.fog = new THREE.Fog(0x111111, 0.015, 110);
```

And then I've got some simple animations to wiggle the legs/abdomen of the spider, and make him walk around the camera at a fixed radius.
