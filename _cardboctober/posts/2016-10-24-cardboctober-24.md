---
title: "24: Basic Game Board"
has_hack: true
---

For today's hack we're going to start putting the teVRis game board together. We've already looked at positioning objects in a circle around the camera, but that doesn't solve the whole problem.

<!-- more -->

We need to position objects around just part of a circle so that we can see the whole game board at once. I'm using some magic numbers here, but this basically gives us the game board wrapped around the visible portion of a circle around the camera:

```javascript
var positions = [];
var circle = {
  width: 10,
  depth: 10,
  radius: 50
};
var step = (Math.PI * .8) / cols;
var angle = Math.PI * 1.133;
for (var c = 0; c < cols; c++) {
  positions.push([]);
  for (var r = 0; r < rows; r++) {
    var y = (blockSize + 1) * r;
    // put the calculated cell position in our array
    var position = new T.Vector3(
      (cols / circle.width) + (circle.radius * Math.cos(angle)),
      y,
      (cols / circle.depth) + (circle.radius * Math.sin(angle))
    );
    positions[c].push(position);
  }
  angle += step;
}
```

I only need to calculate the `positions` for each block once, I can then re-use them at no extra cost:

```javascript
var newPiece = function () {
  var piece = new T.Mesh(block.geometry.clone(), block.material.clone());
  var pos = positions[middleCol][0];

  piece.position.set(pos.x, pos.y, pos.z);
  piece.lookAt(new T.Vector3(camera.position.x, pos.y, camera.position.z));
  piece.material.opacity = 1;
  // eventually generate shapes here
  return piece;
};
```

Next we need to draw the player piece. We'll call a function at every `requestAnimationFrame` that changes the `Y`position of the piece at a given interval. In this case it's every `1000ms` or every `1s`:

```javascript
var dropInterval = 1000;
var lastTime = 0;
var dropCounter = 0;

// make the piece drop
var updatePosition = function (piece) {
  var y = blockSize + 1;
  var now = Date.now();
  var delta = now - lastTime;
  dropCounter += delta;

  if (dropCounter >= dropInterval) {
    if (piece.position.y > 0) {
      piece.position.y -= y;
    } else {
      piece.position.y = positions[middleCol][positions[middleCol].length - 1].y;
    }
    dropCounter = 0;
  }
  lastTime = now;
};
```

And that's it for today, tomorrow we'll look at creating some actual Tetrominoes.

{% include posts/figure.html src="2016-10/24/giphy.gif" %}{:.massive}
