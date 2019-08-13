---
title: "07: Cardboard hardware (cardware?)"
redirect_from:
  - /post/cardboctober-07/
---

Today's hack (and each Friday for the rest of October) is going to be hardware rather than software themed. If you get all the way to the end of the post I'll even throw in a recap of the week so far. _This is totally not a cop-out._

<!-- more -->

## Google Cardboard choices

I've been playing with Google Cardboard for over a year now, and in that time I've collected a nice selection of Google Cardboard headsets:

{% include figure.html src="2016-10/07/headsets.jpg" %}{:.massive.center}

As you can see they come in all shapes and sizes, with prices ranging from less than £1 all the way through to £20.

The "VR Box" (furthest to the right) is actually very comfortable, and it came with a bluetooth remote. You can find all of these on Amazon, Gearbest, or eBay.

## Improving a basic Google Cardboard

The Google Cardboard is very basic. Two lenses and space to hold most 5" phones. If you're using a v1 you've got a magnetic switch, on a v2 a capacitive switch. Here are a bunch of simple "hacks" you can do to improve the basic Google Cardboard.

### Grease- and sweat-proofing

As Google Cardboard is made of... Cardboard -- it has the unsightly habit of absorbing sweat when placed against your forehead. A couple of strips of tape across the space between the lenses should be enough to stop this happening.

{% include figure.html src="2016-10/07/tape.jpg" %}{:.massive.center}

### Touch screen access for v1 Cardboard

If you're using a v1 Google Cardboard with anything but a Nexus 5 you'll probably find that the magnet-based switch doesn't work. Also if you're using Google Cardboard for web-based VR the magnet switch won't work.

The v2 Google Cardboard did away with the magnet switch in favour of a capacitive switch, which does work with web-based VR.

To get a similar experience with the v1 Google Cardboard, you can simply cut a hole in the bottom side of the Cardboard so that you can fit a finger through to touch the screen.

### Making your Cardboard stronger

Cardboard is great, but it doesn't keep it's rigidity for very long. You can strengthen the Google Cardboard by covering the whole headset with tape. I used a strong "duct tape".

### Humanising the Google Cardboard

This one's more of a LIFE HACK. Adding Googley eyes to anything can make it better.

{% include figure.html src="2016-10/07/eyes.jpg" %}{:.massive.center}

## Recap of Cardboctober Week 1

The first week of Cardboctober has been great. Ben, Pete and I have submitted something every day. I imagined I would find it hard to maintain the momento after day 2, but it hasn't been too bad.

I'm finding that VR thoughts and discussions are taking over every waking moment of my days, but that's not necessarily a bad thing.

This week we've seen the following:

### Day 01
- [Basic VR](https://cardboctober.github.io/max/01/) (Max)
- [Cube](https://cardboctober.github.io/ben/01/) (Ben)
- [Gears](https://cardboctober.github.io/pete/01/) (Pete)

### Day 02
- [Raycaster based look interaction](https://cardboctober.github.io/max/02/) (Max)
- [Moving grid thing](https://cardboctober.github.io/ben/02/) (Ben)
- [Earthrise](https://cardboctober.github.io/pete/02/) (Pete)
- [Put the kettle on](https://cardboctober.github.io/binhums/2016-10-02/) (Ben H)

### Day 03
- [Even better gazed based look interaction](https://cardboctober.github.io/max/03/) (Max)
- [Ribbon](https://cardboctober.github.io/ben/03/) (Ben)
- [Bounce](https://cardboctober.github.io/pete/03/) (Pete)

### Day 04
- [Skyboxes and generating meshes](https://cardboctober.github.io/max/04/) (Max)
- [Grid](https://cardboctober.github.io/ben/04/) (Ben)
- [Moonwalk](https://cardboctober.github.io/pete/04/) (Pete)

### Day 05
- [Loading external models](https://cardboctober.github.io/max/05/) (Max)
- [Cubes](https://cardboctober.github.io/ben/05/) (Ben)
- [Deep impact](https://cardboctober.github.io/pete/05/) (Pete)

### Day 06
- [VR Pairs Game](https://cardboctober.github.io/max/06/) (Max)
- [Drifting Mesh](https://cardboctober.github.io/ben/06/) (Ben)
- [Archery practice](https://cardboctober.github.io/pete/06/) (Pete)

### Day 07
- This post (Max)
- [Space & Time Mesh](https://cardboctober.github.io/ben/07/) (Ben)
- [Orbitals](https://cardboctober.github.io/pete/07/) (Pete)

First of all I want to say this is a huge amount of content creation (let alone the added fact that I've been doing a technical write-up each day too!). It has been really interesting to see the different ways that Ben, Pete and I are approaching "quick VR hacks" too.

Ben's taking the approach of writing a stereographic canvas renderer with abstract applications. His [repository](https://github.com/cardboctober/ben) has seen 58 commits over the week so far.

Pete has been focussed on physics and creating complete experiences each time. His [repository](https://github.com/cardboctober/pete) has seen 20 commits over the week so far.

I've been structuring my hacks as a counterpart to a larger learning exercise, so while each day you're just being drip-fed some aspects of a VR game, at the end of it all you actually have the ability to understand what goes in to it. My [repository](https://github.com/cardboctober/max) has seen 24 commits over the week so far.

{% include figure.html src="2016-10/07/spreadsheet.png" %}{:.massive.center}

I've already got the next couple of weeks planned out. Week 2 is going to be focussed on using various Web APIs within VR to add to the experience.
