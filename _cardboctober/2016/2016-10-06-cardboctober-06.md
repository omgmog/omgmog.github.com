---
title: "06: VR Pairs Game"
has_hack: true
---

Todays hack is intended more as an activity to pull together various bits from the first week of Cardboctober and make a game. So here we go, it's a "pairs" game.

<!-- more -->

{% include posts/figure.html src="2016-10/06/giphy1.gif" %}{:.massive}

The keen-eyed amongst you would have noticed that it's filled with the face of Ben Foxall. For that we can thank Marcus Noble for his [library of Ben faces](https://github.com/AverageMarcus/BensSholder). Thanks Marcus.

On with the hack!

## The game logic

The game logic for a game of pairs is quite straight forward:

- The player is presented with a number of face-down card pairs
- The player turns over two cards until they find a pair
- The matched pairs are removed from the game
- When all of the pairs are matched the game finishes

## Generating a set of random image pairs

So the first thing to do then is generate a set of random image pairs. As I mentioned I've got a copious collection of pictures of Ben, so I started by sticking the filenames of these in to an array, along with a unique id for each:

```javascript
var bens = [
  {
    "id": "1",
    "img":"544073_10100714296067361_1364950741_n.jpg"
  },
  {
    "id": "2",
    "img":"552497_10100670131839199_1410185620_n.jpg"
  }
  // And so on...
];
```

I've got 44 pictures in the `bens` array, but I don't need all of them for one game. Let's say I need 16 cards for a 4x4 grid, that's 8 pairs, so I only need 8 unique random images.

Here's my function to get a number of random items from an array:

```javascript
var pickCardSet = function (arr, count) {
  var shuffled = arr.slice(0),
  i = arr.length,
  min = i - count,
  temp,
  index;

  while (i-- > min) {
    index = Math.floor((i + 1) * Math.random());
    temp = shuffled[index];
    shuffled[index] = shuffled[i];
    shuffled[i] = temp;
  }
  return shuffled.slice(min);
};
```

So we start with a collection of Bens...

{% include posts/figure.html src="2016-10/06/bens1.png" %}{:.massive}

Then we use `pickCardSet()` to get 8 random Bens:

```javascript
var benCount = 16;
var randomBens = pickCardSet(bens, benCount / 2); // 16/2 = 8
```

{% include posts/figure.html src="2016-10/06/bens2.png" %}{:.massive}

{% include posts/figure.html src="2016-10/06/bens3.png" %}{:.massive}

Then duplicate the 8 Bens to make 8 pairs (16 Bens!):

```javascript
var clonedBens = randomBens.slice(0);
randomBens = randomBens.concat(clonedBens);
```

{% include posts/figure.html src="2016-10/06/bens4.png" %}{:.massive}

And then lastly, use the `pickCardSet()` function again to shuffle the Bens:

```javascript
randomBens = pickCardSet(randomBens, benCount);
```

## Creating the play area

Once we've got the array of random Ben pairs, generating the play area is just as simple as looping through the array and creating a textured `BoxGeometry` for each Ben. You can read more about this sort of thing in my "[Skyboxes and generating meshes](/post/cardboctober-04)" post.


{% include posts/figure.html src="2016-10/06/bens5.png" %}{:.massive}

To lay 16 Bens out in a 4x4 grid automatically, a simple modulo operation is used to start a new line every 4 Bens:

```javascript
var cardSize = 24;
var spacing = cardSize * 1.1;
var cX = 0;
var cY = 0;
randomBens.forEach(function (ben, i) {
  // Code to generate benMesh's

  // Position the Ben's in rows
  cX++;
  if (i % 4 === 0) {
      cY++;
      cX = -1;
  }
  benMesh.position.x = spacing * cX;
  benMesh.position.y = spacing * cY;
});
```

## Setting up the interaction

Now that we've got the play area, it's a simple matter of triggering the main game logic when the user gazes at a Ben (lovingly) long enough. For this we're using `vreticle.js` just like in "[Even better gazed based look interaction](/post/cardboctober-03)".

We keep a counter for the number of Bens looked at, and have some logic to compare the first to the second and see if they have a matching `id`. Based on this, we either play a "correct.mp3" or "wrong.mp3" using Howler, and then either remove the correctly matched pair or flip the cards back over.

Once you've matched all the pairs, if you can bare to look at Bens face for much longer, the play area resets with a new random selection of Bens and the game starts over again.

## Thoughts on building this game

So I threw this together in an hour or two before work and during my lunch break. I didn't have a Google Cardboard at hand for testing, so I winged it with the scales of things.

When I got back from work this evening I did some real testing on a Google Cardboard, and then did some user testing on my wife. Her feedback was very valuable:

> The cards at the top of the screen are really far away, it's like I'm looking at a tall building

So the scale was clearly wrong -- when creating Google Cardboard experiences using WebGL we're already limited in the resolution, so having something feel like it's 20 metres or more away from you can make it very hard to see what you're looking at.

I tweaked the size of the cards, and adjusted the spacing so that the top row didn't seem so far away.

I also added in the "Start" button at the start of the game, because I found that in the initial play test it was easy to accidentally start triggering the card flips while orienting the Google Cardboard.

{% include posts/figure.html src="2016-10/06/giphy.gif" %}{:.massive}
