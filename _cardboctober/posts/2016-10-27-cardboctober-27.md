---
title: "27: Moving with gaze"
has_hack: true
---

Today's hack is more an aside while I'm focussing on _yet another_ Tevris rewrite.

<!-- more -->

I thought I'd play with an idea for controlling the left/right movement of the active piece based on where you're looking.

Now, knowing where you're looking in 3D space is both a hard thing to Google, and a hard thing to explain. So take this solution with a grain of salt:

```javascript
var getpos = function (obj) {
  camera.matrixWorldInverse.getInverse( camera.matrixWorld );
  var mat = new THREE.Matrix4().multiplyMatrices( camera.matrixWorldInverse, obj.matrixWorld );
  var pos = obj.position.clone().applyProjection(mat);
  return pos;
};
var getLooking = function () {
  var pos = getpos(board[0][Math.floor(cols/2)]);
  // MAGIC 💩
  if (pos.x - pos.z > 180) {
    return 'left';
  }
  if (pos.x - pos.z < 120) {
    return 'right';
  }
};
```

There's a lot going on there, and some MAGIC, and it's not going to scale, but it sort of works.


{% include posts/figure.html src="2016-10/27/giphy.gif" %}{:.massive}

I'm not completely happy with this, so you may have noticed the poop emoji (💩) all over the place. I'll _definitely_ throw this away with the re-write I'm working on, but it's nice to explore the idea.
