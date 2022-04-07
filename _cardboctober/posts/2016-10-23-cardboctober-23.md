---
title: "23: Planning Tetrominoes in VR"
has_hack: true
---

I outlined the plan for the week yesterday: To make a tetromino game. So here's how we're going to do that.

<!-- more -->

I've decided to call this "_teVRis_", because who doesn't like a word/acronym mashup?

First things first we need to think about how we can transition a game mechanic from two dimensions to three.

{% include posts/figure.html src="2016-10/23/tetris-vs-tevris.png" %}{:.massive}

My first thought is to project the game board around the player in a circle. Positioning things on a circle is quite straight-forward with a bit of maths and two axis (x and z):

```javascript
  // Position a bunch of blocks around the camera
  var block = core.build(
    'BoxGeometry', [5,5,5],
    'MeshBasicMaterial', [{color:0xff0000}]
  );
  var numBlocks = 20;
  var circle = {
    width: 10,
    depth: 10,
    radius: 25
  };
  var step = (2 * Math.PI) / numBlocks;
  var angle = 0;
  for (var i = 0; i < numBlocks; i++) {
    var _block = new T.Mesh(
      block.geometry.clone(),
      block.material.clone()
    );

    _block.position.x =
      (circle.width / numBlocks) +
      (circle.radius * Math.cos(angle));
    _block.position.z =
      (circle.depth / numBlocks) +
      (circle.radius * Math.sin(angle));

    scene.add(_block);

    angle += step;
  }
```

You can see the output of this in [Cardboctober 04: Skyboxes and generating meshes](/post/cardboctober-04/) - I even did some preleminary Tetromino generation. So we've got the starting point for our game then, we just need to add _all of the game logic_.

Tomorrow we'll look at generating the Tetromino shapes and putting them in to this game board.
