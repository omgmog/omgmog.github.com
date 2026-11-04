---
title: Android Auto on my HR-V's Android 4.0.4 head unit
comments_issue: 174
tags: [android, programming]
---

I recently bought a 2018 Honda HR-V as our family car. It has a 7" touchscreen running Android 4.0.4, a version so old it predates Android Auto by about three years. It runs Android Auto now anyway, thanks to a small app I built over the course of a week.

<!-- more -->

{% include posts/figure.html src="2026-11/hr-v-android-auto.jpg" alt="Android Auto on the HR-V's head unit, with Spotify and Google Maps side by side" title="The big clock is the head unit's own. I've since turned it off." %}{:.center}

The Honda is great. Its head unit isn't. It has no Play Store, and Honda's own app store has _very_ few apps. The usual routes to Android Auto are swapping in the head unit from a 2019 HR-V, or rooting the existing one and installing one of the community-built apps. I didn't fancy hardware mods on a new car, and getting the apps running looked like a lot of digging through forum posts and downloading old builds from random sites. After my experience with installing an aftermarket Android unit in our old Qashqai, I wasn't keen on more of that kind of fiddling.

## Rolling my own

So naturally, I did a different kind of fiddling instead, and built something new. A head unit doesn't actually run Android Auto. The phone does all the work and sends its screen to the car, so all I needed was a receiver app that shows the video and sends touches back. I called it HU15 (head unit, [API 15](https://developer.android.com/guide/topics/manifest/uses-sdk-element#api-level-table)).

The catch is that Android 4.0.4 is missing a lot of what Android Auto needs, including TLS 1.2 and `MediaCodec` (the modern hardware video decoding API). [Conscrypt](https://github.com/google/conscrypt) covers the TLS, and [OpenH264](https://www.openh264.org/) decodes the video in software. For the protocol and handshake I leaned heavily on the great work already done by two existing projects, [HeadUnit Revived](https://github.com/andreknieriem/open-headunit) (a revival of Michael Reid's [original Headunit project](https://github.com/mikereidis/headunit)) and [OpenDroidAuto](https://github.com/MaKi983/OpenDroidAuto). HU15 wouldn't exist without them.

I wanted to test on my Mac first, but that turned out to be impossible. Android 4.x emulator images only come in x86 and ARMv7, and neither will run on Apple silicon. I ended up running the emulator on my NAS instead, and dug out an old Hudl tablet on Android 4.2.2 as a period-accurate stand-in for the head unit. Both worked fine, with my phone streaming to them over Wi-Fi.

## The way forwards was to go backwards

Getting HU15 onto the head unit was another matter. My unit was on Honda's latest firmware, RC8, which closed off most ways of running custom apps. Buried in a 234 page [XDA thread](https://xdaforums.com/t/honda-connect-android-system.3179549/) was the answer: downgrade to RC6.

Downgrading just involved preparing a USB stick correctly and rebooting the unit, though a failed update can brick it (and may void the warranty). Mine went through without complaint.

{% include posts/figure.html src="2026-11/hr-v-firmware-copying.jpg" alt="The head unit showing a Copying message while the RC6 firmware installs from USB" %}{:.center}

Following the downgrade, I had to install an app called "Honda Permissions" and add HU15 to the unit's two whitelists, one that lets it install and one that lets it run. On the second, the important setting is the app type. Set to NAVI, it keeps running while the car's moving. Anything else and the unit blanks the screen whenever the car's out of park.

| Setting | Value | What it does |
|---------|-------|--------------|
| **Auth type** | PREINSTALL | Lets HU15 hand the audio back to the unit's own apps |
| **App type** | NAVI | Keeps the screen on while driving |
| **Sound out** | ON | Radio and USB audio switch off while HU15 is open |
| **Last mode** | ON | Reopens HU15 after a restart, and it reconnects by itself |
| **Sound interrupt** | OFF | Plays normally, not over other audio from the driver's speaker like the satnav voice |
{:.massive}

I installed HU15, plugged in my phone, and Android Auto came up on the display.

## Debugging while doing laps of the block

It worked, but not well. Everything felt sluggish, the video looked badly compressed, the steering wheel buttons did nothing, and the unit's own audio apps went silent after a session. The head unit has no way to share files, so I added a button to copy the log to a USB stick. Each fix meant a 3 to 5 minute drive, logs off the unit, a new build, and back in the car.

The video turned out not to be a compression problem at all. Android Auto splits big messages into fragments, and fragments from different channels interleave on the wire. Here a video frame arrives in three parts, with a message from another channel in the middle:

{% include posts/inline-svg.html src="hu15-fragments-wire.svg" class="center" %}

HU15 reassembled everything in one shared buffer, and wiped it whenever a new message started. So when the other message turned up mid-frame, the first two parts of the video frame were thrown away, and the last part got glued onto the end of the other message:

{% include posts/inline-svg.html src="hu15-fragments-before.svg" class="center" %}

With frames going missing, the picture fell apart, which is what looked like heavy compression. It also slowed everything down. The phone expects each video frame to be acknowledged, and only lets so many go unanswered. Lost frames never were, so it throttled itself to about three frames a second.

Giving each channel its own buffer fixed it. Every fragment says which channel it belongs to, so the other message no longer gets in the way, and the video frame comes out whole:

{% include posts/inline-svg.html src="hu15-fragments-after.svg" class="center" %}

The next drive was _much_ smoother, with no more crunchy video. The log backed it up at 20 to 30 frames a second, up from three. Touch felt laggy too, because decoding a frame and drawing it were waiting on each other. Letting them overlap helped.

The wheel buttons and audio were quicker fixes. The buttons only reach an app that registers with Honda's own steering service, which OpenDroidAuto already did. The audio came back once HU15 told the unit when it starts and stops playing.

## Making it look the part

Until then, HU15 opened on a screen full of debug buttons. I wasn't going to be the only one using it, so I specced a simple Material style UI: a splash screen, then just "Pair" and "Advanced", with the debug tools tucked behind the second. Pair remembers the phone, so after the first time it goes straight into Android Auto. There's no Material library for API 15, so it's all built by hand from plain views. It's a bit out of place on Android 4.x, but _much_ friendlier.

<div class="inline-grid two-columns">
{% include posts/figure.html src="2026-11/menu.png" alt="The HU15 menu with a blue Pair phone button and an Advanced button" %}
{% include posts/figure.html src="2026-11/advanced.png" alt="The Advanced page with connection tools on the left and a log on the right" %}
</div>

## So anyway, my car has Android Auto now

I've mostly used it with Maps and Spotify, plus a bit of BBC Sounds, and it all works great. The volume and navigation buttons on the wheel work, "OK Google" works through the phone's mic, and it reconnects after a replug. Touch can still feel a bit unresponsive, but I think that's down to the head unit itself.

I built it in October, and I've been using it with both my Pixel 11 and my wife's Pixel 9 without any real issues.

HU15 is [on GitHub](https://github.com/omgmog/hu15). It'll probably work on most head units running ancient Android, but I've only tested it on my HR-V. Your mileage may vary.

Despite all that, what surprised me most is how little there is to Android Auto. A handshake, video one way, touch the other. That's more or less the whole job. Which makes me wonder what else could travel over the same protocol. Anything you can draw, presumably.
