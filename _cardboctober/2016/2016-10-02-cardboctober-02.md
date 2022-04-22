---
title: "02: Raycaster based look interaction"
has_hack: true
---

For today's Cardboctober hack I'm doing some basic look interaction.

As you look at each ghost in the circle surrounding you the ghost will cover their eyes.

<!-- more -->

{% include posts/figure.html src="2016-10/02/giphy.gif" %}{:.massive}

This is really basic, and uses Three's built-in `THREE.Raycaster`. You can imagine a raycaster as a laser beam shining from your eye to the point that you're looking at.

{% include posts/figure.html src="2016-10/02/raycasting.png" %}{:.massive}

In this hack I'm grabbing the first object that the raycaster hits and then changing the material.
