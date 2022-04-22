---
title: "25: Creating and Moving Pieces"
has_hack: true
---

Today we're going to be looking at creating Tetromino pieces and moving them around the board.

<!-- more -->

I actually had to throw away all of yesterday's work today because my initial plan for how pieces would exist in the scene was completely wrong.

I was planning for a piece to be it's own object, separate from the board. This would have caused countless issues:

- how would I determine if a piece went outside of the board area?
- how would I determine if a piece intersected a filled area
- how would I curve a piece with the board?
- how would I partially remove a piece if I completed a line?

So I've gone back to the drawing board. Now, instead of the board being a stationary stateless bohemoth, the board _is everything_ and the state of each block in the board determines where the player "piece" is being rendered.

Confused? To simplify it a bit: To draw a piece at a position in the board, I'm simply changing the state of the blocks where the piece is positioned.

You can view the source for today's hack here: [25/demo.js](https://github.com/cardboctober/max/blob/master/25/demo.js)

Anyway, I wrapped my head around that eventually (after re-writing a couple of times!) and now we've got a board, and (using your keyboard on a PC) you can move the pieces left/right. They don't do much more than that right now, but this was a long evening of work.

```javascript
document.addEventListener('keydown', function (e) {
  switch (e.keyCode) {
    case 37:
      updateXPos(shape, -1);
    break;
    case 39:
      updateXPos(shape, 1);
    break;
  }
});
```

For the sake of simplifying things today, I've gone back to a flat game board. I'll re-introduce the curve tomorrow!

{% include posts/figure.html src="2016-10/25/giphy.gif" %}{:.massive}
