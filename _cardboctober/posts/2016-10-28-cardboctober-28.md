---
title: "28: Planning Revisited"
redirect_from:
  - /post/cardboctober-28/
---

I thought it'd be weird to drop a hardware post in this week as I've not finished the Tevris game yet, so this week's post will continue the Tetris theme and then there will be a Cardboctober Week 4 round-up at the end.

<!-- more -->

I think Tevris is a very good example of a _beginner game development exercise_ for this reason as it provides a lot of 2-dimensional array manipulation, collision algorithms and very testable rules.

The one thing that constantly blocks me (_hoho!_) with building Tevris is the collision detection. Tetris is a game that has been around for a long time, and all of it's game logic is codified in various languages. The collision algorithm should be simple to drop in -- but with Tevris it hasn't worked out that way yet.

I keep hitting walls (_hoho!_.. alright I'll stop.) with off-by-one errors, and general weirdness. I think this is down to a lack fo structure/planning upfront in the build of the game, which is why I've written it from scratch a couple of times as I find a new challenge, and why I'm in the process of another complete re-write.

## Planning revisited

The tetris board is a 2-dimensional array that is 10 cells wide and 22 cells tall. Though it's 22 cells tall, we only actually use 20 of them as the playable area (with 2 used for buffering the top of a shape without being out of bounds).

{% include figure.html src="2016-10/28/board.png" %}{:.massive.center}

There are 7 different types of piece in a traditional tetris game: I, T, L, J, Z, S and O. Here is how each of them look in the default rotation:

{% include figure.html src="2016-10/28/pieces.png" %}{:.massive.center}

The marked square in the middle of each piece is the point that the piece will be rotated around.

{% include figure.html src="2016-10/28/piece-rotation.png" %}{:.massive.center}

When spawning, a random piece with a random rotation is placed at the top of the board. This piece is positioned so that the marked square is at the top/center of the board:

{% include figure.html src="2016-10/28/spawn.png" %}{:.massive.center}

The piece can be moved along the x-axis by the player. The piece will automatically drop 1 block at an interval along the y-axis, but can also be manually moved downwards on the y-axis.

If the piece gets to the left or right edge of the board, the piece should not be drawn beyond the edge of the board.

If the piece collides with a filled square on the board, it should be merged with the board.

If the piece reaches the bottom row of the board, it should be merged with the board.

{% include figure.html src="2016-10/28/piece-collide.png" %}{:.massive.center}

So now that I've got that written down somewhere, I can continue with my big re-write and hopefully have something working by the end of Cardboctober!

## Cardboctober Week 4 recap:

### Day 22
- [Putting it all together](https://blog.omgmog.net/post/cardboctober-22/) (Max)
- [Experiments in optimising three.js](https://medium.com/@peterjwest/experiments-in-optimising-three-js-9d934ccabf40) (Pete)

### Day 23
- [Planning Tetrominoes in VR](https://blog.omgmog.net/post/cardboctober-23/) (Max)
- [iOS North](https://cardboctober.github.io/pete/23/) (Pete)

### Day 24
- [Basic Game Board](https://blog.omgmog.net/post/cardboctober-24/) (Max)
- [Bullet time](https://cardboctober.github.io/pete/24/) (Pete)

### Day 25
- [Creating and Moving Pieces](https://blog.omgmog.net/post/cardboctober-25/) (Max)
- [Smart device pairing](https://cardboctober.github.io/pete/25/) (Pete)

### Day 26
- [Rotating Pieces](https://blog.omgmog.net/post/cardboctober-26/) (Max)
- [Laser battle](https://cardboctober.github.io/pete/26/) (Pete)

### Day 27
- [Moving with gaze 💩](https://blog.omgmog.net/post/cardboctober-27/) (Max)
- [Hairy ball](https://cardboctober.github.io/pete/27/) (Pete)

### Day 28
- This post (Max)
- [Beer](https://cardboctober.github.io/pete/28/) (Pete)
