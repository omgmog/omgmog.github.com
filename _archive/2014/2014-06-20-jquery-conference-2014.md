---
comments_issue: 14
title: jQuery Conference 2014
---
Another year, another jQuery UK conference. I wrote previously about the jQuery UK conferences that I attended in [2012](/post/jquery-uk-conference-2012/) and [2013](/post/jquery-uk-2013---a-tale-of-beer-colourful-cakes-and-no-wifi/), now I've finally gotten around to writing up my notes from the 2014 conference.

<!-- more -->

### The Venue

We were back at the [King's Centre](http://www.kingscentre.co.uk/) in Osney Mead again this year. It's a great venue, perfectly located near to the Oxford Rail Station, and capable of catering to a conference as big as jQuery.

{% include posts/figure.html src="7frmBHu.png" %}{:.massive}

From the Rail Station to the venue, White October staff held signs to direct people, and this year the route featured orange J's painted along the path.

### The Theme

I'm not sure what the theme was this year, the site and all of the artwork was based around creating the 'J' from 'jQuery' using different materials: cake, ketchup, sand, mustard, LEGO &mdash; but that's about it. No heavy emphasis on a theme like last years Alice's Adventures in Wonderland, or Radiohead the year before.

{% include posts/figure.html src="pa1R39r.jpg" %}{:.massive.center}

Theme confusion aside, the T-shirt design featuring the aforementioned materials is very nice.

{% include posts/figure.html src="DFgydEr.png" %}{:.massive.center}

### Arrival

I wasn't too early to arrive at the conference this year (or perhaps there were people more keen than myself to be there early!). The White October staff have got the hang of this people-herding stuff, and I was quickly and clearly directed to collect my pass and delegate bag.


### Retro games

[Replay events](http://www.replayevents.com/) were here again, with a bunch of retro consoles and comfy seats for people to sit on. I took part in the Mario Kart 64 knock-outs, but after a bad choice in level ([Choco Mountain](http://www.mariowiki.com/Choco_Mountain)!) I didn't last very long.

### Loot

There plenty of stands in the main hall giving out stickers and other goodies. A run-down of some of the loot (from the delegate bag, and collected from stands):

- jQuery T-shirt
- Modern.IE moleskine-esque notebook
- CloudAnt T-shirt
- CloudAnt coffee beans
- Jetbrains WebStorm yo-yo
- Countless stickers (!)
- WordPress sunglasses
- jQuery mug (!)

Loot in hand I was appropriately placated until the conference started.

{% assign iframe_url = "https://www.youtube.com/embed/R4CVi4zfcGM" %}
{% include posts/figure.html type="iframe" %}

### John Wards - Hello!

John opened the conference again, and re-assured us that there were 4 ADSL lines, and 2 satellite lines. So hopefully Wifi wouldn't be an issue this year.

### Adam J. Sontag - The State of jQuery

{% assign iframe_url = "https://player.vimeo.com/video/97723665" %}
{% include posts/figure.html type="iframe" %}

Adam's talk started out a bit like Richard D. Worth's talk last year, covering the plans for jQuery.

Today, 80% of the top sites on the internet use jQuery. 18.2% of __all sites__ on the internet use jQuery. 12 of the top 20 most used JavaScript libraries are jQuery-related.

Since last year's conference there have been many releases on the `1.x`, `2.x`, `ui` and `mobile` branches. Rather than adding new features to jQuery core, the focus has been on:

#### Reducing size of the library

The core library has had a reduction of `494 bytes`. Removing ie6/7/8 support in the `2.x` branch shaved 12% off of the size of the library.

#### Increasing modularity

There are things that can't be removed from the exposed jQuery API (such as `.dblick()`), but thankfully you can remove them in your own custom builds if you don't need them. Since jQuery `1.11`/`2.1`, jQuery uses AMD to load dependencies.

#### Improving performance

Feature detects are now lazy, so they only happen when they need to, ensuring that jQuery doesn't cause unnecessary page reflows.

#### Ensuring jQuery plays nicely with other libraries

- jQuery team now own the `jquery` package on `nom`
- jQuery `2.x` branch now works in `node` and `browserify`
- jQuery team involves members of the Ember and Angular teams
- jQuery documentation is open source, so it can be contributed to by the community

### Jen Simmons - A Love Letter to HTML

{% assign iframe_url = "https://player.vimeo.com/video/97723667" %}
{% include posts/figure.html type="iframe" %}

Jen covered a history of HTML, starting with the conception of Hypertext in the 60s, all the way through to the HTML we know and love today. She highlighted the subtle differences between some of the original contending protocols for "the web", and the qualities of the World Wide Web that ultimately won and is what we use today. These qualities are:

- It's flexible
- There's no central authority
- You don't need permission to create a web page
- There's no central directory of all of the pages
- There is one-way linking
- It's universal
- It's designed to reduce barriers-to-entry
- It's simple
- It's forgiving
- It's declarative
- It's remarkable

### Paul Lewis - Building for the future

{% assign iframe_url = "https://player.vimeo.com/video/97723669" %}
{% include posts/figure.html type="iframe" %}

Paul covered some of the constraints that we have to deal with to make websites that will work well in the future, covering the multitude of devices and contexts in which our users will use our websites.

The four constraints of interest to us are:

- The network available to the device being used
- The GPU on the device being used
- The CPU on the device being used
- The size of the screen on the device being used

Today we think about a "cross-device web" as "computers, tablets and phones", but we're on the cusp of it becoming much more. Wearables, hybrid touch devices, smart cars and fridges!

Pauls's slides are available online here: [http://speakerdeck.com/paullewis/build-for-the-future/](http://speakerdeck.com/paullewis/build-for-the-future/)

### Lea Verou - The Chroma Zone: Engineering color on the web

{% assign iframe_url = "https://player.vimeo.com/video/97723672" %}
{% include posts/figure.html type="iframe" %}

Lea covered the technology behind rendering a single pixel on a screen, how subpixels work, the different kinds of subpixel display, and different methods of anti-aliasing.

Lea's slides are available online here: [http://leaverou.github.io/chroma-zone](http://leaverou.github.io/chroma-zone)

### Yehuda Katz - Building multi-screen web apps with Ember.js

{% assign iframe_url = "https://player.vimeo.com/video/97723671" %}
{% include posts/figure.html type="iframe" %}

Yehuda talked about the benefits of convention over configuration, and went in to a pretty intense session using [Ember.js](http://emberjs.com/) to demonstrate how simple it can be to create a multi-screen web app using the GitHub API and Ember.js

### Andrew Betts - Components and modules for front-end sanity at scale

{% assign iframe_url = "https://player.vimeo.com/video/97724404" %}
{% include posts/figure.html type="iframe" %}

Andrew talked about the steps that his team at the Financial Times online have taken to make all of their legacy sites more consistent using a modular approach to asset loading and a component-based interface.

### Divya Manian - Graphical effects you didn't know browsers could do

{% assign iframe_url = "https://player.vimeo.com/video/97724405" %}
{% include posts/figure.html type="iframe" %}

Divya showcased some cool new features coming to browsers, such as masking elements, blending modes and transforms.

### Andrew Nesbitt & Francis Gulotta - The Rise of JavaScript Hardware Hacking

{% assign iframe_url = "https://player.vimeo.com/video/97724406" %}
{% include posts/figure.html type="iframe" %}

Andrew and Francis demonstrated some awesome ways to bring hardware and APIs together to make cool things. The video speaks louder than words, so I'd recommend watching it through.


<sub>[Pictures](https://www.flickr.com/photos/16120271@N03/sets/72157644753482543) used with permission from [Pete Newnham](http://blarg.co.uk/) ([@wrakky on Twitter](http://twitter.com/wrakky)).</sub>
