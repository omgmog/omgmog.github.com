---
title: "DevTerm Stuff"
comments_issue: 113
---

I helped crowdfund the [DevTerm from ClockworkPi](https://www.clockworkpi.com/devterm) back in November 2020 and it arrived in January 2022. Here's some of the hardware mods I've made to improve my DevTerm.

{% include figure.html src="devterm-stuff/devterm.png" %}{:.center}

<!-- more -->

## Trackball replacement

This replacement part was originally suggested [in this post](https://forum.clockworkpi.com/t/the-cheapest-keyboard-hardware-mod/7708) on the ClockworkPi forum. I ordered a couple from a seller on AliExpress and then waited a month for them to arrive.

While I waited, I also [flashed an improved keyboard firmware](https://forum.clockworkpi.com/t/ive-rewritten-devterm-keyboard-trackball-firmware/7671).

Installation of the trackball was a very simple process:

1. Remove the keyboard from your DevTerm
2. Remove the screws from the back plate of the keyboard
3. Remove the keyboard backplate
4. Take out the trackball package
5. Drop in the new trackball package
6. Re-assemble everything

{% include figure.html src="devterm-stuff/trackball-compare.jpg" %}{:.center}

{% include figure.html src="devterm-stuff/trackball-sensors.jpg" %}{:.center}

{% include figure.html src="devterm-stuff/trackball-installed.jpg" %}{:.center}

## Better access to microSD slot

The DevTerm does feature external access to the microSD slot, but it's spring loaded and positioned on the front bottom edge of the device. It's also notoriously easy to slide your microSD card between the main board and the case, requiring a full disassembly to get it out of the device again.

Inspired by what [I did with my GameShell](/post/gameshell-stuff/#external-access-to-microsd-slot) with an FPC extension cable, I've relocated the microSD slot  to the bottom/left of the outside of the case.

This require a couple of folds, some double sided tape and some regular tape to hold everything in place. It's not quite perfect yet as it's not likely to be very knock-proof, but it feels like a much nicer location for the SD card.

{% include figure.html src="devterm-stuff/bottom-of-shell.jpg" %}{:.center}
{% include figure.html src="devterm-stuff/microsd-closeup.jpg" %}{:.center}

## Copper cooler/heatsink

I swapped out the icnluded aluminum heatsink for one made of copper. I'm not happy with the dimensions of this, or how it's mounted, but I think it provides an improvmement to the passive cooling of the CPU module. A further improvement would be to [3D print a shroud to direct the airflow of the fan better](https://forum.clockworkpi.com/t/fan-shroud-for-devterm/7598).

{% include figure.html src="devterm-stuff/heatsink.jpg" %}{:.center}

## Rubber feet

I've stuck a couple of those little rubber dome feet in various locations on the bottom of the shell. This just improves the grip of the DevTerm on most surfaces to stop it sliding around as you type.

{% include figure.html src="devterm-stuff/feet-closeup.jpg" %}{:.center}
