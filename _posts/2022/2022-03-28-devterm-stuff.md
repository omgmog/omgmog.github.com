---
title: "DevTerm Stuff"
comments_issue: 113
tags: [cpi]
syndication:
  - https://indieweb.social/@omgmog/108209353554883449
---

I helped crowdfund the [DevTerm from ClockworkPi](https://www.clockworkpi.com/devterm) back in November 2020 and it arrived in January 2022. It's a nice device, but it's not perfect. Here's some of the mods I've made to improve my DevTerm.

{% include posts/figure.html src="devterm-stuff/devterm.png" %}{:.center}

<!-- more -->

## Trackball replacement

This replacement trackball was originally suggested [in this post on the ClockworkPi forum](https://forum.clockworkpi.com/t/the-cheapest-keyboard-hardware-mod/7708). I ordered a couple from a seller on AliExpress and then waited a month for them to arrive.

While I waited, I [flashed a custom keyboard firmware](https://forum.clockworkpi.com/t/ive-rewritten-devterm-keyboard-trackball-firmware/7671) that improves the trackball sensitivity.

Installation of the trackball was a very simple process:

1. Remove the keyboard from your DevTerm
2. Remove the screws from the back plate of the keyboard
3. Remove the keyboard backplate
4. Take out the trackball package
5. Drop in the new trackball package
6. Re-assemble everything

{% include posts/figure.html src="devterm-stuff/trackball-compare.jpg" %}{:.center}

{% include posts/figure.html src="devterm-stuff/trackball-sensors.jpg" %}{:.center}

{% include posts/figure.html src="devterm-stuff/trackball-installed.jpg" %}{:.center}

## Better access to Micro SD slot

The DevTerm features external access to the Micro SD slot on the front bottom edge of the device. It's notoriously easy to slide your Micro SD card between the main board and the case, requiring a full disassembly to get it out of the device again.

Inspired by what [I did with my GameShell](/post/gameshell-stuff/#external-access-to-micro-sd-slot) with an FPC extension cable, I've relocated the Micro SD slot  to the bottom/left of the outside of the case.

{% include posts/figure.html src="devterm-stuff/microsd-closeup.jpg" %}{:.center}

Installation requires a couple of folds, some double-sided tape and some regular tape to hold everything in place. It's not quite perfect yet and it's not likely to be very robust, but it feels like a much nicer location for the SD card.

{% include posts/figure.html src="devterm-stuff/bottom-of-shell.jpg" %}{:.center}

## Copper cooler/heatsink

I swapped out the included heatsink for one made of copper. I'm not happy with the dimensions of this, or how it's mounted, but I think it provides an improvement to the passive cooling of the CPU module. A further improvement would be to [3D print a shroud to direct the airflow of the fan better](https://forum.clockworkpi.com/t/fan-shroud-for-devterm/7598).

{% include posts/figure.html src="devterm-stuff/heatsink.jpg" %}{:.center}

## Rubber feet

I've stuck a couple of those little rubber dome feet in various locations on the bottom of the shell. This just improves the grip of the DevTerm on most surfaces to stop it sliding around as you type.

{% include posts/figure.html src="devterm-stuff/feet-closeup.jpg" %}{:.center}
