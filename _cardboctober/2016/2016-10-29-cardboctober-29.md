---
title: "29: Blocks out of the pram"
has_hack: true
---

Bit of a lame one for today. I feel like I've not been making much progress with the Tetris rewrite, and tackling _collision detection_ with unexpected results is getting quite annoying, so I think I might just leave teVRis where it is for now.

<!-- more -->

Part of the problem of wrapping my head around a 2D game projected to 3D for VR has been the larger scale planning. If you're just working with manipulating the contents and state of a 2D array it's quite straight forward, and following the structure/logic in a number of approaches to writing Tetris has been successful in 2D.

In my 3D scene, each block of the board is represented with a cube mesh in the scene. Each of these blocks holds a state that is updated on each tick of the game:


```javascript
var blocks = [];
for (var y = 0; y < rows - 1; y++) {
  blocks[y] = [];
  for (var x = 0; x < cols - 1; x++) {
    var block = core.build(
      'BoxGeometry', [1,1,1],
      'MeshBasicMaterial', [{
        color: 0xffffff,
        transparent: true,
        opacity: 1
      }]
    );
    block.state = states.FREE;
    block.x = x;
    block.y = y;

    // Add the block to our 'blocks' array
    blocks[y].push(block);
    // And to the scene to render
    scene.add(block);
  }
}
```

This works great, I even got as far as applying different colors, making it controllable (with keyboard or gaze) and making the pieces rotate.

When I got to the point of merging colliding blocks (so they become part of the board) things started to get super weird, and I found myself up against a number of "off by one" errors, pieces rendering in the wrong order, and other weirdness. Enough that after looking at these errors for most of the day today, I'm really fed up with this.

So I'll shelf it for now, and do something else for today...

{% include posts/figure.html src="2016-10/29/giphy.gif" %}{:.massive}

And I suppose that raises a good point about what I'm doing for Cardboctober. This is meant to be a month of fun simple hacks, not overplanned complex long-running projects. I can do those any other time of the year.
