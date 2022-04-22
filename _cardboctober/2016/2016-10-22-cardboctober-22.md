---
title: "22: Putting it all together"
---

We're starting the final (full) week of Cardboctober now, so I thought I'd do a week-long project to pull together some of the ideas from Cardboctober.

<!-- more -->

I'm going to be making a Tetromino game in VR. Each day this week I'll cover an aspect of building the game, and then hopefully at the end of the week we'll have a full game to play.

{% include posts/figure.html src="2016-10/22/tetrominoes.png" %}{:.massive}

I've built Tetromino games before in some capacity -- I spent some time a couple of months ago building one using Python. Here are some great resources for working out how the game works:

- [The Mechanics of Nintendo Tetris](http://meatfighter.com/nintendotetrisai/?a=b#The_Mechanics_of_Nintendo_Tetris)
- [Tetris Wikia: Scoring](http://tetris.wikia.com/wiki/Scoring)
- [StackOverflow: Tetris Piece Rotation Algorithm](http://stackoverflow.com/questions/233850/tetris-piece-rotation-algorithm)
- [Tetris game logic for beginners](http://javilop.com/gamedev/tetris-tutorial-in-c-platform-independent-focused-in-game-logic-for-beginners/)


I'm going to be using the following libraries that we've utilised throughout Cardboctober so far:

- Three.js for all of the 3D stuff
- StereoEffect.js and DeviceOrientationControls.js for VR
- VReticle for reticle control
- Howler.js for audio

If you want to catch up so that you can follow along this week, check out the following posts:

- [01: Basic VR](/post/cardboctober-01)
- [03: Even better gazed based look interaction](/post/cardboctober-03)
- [04: Skyboxes and generating meshes](/post/cardboctober-04)
- [06: VR Pairs Game](/post/cardboctober-06)
- [08: Playing sounds](/post/cardboctober-08)
- [11: Webaudio Beat Sequencer](/post/cardboctober-11)
- [12: AAAAH! Zombies](/post/cardboctober-12)
- [13: AAAAH! More Zombies](/post/cardboctober-13)

I'll be using my [core.js](https://github.com/cardboctober/max/blob/master/js/core.js) library as with the rest of my hacks this month to simplify some of the work, so it's probably worth familiarising yourself with the utilities in there.
