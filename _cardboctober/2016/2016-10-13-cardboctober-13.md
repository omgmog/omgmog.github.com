---
title: "13: AAAAH! More Zombies"
has_hack: true
---

For today's hack I'm revisiting [yesterday's zombie game](/post/cardboctober-12) again. With a full re-write to un-bodge the implementation.

<!-- more -->

{% include posts/figure.html src="2016-10/13/giphy.gif" %}{:.massive}

There are a couple of things I've changed in the re-write:

- Zombies get faster to you the closer you are to them
- Health/death added!
- Zombies have full bodies now

And a couple of things that didn't make it in to the re-write:

- Can't kill the zombies with your death stare anymore
- Game doesn't restart automatically

This time I'm using a separate 2D layer (some HTML!) outside of the renderer for the red damage overlay and the "You are dead" message.

I think this hack needs a couple more hours of attention before it's really fun, but it's getting there.
