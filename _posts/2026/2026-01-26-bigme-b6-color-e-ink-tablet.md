---
title: The Bigme B6 Color E-Ink Tablet
comments_issue: 130
tags: [e-ink, android, review]
---

I've owned plenty of Kindles and Android tablets over the years, but I've been curious about colour e-ink for a while - whether it's actually useful or just a _gimmick_.

<!-- more -->

{% include posts/figure.html src="2026-01/bigme-b6/device.png" %}{:.massive}

The [Bigme B6 Color](https://bigmestore.com/products/bigme-b6-color-ereader-with-android-14os) is a 6-inch Android tablet with [Kaleido 3](https://www.eink.com/product/detail/EC060KH5) colour e-ink. I picked one up wanting something easier on the eyes for bedtime reading - not another glowing phone screen.

## Specs

- **Display**: 6-inch Kaleido 3 colour e-ink (300 PPI B&W, 150 PPI colour)
- **Resolution**: 1448 × 1072 (B&W), 724 × 536 (colour layer)
- **Processor**: MediaTek Helio P35, Octa-core 2.3GHz
- **RAM**: 4GB
- **Storage**: 64GB (expandable via microSD up to 1TB)
- **OS**: Android 14
- **Battery**: 2100mAh
- **Frontlight**: Warm/cool adjustable (36 white and amber LEDs)
- **Connectivity**: Dual-band WiFi, Bluetooth, USB-C with OTG
- **Audio**: Speaker, microphone
- **Size**: 108 × 149 × 7mm
- **Weight**: 176g

## The display

Colour e-ink is not vibrant. The colour layer sits on top of the B&W layer, so colours are muted (think newspaper, _not_ magazine), resolution is halved for colour content, and there's some ghosting when switching between colour and B&W.

{% include posts/figure.html src="2026-01/bigme-b6/color-display.png" %}{:.massive}

For pure text reading, the B&W mode is excellent. Text is sharp and the frontlight is even. For illustrated books and comics, the colour adds something - not enough to replace an iPad, but enough to make children's books and the occasional graphic novel more usable than greyscale.

At 6 inches, it's pocketable (large pocket) and comfortable for one-handed reading - good for commuting or bedtime. But that size limits what works well. A4 PDFs need constant zooming and panning, detailed comics feel cramped. It's just right for novels, articles, and manga formatted for smaller screens.

It comes with a magnetic protective cover that snaps on and wakes the device when opened. The back of the device itself is also magnetic, which could be useful for mounting or storage - I haven't found a use for it yet, but it's _there_.

## Android on e-ink

The B6 runs Android 14, which means I can install any reading app I want - Kindle, Kobo, Google Books, Libby, [KOReader](https://koreader.rocks/). That flexibility is the main selling point over a locked-down Kindle or Kobo.

The trade-off is that most Android apps assume fast colour screens. Animations stutter, menus leave traces, and battery drains faster with apps running in the background. Bigme has added some e-ink optimisations (refresh mode options, reduced animations), but it's still _phone-first_ Android running on e-ink.

The stock OS also comes with a lot of bloat - Bigme's own app store, translation apps, a video player, various MediaTek utilities. I disabled most of it and replaced the home screen to get something cleaner. I've put together a [debloat script](https://gist.github.com/omgmog/2c0987faac4d7e4bc907af4e6830168c) that handles the cleanup. After debloating, battery life is good - I charge it maybe once a week with regular use. Better than any LCD tablet, not as good as a dedicated Kindle.

One other quirk: the face buttons. They're hardware buttons with icons for specific functions, remappable through xSetting. The icons made no sense to me, so I covered them with vinyl stickers labelled B/H/F/T/S and rebound them to back/home/files/task switcher/settings. _Much_ better.

{% include posts/figure.html src="2026-01/bigme-b6/buttons.jpg" %}{:.massive}

There don't seem to be any custom Android versions available for the B6 unfortunately. There's been [some work on other Bigme devices](https://xdaforums.com/t/bigme-hibreak-root-mediatek-6765.4697830/), but nobody's cracked the screen software.

After debloating, I'm using:

- [KOReader](https://koreader.rocks/) - my main reading app
- [Feeder](https://f-droid.org/packages/com.nononsenseapps.feeder/) - RSS feeds
- Kindle, Google Play Books, Libby - for books I've bought elsewhere or library borrowing
- Spotify - audiobooks and podcasts

## Should you buy one?

Probably not.

I'm using the B6 for reading books, catching up on RSS feeds and indieweb stuff - basically anything that isn't doom scrolling. It's good at that. The e-ink screen means I can read for hours without the eye strain I get from phones and tablets.

But it sits in an awkward spot. It promises a lot (Android flexibility, colour e-ink, compact size) but it doesn't quite deliver on any of them fully. I'd like something a bit bigger for PDFs, and the screen still feels sluggish for anything interactive. It's caught between being a Kindle and being a tablet, without being the best at _either_.

I paid around £125 for the B6. The colour e-ink market has matured since then - there are more options now and prices are dropping. The [InkBook Solaris Color](https://inkbook.eu/products/e-book-reader-inkbook-solaris-color) has similar specs for £120-145, and mainstream devices like the [Kobo Clara Colour](https://uk.kobobooks.com/products/kobo-clara-colour) now offer Kaleido 3 without needing to tinker with Android. If I were buying today, I'd probably look at one of those or wait for the next generation of colour e-ink panels.

Colour e-ink is nice to have, but not essential. For most reading, regular e-ink is probably fine and cheaper.
