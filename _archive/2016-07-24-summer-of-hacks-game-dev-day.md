---
title: 'Summer of Hacks: Game Dev Day'
comments_issue: 46
---

As part of the JS Oxford-organised [Summer of Hacks](http://summerofhacks.io), I co-organised the "Game Dev Day" hack day in Oxford. This is the second time I've held an event during the Summer of Hacks (the previous event being [SusHack #3](https://sushack.github.io/) last year!).

<!-- more -->

The hack day didn't have any specific theme, but Pete and I were encouraging people to use either [Phaser.js](http://phaser.io/) for creating 2D games, or [A-Frame](https://aframe.io/) for easily working with Three.js and making VR games.

{% include figure.html src="gdd/gdd.png" %}{:.massive.center}

## The gamedevday.club website

I whipped up the [gamedevday.club](http://gamedevday.club) site using A-Frame.

I hadn't considered this initially, but the website proved to be a nice piece of learning material, as it includes:

- entity grouping
- animation
- event-based animation triggering
- the use of a templating language (jade/pug) to generate A-Frame markup
- using a taskrunner to build/deploy

You can view the source for the site on Github here: [omgmog/gamedevday.club](https://github.com/omgmog/gamedevday.club/tree/master/src)

## Introduction to the tech

People of all skill levels attended the hack day, so I created some simple "getting started" guides to introduce people to the ease of using A-Frame.

I used [Deckset](http://decksetapp.com) to create a set of slides as a quick introduction to A-Frame. You can find a PDF of the slides here: [Intro to A-Frame](https://github.com/omgmog/gdd-2016/blob/master/Intro%20to%20A-Frame.pdf)

I also distilled some of the key concepts of A-Frame down in to this micro-site: [https://blog.omgmog.net/gdd-aframe-guide/](https://blog.omgmog.net/gdd-aframe-guide/). You can find the source for that site [here](https://github.com/omgmog/gdd-aframe-guide).

{% include figure.html src="gdd/IMG_20160723_111304.jpg" %}{:.massive.center}

These are some of the projects that were created during Game Dev Day:

- [adam-thomas/gdd-spore](https://github.com/adam-thomas/gdd-spore) - The beginnings of a Spore-like planet eating simulator.
- [gfwilliams/PainRun](https://github.com/gfwilliams/PainRun) - A bad (but ad-free!) copy of Death Run 3D... and in VR!
- [edent/aframedemo](https://github.com/edent/aframedemo/tree/gh-pages) - A quick hackday project to make an immersive VR art gallery.
- [adjl/CryingAngels](https://github.com/adjl/CryingAngels) - The idea is to have the Weeping Crying Angels pursue you in a maze; they stop when you look at them. This repo focuses on the implementation of the latter mechanic.
- [lpmi-13/privateRepository](https://github.com/lpmi-13/privateRepository) - Word breakout, where the words change to their plural form

Overall the day was a success, and more importantly great fun. I've collated a bunch of information about the day in the following repository: [omgmog/gdd-2016](https://github.com/omgmog/gdd-2016).

