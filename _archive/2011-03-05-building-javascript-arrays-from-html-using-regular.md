---
comments_issue: 18
title: Building JavaScript arrays from HTML using regular expressions
---

Bit of idea ping-pong with [Tomas](http://tmayr.com) this evening, to provide a solution to something he is working on. He had some text in a table cell that needed to be split and put into an array, separating each line into two parts.

<!-- more -->

This is the snippet we came up with, to build a flat array

```javascript
$(function() {
    var array = $("p.src").html()
        .split(/([0-9]{1})\s([A-Za-z\s]+\s*[0-9°º]*)/);
    var position = 0;

    while (position != -1) {
        array.splice(position, 1);
        position = array.indexOf('<br>');
    }

    $.each(array, function(index, value) {
        $("#array").append(index + " => " + value + "<br />");
    });
});
```

Nice concise bit of Javascript, after iterating through a bunch of (over-complicated array rebuilding on my part) versions.. :D
