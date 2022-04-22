---
title: "11: Webaudio Beat Sequencer"
has_hack: true
---

For today's hack I've decided to make a VR beat sequencer. Nothing says inclusive-fun like a VR experience that makes noise! So let's get on with that.

<!-- more -->

I actually made a 2d Beatmaker a month ago. You can play with it [here](https://blog.omgmog.net/beatmaker) and view the source [here](https://github.com/omgmog/beatmaker). So for today's hack I'm pretty much taking that an adding an extra dimension.

{% include posts/figure.html src="2016-10/11/giphy.gif" %}{:.massive}

I created the board by looping over a list of the sounds to create rows in the sequencer, and then created a cell in each row for each "tick". My sequencer has 16 ticks per sound.

To mark the cells as "active" I started with an `ongazelong` event from vreticle, but this had some interaction issues on mobile due to the left/right eye reticles not converging correctly, and the cells being too small to hit comfortably.

I threw that out and decided to switch to a combination of raycasting and using `addEventListener` to listen for click events. This works really nicely, and with Google Cardboard v2 and it's capacative switch it's really easy to use.

For the sound samples I'm using a _casette-processed_ set of TR-909 sequencer sound effects from [Bedroom Producers Blog](http://bedroomproducersblog.com/2014/04/24/roland-tr-909-samples/). There's a huge selection, but I've only included 11 of them to keep the vertical size of the sequencer usable.
