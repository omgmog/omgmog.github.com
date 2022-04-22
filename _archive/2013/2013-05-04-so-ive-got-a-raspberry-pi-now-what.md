---

title: "So I've got a Raspberry Pi, now what?"
---
I was going to title this post "In which I moan about the Raspberry Pi", read on to find out why.

I've had a Model B Raspberry Pi in my possesion for nearly two months now, and beyond playing with pre-built OS images for it, or setting up an AirPlay server, I've not really put the Pi to much use.

<!-- more -->

## Why did I buy the Raspberry Pi?
Well I'm a sucker for buying new gadgets, and the Raspberry Pi has a price point that's hard to refuse. Mine actually ended up costing about 3-4 times as much as just buying a Pi would cost, as I opted in for the ["bells and whistles" package from Maplin](http://maplin.co.uk/raspberry-piandreg-board-and-starter-kit-652805) that includes:

- Raspberry Pi Model B
- 4GB SD Card with Raspbian OS pre-installed
- HDMI Cable
- Keyboard
- Micro-USB mains adapter
- Mouse
- Powered 4-port USB hub
- Wi-Fi dongle

I also figured it would be worth having a nice case on the Pi, so I bought a [Pibow case from Pimoroni](http://shop.pimoroni.com/products/pibow).

The total cost of all of this? About £80. But that's not a problem really, for something I thought I'd like to utilise for some weekend projects the cost is justifiable.

## What do I want to do with the Raspberry Pi?
Well that's where I get stuck. I've got countless computers at my disposal that will do much of what the Raspberry Pi can do, and probably better, but they're full computers, and they use a lot more kWh than the Raspberry Pi.

As I mentioned earlier, I've tried a couple of things with the Pi, with varying results:

- Used the "Raspbian" debian OS image that came on the SD card
- Used "BerryBoot" to try a bunch of other OS images that are available
- Introduced my 10-year-old nephew to [Scratch](http://scratch.mit.edu/)
- Set up and then never used [AirPlay](http://lifehacker.com/5978594/turn-a-raspberry-pi-into-an-airplay-receiver-for-streaming-music-in-your-living-room) to make the Raspberry Pi function as an iTunes receiver
- Played a bit of Quake 1 (though I've read since that Quake 2 and Quake 3 are available too)
- Set up and then never used [ownCloud](http://owncloud.org/)

These are all end-user type uses of the Raspberry Pi though, I'd like to do something that involves hacking away late in to the night, but that brings me back to my earlier comment about having countless computers available that can do this task better/faster.

## The Raspberry Pi can do a lot of things, but it can't do them with any sort of speed.

{% include posts/figure.html src="Image%202013.05.04%2016_30_17.png" %}{:.massive.center}

The Raspberry Pi is not a fast machine. The spec of the Model B are as follows:
- CPU: ARM1176JZF-S (armv6k) 700 MHz
- RAM: 512MB
- GPU: Broadcom VideoCore IV

As it uses an `armv6k` CPU, it can't run any consumer distributions of Linux such as Ubuntu. The version of Debian built for the Raspberry Pi contains it's own repository of `armhf` (ARM Hard Float) packages that support `armv6k`.

The Raspberry Pi is touted as a computer for kids to learn to program, and [Scratch](http://scratch.mit.edu) is touted as the go-to software for kids to start, but it runs abysmally slow on the Raspberry Pi.

I've been using BerryBoot as a means to running an OS on the Pi since I discovered it, but I found out recently that BerryBoot doesn't utilise the full 512MB of ram available in my Model B Raspberry Pi, so maybe that has contributed to the slowness -- but I can't imagine it's any better for Model A owners (with 256MB of RAM) in that case.

## What about extra hardware, GPIO, and all that jazz?
Ah well there's an interesting thought. I've not touched the GPIO in the Raspberry Pi, and from what I've seen that seems to be the stand-out feature of the Pi.

But that means investing more money into this, to get a nice break-out board, or an [adafruit kit](http://www.adafruit.com/category/105), which is pretty nice if I want to make applications that can make coloured LEDs blink.

I've seen some awesome projects for the Raspberry Pi, such as Pi-powered kegerators, helicopters, LEGO robots, arcade machines etc. But when I try and think of something as cool as those things, my mind draws a blank and I soon lose interest in the idea of making something cool.

## Some closing ideas and potential plans, let's see if anything comes of them
- I might do away with BerryBoot and burn my own OS image to the SD card so that I can fully utilise the ram
- I might just go back to using the Raspberry Pi for AirPlay, and leave it hooked up to the stereo in my home office.
- I might setup a status dashboard, and have the Raspberry Pi married to a monitor to simply display server statistics, or JIRA/Trello tasks, or something to that effect.

If you've got any ideas, let me know in the Disqus comments below.
