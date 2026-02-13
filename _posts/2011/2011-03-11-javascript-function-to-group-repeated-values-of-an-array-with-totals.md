---
title: Javascript function to group repeated values of an array with totals
comments_issue: 98
tags: [javascript]
archived: true
archived_comments:
- author: "Benjamin Fowl"
  date: June 27, 2014
  content: |
    Hi thought I'd post another solution. It's pure javascript and extends Array (not required if you don't want to)This is the fiddle if you'd like to play around. http://jsfiddle.net/spqr_pr...Array.prototype.groupItems = function() { var grouped = {}; for(var i = 0; i < this.length; i++){ grouped[this[i]] ? grouped[this[i]] += 1 : grouped[this[i]] = 1 } return grouped;}Thanks for your posts
---

Something that took a little while to pull of well while working on the [JS challenge this week](/post/js-challenge-070311/), thought I'd throw it up here as it has its uses practically for grouping like array values with totals:

<!-- more -->

```javascript
var testdata = ['a','a','a','b','b','c','c','c','c','d','d','d','e'];
var i=0, x, count, item;
while(i < testdata.length){
    count = 1;
    item = testdata[i];
    x = i+1;

    while(x < testdata.length && (x=testdata.indexOf(item,x))!=-1){
        count+=1;
        testdata.splice(x,1);
    }
    testdata[i] = new Array(testdata[i],count);
    ++i;
}
console.log(testdata);
```

This is outputting to the console log for the sake of testing it, but the kind of output you'd expect to see is a multidimensional array.

Should have the rest of my solution to the challenge up tomorrow, with a nice post explaining the tough time [Tomas](http://tmayr.com) and I have had fighting our urge to reveal code/brainstorm together.
