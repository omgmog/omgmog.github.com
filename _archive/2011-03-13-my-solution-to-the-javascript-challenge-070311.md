---
comments_issue: 56
title: My solution to the JavaScript challenge 07/03/11
---

Okay so this solution is a bit later than I planned, but a busy working week and lack of motivation toward the end kind of got the better of me. Anyway, here's my solution to the challenge. I'm sure [Tomas](http://tmayr.com) will post his up soon.

<!-- more -->

Quick overview of the challenge:

> With just the JavaScript/the jQuery core file (no plugins), create functions > to process some paragraphs of Lorem Ipsum in the following ways
>
> 1. sort words by frequency of occurrence (bonus points for listing totals, > most frequent word, unique words, etc.)
> 2. sort words in alphabetical order
> 3. sort words by length of word (ascending/descending)
> 4. a function to return the text to its original order, and also reverse the > original order
> 5. Bonus: add some kind of effect during processing while re-arranging words


You can see the post with the challenge [here](/post/js-challenge-070311/)

Areas I completed:

> 1. sorting alphabetically (by words, not by words inside each paragraph)
> 2. sorting alphabetically in reverse (as above)
> 3. sorting by word length
> 4. sorting by word length in reverse
> 5. getting the top 5 words by frequency
> 6. listening all unique words
> 7. function to reset the text to original order
> 8. function to reverse all words

How I approached this:

I started this with some really basic functions to apply sorts on arrays, and rebuild arrays, but I came across some problems with copying my original array of the words &mdash; where setting a new variable for a copy of the array would just reference the original array, not copy it.

I decided then to complete each of the tasks by writing new [prototypes](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/prototype) for the array object, so I could make a new array using the data from the original array with transformations, something like:

```javascript
var newArray = oldArray.someAwesomePrototype();
```

This made it easy to have reusable functions, which are independent of the data in the array.

Some issues encountered and some neat observations:

This was the first JavaScript/jQuery challenge undertaken by Tomas and myself, and it was pretty challenging (even though it's just some array processing) &mdash; the challenging part I found was resisting sharing ideas and code snippets with Tomas. We've worked a lot in the past on things, and I think it's nicer to throw ideas back and forth between each other.

I found that with not knowing what the other person is doing, it motivated me to want to complete bits of the challenge better/faster.

An interesting point though, we both found that we were stuck on the same point, and decided to discuss our solutions. It came down to us being stuck in exactly the same way, and when we wrote solutions they were pretty similar.

Anyhow, the debrief is complete, on to my whole solution. The code is sort of spaghetti-like at the moment, but I might come back and clean it up later. You can see my solution here: 

[Solution to the JavaScript challenge 07/03/11](http://omgmog.net/challenge/070311/)
