---
title: Installing Android on the Nintendo Switch
comments_issue: 128
tags: [guide, nintendo-switch, android, retro-gaming]
---

A banned Switch sitting on a shelf is prime hardware for Android. Turns out the Tegra X1 that powered Breath of the Wild runs a full Android OS surprisingly well.

<!-- more -->

My Switch got banned after I ran homebrew on it to backup game saves, so I could use them in a Switch emulator on my Steam Deck. I'd put hundreds of hours into Mario Kart 8, Breath of the Wild, Tears of the Kingdom, Animal Crossing and many other games since purchasing it in early 2018, so when the ban hit it went from being my main handheld to a paperweight.

Installing Android on it turned out to be fairly well-documented. There are a few different options for the Switch - the [Switchroot](https://switchroot.org/) project maintains Android 10 and 11 builds alongside Linux images (Ubuntu, Fedora), and LineageOS now has official support going up to Android 15. 

I went with LineageOS 22, though some people report better stability on the older Android 11 builds. I'm using a first-generation Switch (the ones vulnerable to the Tegra bootrom exploit), a microSD card, and a lot of patience.

{% include posts/figure.html src="2026-01/switch/rcm.png" %}{:.center}

## Installing LineageOS

The installation process is documented across a couple of resources:

- [Switch Hacks Guide - Installing Android](https://switch.hacks.guide/extras/installing_android.html)
- [LineageOS Wiki for Switch](https://wiki.lineageos.org/devices/nx_tab/variant1/)
- [LineageOS Downloads](https://download.lineageos.org/devices/nx_tab/builds)
- [Google Apps installation](https://wiki.lineageos.org/gapps/)

Here's the rough process I followed:

1. **Boot into Hekate** - The Switch Hacks Guide has detailed instructions for getting Hekate running via RCM mode. You'll need a jig or paperclip method to short the right Joy-Con rail pins.

2. **Partition the microSD card** - The LineageOS wiki walks through creating the necessary partitions. You'll need space for the system, data, and optionally a partition for Nintendo's stock firmware if you want to dual-boot.

3. **Dump Joy-Con Bluetooth pairing data** - This is critical. Hekate can dump the Joy-Con pairing info from your Switch's system storage, which you'll need to get the Joy-Cons working in Android. Skip this and you'll be stuck using the touchscreen.

4. **Flash LineageOS** - Download the build and flash it according to the wiki instructions.

5. **Install Google Apps** - Optional, but useful if you want the Play Store. The LineageOS wiki has links to compatible GApps packages.

{% include posts/figure.html src="2026-01/switch/android.png" %}{:.center}

Holding volume down during boot gets you back to Hekate, which is useful for switching between Android and the stock Switch OS if you've dual-booted, or accessing Hekate's tools again.

## Performance and stability

The Switch runs PS1, PSP, and most 2D systems at full speed through [RetroArch](https://www.retroarch.com/). I've had some success with Gamecube, but it does stutter in places. Android games like [Oddworld New 'n' Tasty](https://play.google.com/store/apps/details?id=com.oddworld.Tasty), [Munch's Oddysee](https://play.google.com/store/apps/details?id=com.oddworld.MunchsOddysee), [GTA Vice City](https://play.google.com/store/apps/details?id=com.rockstargames.gtavc) and [Max Payne](https://play.google.com/store/apps/details?id=com.rockstar.maxpayne) all run well.

{% include posts/figure.html src="2026-01/switch/es-de.png" %}{:.center}

For RetroArch and emulation, I've been using [ES-DE](https://es-de.org/) as a frontend. I'm using specific standalone emulators for some systems, and the built-in cores for others. 

The Joy-Cons work well once the pairing data's dumped. Buttons, sticks, gyro, touchscreen and Wi-Fi all work without issues. There's a mouse mode toggled with the Screenshot button - handy for navigating Android's interface, though it needs toggling off for games since L2/R2 and the right stick don't function when it's active.

Docked mode works, though switching the display output to the TV requires pressing A on the right Joy-Con. The Joy-Cons wouldn't pair wirelessly together, but an Xbox One controller paired and works fine. Games play well on the TV through the dock.

## Is it worth doing?

For a banned Switch like mine, the reason's simple - it can't access the eShop, can't play online, and can't download updates. Android gives it a purpose.

Even for an unbanned Switch, Android opens up a much larger library. RetroArch on Android is more flexible than what's available through homebrew on the Switch OS, and the 6.2-inch screen is a good size for handheld emulation.

For media consumption, the Switch becomes a decent Android tablet. The screen's only 720p, which isn't great compared to modern tablets, but it's fine for video playback.

There's also a practical family angle. Unlike my Steam Deck, I don't mind handing the Switch off to my kids. It's durable hardware that was already banned and unused, so if it gets dropped or the Joy-Cons get sticky from whatever they've been eating, it doesn't matter. It's become another device in the rotation that they can use without me worrying about it.

For me, the Switch running Android is a good use of hardware I already own and wasn't using. If I was starting from scratch and wanted an Android gaming handheld, I'd probably just buy the Mangmi. But a banned Switch gathering dust is worth the effort.
