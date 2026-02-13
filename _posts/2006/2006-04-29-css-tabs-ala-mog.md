---
title: CSS Tabs, ala mog
tags:
- moglenstar
- css
- web
archive: moglenstar.net
archived_comments:
- author: z3rb
  date: May 10th, 2006
  content: You rock, this tutorial rocks.
- author: Tim
  date: May 19th, 2006
  content: Nice one max. Your markup is always squeaky clean!
---

So i was playing with some css ideas the other day, during a random spur of boredom (ok, well it wasn't that random, infact i could have probably avoided it on account of i knew i would be bored.. but regardless..)

i came up with some nice css tabs, using [dave shea's](http://www.alistapart.com/articles/sprites) css sprite slicing technique, and [douglas bowman's](http://www.alistapart.com/articles/slidingdoors/) sliding doors technique.

<!-- more -->

the end result of this little tutorial should look something like the following image, if i'm any good, and if you follow the tutorial correctly..

{% include posts/image-lost.html %}

first of all, let's whip up some markup..

```html
<div id="menubar">
	<ul>
		<li><a href="#"><span>main</span></a></li>
		<li><a href="#"><span>write</span></a></li>
		<li class="selected"><a href="#"><span>manage</span></a></li>
		<li><a href="#"><span>settings</span></a></li>
	</ul>
</div>
```

the context i've created this in, it was to be used as a main menu, at the top of a page.

now, how about those image sprites..

{% include posts/image-lost.html %}

now all we need is a bit of css magic to pull it together..

```css
#menubar {
	float: left;
	width: 700px;
	margin-top: 75px;
	font-size: 1.4em;
	line-height: normal;
	}
#menubar ul {
	list-style: none;
	}
#menubar ul li {
	float: left;
	margin-left: 5px;
	}
#menubar a {
	display: block;
	background: url("images/tab-right.png") right top no-repeat;
	text-decoration: none;
	color: #FFCDAA;
	}
#menubar a span {
	background: url("images/tab-left.png") left top no-repeat;
   padding:5px 15px 3px 15px;
	display: block;
	}
#menubar a:hover {
	background-position: right -25px;
	color: #FF9C12;
	}
#menubar a:hover span {
	background-position: left -25px;
	color: #FF9C12;
	}
#menubar li {
	}
#menubar li.selected {
	border-bottom: 1px solid #fff;
	}
#menubar .selected a {
	background-position: right -50px;
	color: #a9a9a9;
	}
#menubar .selected a span {
	background-position: left -50px;
	color: #a9a9a9;
	}
```

you can see the tabs in action here - ~~css tabs demo~~
