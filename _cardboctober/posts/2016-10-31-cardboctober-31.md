---
title: "31: Something in the Shadows"
redirect_from:
  - /post/cardboctober-31/
has_hack: true
---

Today is the last day of Cardboctober! And less surprisingly, it's also Halloween 🎃 - For today's hack I've made something spooky. If you don't like spiders, you should look away now.

<!-- more -->

{:.center}
![]({{ site.baseurl }}/images/2016-10/31/giphy.gif)

The spider is simply made of some `SphereGeometry` and `CylinderGeometry` meshes, that have been scaled/rotated:

{:.center}
![]({{ site.baseurl }}/images/2016-10/31/spider.png)

To make the fog effect, I'm using Three's `THREE.Fog()`:

```
scene.fog = new THREE.Fog(0x111111, 0.015, 110);
```

And then I've got some simple animations to wiggle the legs/abdomen of the spider, and make him walk around the camera at a fixed radius.
