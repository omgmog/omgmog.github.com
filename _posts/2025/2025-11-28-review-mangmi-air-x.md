---
title: "The Mangmi Air X"
comments_issue: 123
tags: [review]
---

Back in 2015 when I reviewed devices like the GPD XD and similar Android handhelds, the whole ecosystem felt half-baked. Emulation wasn't particularly good yet, the devices came from obscure Chinese manufacturers, the ROMs were loaded with questionable apps, and the SOCs couldn't handle much.

<!-- more -->

A decade later and the whole landscape has shifted. Linux powered handhelds like the Steam Deck have normalised the idea of a portable gaming machine that can play almost anything. The Android handheld space has exploded too. Retroid, ANBERNIC, Powkiddy and others are churning out devices at every price point and form factor. Which means even cheaper options have to actually be good now. Decent screens, sensible thermals, proper controls. These things are expected rather than hoped for.

{% include posts/figure.html src="2025-11/mangmi_air_x_android_retro_gaming_console.png" %}{:.massive}

The [Mangmi Air X](https://mangmi.com/products/mangmi-air-x) sits firmly in the budget category at under 100 dollars. What's interesting is how much it manages to deliver at that price.

## Specifications

| Feature | Details |
|--------|---------|
| **CPU** | Snapdragon 662 (octa-core) |
| **RAM** | 4 GB LPDDR4X |
| **Storage** | 64 GB eMMC, microSD expansion |
| **Screen** | 5.5 inch IPS, 1920x1080 |
| **GPU** | Adreno 610 |
| **OS** | Android 14 |
| **Controls** | Hall effect sticks, D-pad, triggers, 6-axis gyro |
| **Battery** | 5000 mAh, USB-C charging |
| **Connectivity** | Wi-Fi 5, Bluetooth 5 |
| **Weight** | ~286 g |

## Design and Build

Build quality feels solid. At 286g it's light enough to slip into a backpack without thinking about it, and it comes with a carry case which is a nice touch at this price point. It doesn't have that hollow rattle you get with really cheap devices either. It's comfortable to hold and looks more like a small Switch Lite than the knock-off tablet designs that used to dominate this price range.

{% include posts/figure.html src="2025-11/mangmi_air_x_retro_gaming_console_11_color_white.png" %}{:.massive}

The D-pad is positioned above the left analogue stick, which works well for 2D games. It's got a glossy surface that initially looks like it would be slippery, but it's actually fine for diagonals and fighting game inputs. The Hall effect sticks are roughly Joy-Con sized and feature LED lighting around the base (orange by default, matching the Mangmi logo). This seems to be the trend with dual-stick devices lately. Thankfully they can be turned off if RGB lighting isn't your thing.

{% include posts/figure.html src="2025-11/mangmi_air_x_retro_gaming_console_8_color_white.png" %}{:.massive}

Along the bottom edge you've got a microSD slot with a nice cover, microphone, headphone jack, and USB-C port, with speakers flanking either side. Everything is where you'd expect it to be.

The Snapdragon 662 isn't going to impress anyone on paper in 2025. But at this price level it's a huge step up from the bottom-barrel chipsets that usually show up in handhelds under 100 dollars. The 1080p screen is brighter than I expected. I was prepared for something dim and washed out, but it's actually good.


## Software

Out of the box, the Air X runs a fairly vanilla Android 14 setup with a selection of pre-bundled emulators. Mangmi have kept things simple rather than building a heavily customised interface, which means you get a standard Android experience with emulator apps already installed and configured. It's straightforward to get going, which is helpful if you're new to this sort of device.

{% include posts/figure.html src="2025-11/mangmi-in-hand.png" %}{:.massive}

Android 14 runs cleanly and Mangmi have already pushed firmware updates since launch. With the older devices I reviewed a decade ago, firmware fixes were often slow, missing, or buried on mysterious Chinese forum posts that you'd have to translate via Google. Getting quick updates on a budget device feels like the bare minimum now, but it's still worth noting when manufacturers actually do it. The [firmware is available to download](https://mangmi.com/pages/download) if you need to update or reflash, and I've [mirrored the files on archive.org](https://archive.org/details/mangmi-air-x-firmware) as well.

There's a small custom ROM scene forming around the device already. [GammaOS](https://github.com/TheGammaSqueeze/GammaOSNext) is available for the Air X and brings updated GPU drivers, performance tweaks, and a Lite version that strips out Google Apps entirely for better performance and battery life. The current v1.1.1 release is [Patreon-only](https://www.patreon.com/GammaOS) until January, but I'm looking forward to trying it once it's publicly available. The fact that community ROM support exists at all for a sub-100-dollar handheld is encouraging.

I've tried a few different launchers on the Air X. The stock Android launcher works fine but is fairly basic. Mangmi's own Game Launcher is useful if you've already got a library of ROMs as it can scan and organise them. [Daijishō](https://github.com/magneticchen/Daijishou) is great for power users but requires a lot of setting up. I've read that [ES-DE](https://es-de.org/) is good but haven't tried it yet. I've been playing with [TrinketOS](https://trinketos.org/) since the summer and have really enjoyed it on other Android devices, so I might give it a go on the Mangmi as well.

The real surprise is that the Air X can run [Gamehub](https://gamehublite.com/), an app that uses compatibility layers to run Windows and Steam games on Android. I tried a couple of games from my library and it was finicky to get working. I had to hunt down a Reddit post detailing which Proton version, GPU driver and CPU translation settings to use, but once configured it did actually run. Performance isn't great, but it's playable for older 2D games and small indie titles. Obviously this isn't a Steam Deck and expecting AAA games to run is silly, but the fact that it works at all on a sub-100-dollar Android handheld is worth commenting on. Like the Steam Deck, this will likely improve over time as compatibility layers mature.

## Performance

The Air X runs PS1, PSP, Dreamcast and most 2D systems at full speed. Everything I've tried on PS1 and GBA has worked without issue. PSP titles like GTA Liberty City Stories and Vice City Stories run well, as do lighter PS2 games. Katamari Damacy plays smoothly with some tweaking. Android titles like Abe's Oddysee New 'n' Tasty, Munch's Oddysee and Beach Buggy Racing 2 all run fine out of the box.

GameCube is where you start pushing the limits. Mario Kart Double Dash wasn't really playable even with precompiled shader caches, and still had slow moments. Heavier PS2 titles are similar. The Snapdragon 662 shows its age here.

If you want to see what else runs well, there's a [growing compatibility list on EmuReady](https://www.emuready.com/listings?deviceIds=%5B%22c0215117-4f4d-4a3b-b4db-31e51958d819%22%5D) for the Mangmi Air X.

## Battery and Connectivity

Obviously battery life depends on what you're doing. PSP emulation gets around 6 hours on a charge. Lighter systems like Game Boy or NES can push past 8 hours. Heavier workloads drain it faster. This is a secondary device that I pick up for a few minutes here and there rather than extended sessions, so the battery has been fine for how I use it. USB-C charging means I can use any standard charger, and it's easy enough to plug it into mains or an external battery if I'm settling in for something longer.

There's no video output, so it's strictly a handheld device.

## Closing thoughts

If you look at what a device under 100 dollars could manage just a few years ago, the Mangmi Air X feels like a significant step forward. It's not trying to compete with the Steam Deck or higher-end Android handhelds, and it doesn't need to. What makes it interesting is how much it delivers at the price point.

I've already got a Steam Deck and a Switch, but there's something appealing about a device that's cheap enough that I won't worry about the kids getting their hands on it. It's not trying to do everything, and that's fine. For under 100 dollars, the Mangmi Air X is the sort of device you can just throw in a bag and not think about. At this price I'm honestly thinking about buying a second one.