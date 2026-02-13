---
title: "Trying coffeescript"
tags: [javascript]
archived: true
archive: blog.omgmog.net
---

Recently decided to give [coffeescript](http://jashkenas.github.com/coffee-script/) a go, it's nice and syntactically similar to other languages such as [Python](http://www.python.org/).

From the coffeescript developers:

> **CoffeeScript is a little language that compiles into JavaScript.** Underneath all of those embarrassing braces and semicolons, JavaScript has always had a gorgeous object model at its heart. CoffeeScript is an attempt to expose the good parts of JavaScript in a simple way.

Here's my first test with it, first of all a [golfjs](http://golfjs.com) solution I wrote, using obfuscated (read: in as few bytes as possible) JavaScript:

```javascript
i=input,v=i.match(/[aeiou]/gi),y=i.match(/y/gi),
output=(v?v.length:0)+(y?y.length/2:0)
```

And here's the same code in coffeescript:

```coffeescript
v = /[AEIOU]{1}/gi
y = /Y{1}/gi
a = if input.match(vow) then input.match(vow).length else 0
b = if input.match(y) then input.match(y).length*0.5 else 0
output = a+b
```

And the JavaScript coffeescript compiles to:

```javascript
var a, b, output, v, y;
v = /[AEIOU]{1}/gi;
y = /Y{1}/gi;
a = input.match(vow) ? input.match(vow).length : 0;
b = input.match(y) ? input.match(y).length * 0.5 : 0;
output = a + b;
```
