---
title: "26: Rotating Pieces"
has_hack: true
---

For today's Cardboctober we're still working with Tetris. The task today is to make the pieces rotate.

<!-- more -->

There are a couple of ways you can handle the rotation of Tetrominoes, for example you can calculate the rotation using nested for loops:

```javascript
var arr = [
  [0,0,1],
  [1,1,1],
];

for(var i = 0; i < arr[0].length; i++){
  for(var j = 0; j < arr.length; j++){
    newArray[i][j] = arr[j][i];
  }
}

// newArray:
//  [1,0]
//  [1,0]
//  [1,1]

```

The other approach would just be to pre-calculate the rotations and store them as an array:

```javascript
var shapes = [
    {
      name: 'L',
      color: 0xf0a000,
      layout: [
        [
          [1, 0],
          [1, 0],
          [1, 1],
        ],
        [
          [1, 1, 1],
          [1, 0, 0],
        ],
        [
          [1, 1],
          [0, 1],
          [0, 1],
        ],
        [
          [0, 0, 1],
          [1, 1, 1],
        ]
      ]
    },
    //... and so on
];
```

So that's out of the way, we define all of the shape rotations for all of our shapes, and then we have a couple of choices for addressing them...

We could directly refer to `shape[shapeIndex].layout[layoutIndex]`, but we would need to maintain/update a value for `layoutIndex`, or we could do something like the following to ensure that the layout in the first slot (`0`) of the layout array is the one we're using:

```javascript
var rotatePiece = function (shape) {
    shape.layout.push(shape.layout.shift());
  };
```

This takes the first array item from `shape.layout`, cuts it off of the front of the array and finally sticks it at the end of the array.

The last thing is binding this to a key, so we just update our key event listener that we used for moving left/right and add another case to call `rotatePiece`:

```javascript
  //...
  case 38: // up key
    rotatePiece(shape);
  break;
  //...
```

{% include posts/figure.html src="2016-10/26/giphy.gif" %}{:.massive}

So that's it for piece rotation. I feel like I might be painting myself in to a corner more and more with each day of this, so we'll see what happens tomorrow!
