---
title: The Hidizs AP30 Music Boy
comments_issue: 165
tags: [hardware, dap, review, kickstarter]
---

I saw the Hidizs AP30 Music Boy on Reddit and got curious enough to reach out to Hidizs to see if they'd send me one to review. It's a palm-sized DAP that [launched on Kickstarter](https://www.kickstarter.com/projects/hidizs/ap30-music-boy-the-first-truly-wearable-hi-res-music-player?ref=ckchy2) on 23 July 2026, and it's pitching itself as a companion device rather than a standalone player, something to clip to a bag, hang round a neck, or snap to the back of a phone. I've had it for five weeks now, including a holiday where I used it out and about, long enough to have formed opinions beyond "this is a cute novelty."

<!-- more -->

I should say upfront that this is a review unit, so the firmware I'm running may not reflect what eventually ships to backers. I'll come back to that.

## In the box

The box contains the player itself, various USB cables, screen protector, a manual, warranty card, protective case and a set of magnetic rings that gives the device MagSafe-style attachment. More in there than I expected.

{% include posts/figure.html src="2026-08/ap30/unboxed.png" %}{:.center}

## Initial impressions

Out of the box, the AP30 looks like a tiny Game Boy. It's smaller than the dimensions had prepared me for. At 68 x 53 x 17mm and 56 grams, most earphone cases I own weigh more. It's pocket-sized on its own, but that 17mm of thickness makes itself known once it's stuck to the back of a phone.

The face buttons felt immediately familiar (d-pad, A, B, Start, Select), and I've held enough Game Boys to know. All very clicky, and easy to hit accurately even given the tiny footprint. The ALPS wheel on the side controls power and volume. The rocker is satisfying, rotates endlessly with a good amount of resistance, and clicks in nicely as a power button.

{% include posts/figure.html src="2026-08/ap30/device-marketing.png" %}{:.center}

On the back is a whale. Hidizs' website says:

> inspired by the ocean, AP30 goes beyond sound. Through our collaboration with WDC, Hidizs highlights the beauty and importance of marine life. The whale design reflects our shared respect and responsibility for the ocean.

WDC or _Whale and Dolphin Conservation_ is [the leading charity dedicated to the protection of whales and dolphins](https://whales.org/), and a portion of AP30 revenue is apparently going towards the charity, which is a nice touch even if nothing on the packaging itself explains any of it. There's a ["Whale Jam" initiative](https://www.hidizs.net/blogs/news/hidizs-x-wdc-a-partnership-for-sound-and-conservation) mentioned alongside it too. It looks nice either way.

Build quality is solid. The plastic has the textured, matte finish of any games console out of China, without feeling too cheap.

## Specs

| **Chip** | RKNanoD |
| **DAC** | Cirrus Logic CS43198 |
| **Amp** | RT6863 |
| **Display** | 2.0" IPS, 296x240 |
| **Outputs** | 3.5mm SE (61mW+61mW @32Ohm), 4.4mm balanced (137mW+137mW @32Ohm) |
| **Connectivity** | Bluetooth 5.3 (SBC only), USB-C (charging + DAC mode) |
| **Storage** | microSD up to 256GB, 210MB internal storage |
| **Battery** | 1200mAh, roughly 10 to 12hr SE, 8 to 10hr balanced, 6 to 8hr wireless, 60 days standby |
| **Dimensions** | 68x53x17mm, 56g |
| **OS** | HidizsOS |
{:.massive}

## HidizsOS

No Android here. For some that may be a selling point, though anyone after app support on a DAP will read it as a dealbreaker. Boot time is around three seconds.

{% include posts/figure.html src="2026-08/ap30/menu.png" %}{:.center}

The main menu has six items (Media Library, the Tetris clone, an Ebook Reader, File Explorer, Bluetooth, and Settings) and the less said about the ebook reader the better, it does text files and that's it. It's navigated with the d-pad and A/B buttons, and the ALPS wheel handles volume and screen wake/sleep/power. 

The now-playing screen features an A/B loop function. Press A to mark the start of a section, play on to the end point, press A again, and it loops that section on repeat. Not something I used much, but it's a rare inclusion on a DAP at any price.

The media library is where I spent most of my time, and where most of the rough edges live. Folders and albums look identical in both the library and file explorer (no bolding, no icons). Album art barely works either. Anything above roughly 300x300 pixels won't load, so most of my modern rips just show a blank square.

Adding music to the SD card triggers a full rescan that takes over five minutes, with no incremental option and no way to skip it. Other reviewers have reported the rescan simply never finishing on a second boot, though I haven't hit that myself. Long lists page six items at a time, so a big artist or genre list means a lot of paging, and a lot of repeated d-pad presses to get there. Tracks inside a folder aren't reliably sorted either, and albums can play out of order without warning.

Favouriting is the one that annoyed me most. You can't do it from the now-playing screen at all, only from the library, and doing so stops playback, requiring a manual resume. There's no gapless playback and no M3U playlist support, so anything mixed or DJ-set shaped has gaps punched through it.

{% include posts/figure.html src="2026-08/ap30/battery.png" %}{:.center}

The battery indicator is a 5-state icon rather than a percentage, which is fine until you actually want to know whether the battery will last all the way home. And the auto power-off timer caps out at 120 minutes with no way to extend it, so leaving it idle overnight isn't really an option.

None of these are fatal, but they stack up.

Screen-off control was the one that undermined the wearable pitch specifically. With the display asleep the physical buttons stopped responding, so waking the screen was the first step to skipping a track, even with a d-pad right there under my thumb. More on that in a moment, a firmware update changed the picture here partway through testing.

As a shuffle-first listener (power on, hit shuffle, go) most of the library gripes above don't apply to me, screen-off control included.

## The Tetris game

There's a built-in block puzzle game, Tetris in everything but name, for licensing reasons. The Game Boy button layout should mean it feels natural to play, rather than an awkward afterthought mapped to whatever buttons were available, but the reality is a bit disappointing. Simultaneous button presses don't feel responsive, so rotating while shifting often just doesn't register. Instant drop is in, fast drop isn't, and the next piece is shown. It's recognisably Tetris, but that's about the best I can say for it.

That's the extent of the game functionality on the AP30. No custom games, no game store, just this Hidizs version of Tetris. A portable retro game player this is not.

{% include posts/figure.html src="2026-08/ap30/tetris.png" %}{:.center}

## Connectivity

Bluetooth is version 5.3, which sounds impressive until you notice the only supported codec is SBC. No LDAC, no aptX. It's also transmitter-only, so the AP30 can send audio to a pair of Bluetooth headphones, but it can't act as a receiver for streaming from a phone. For wireless listening it's fine, though I hit the ceiling quickly with a decent pair of Bluetooth headphones. It's a wired-first device.

USB-C DAC mode is more interesting. Plugged into a laptop or phone it shows up as an external DAC, so the audio routes through the AP30's CS43198 and out through whichever output is in use. The prompt asking whether to treat the connection as USB Audio or File Transfer only stays on screen for about three seconds, not long if you're new to the device and still reading the options. The ALPS wheel is dead in this mode too, so volume has to be controlled from whatever it's plugged into rather than the AP30 itself. DAC mode and charging turned out to be mutually exclusive as well: I ran the battery down, plugged the AP30 into my phone, and it kept working fine as a DAC on an empty battery, but it wouldn't top up while doing so.

The microSD slot officially takes cards up to 256GB. Other reviewers have tried larger cards and found the AP30 reads them fine but only scans the first 256GB into the library, and browsing manually to a track outside that range plays a couple of tracks before it quietly reverts back into the scanned portion. Built-in storage is 210MB, there for firmware upgrades rather than music, so a microSD card isn't optional.

## Audio formats and sound

Format support on paper is broad, covering DSD256, PCM 24bit/192kHz, FLAC, APE, WAV, ALAC and DSDIFF.

The CS43198 DAC from Cirrus Logic appears in players costing considerably more, and the RT6863 amp is a reasonable companion to it. On paper the chip itself is rated for PCM up to 32bit/384kHz and native DSD256, comfortably ahead of what the AP30's own format support asks of it. The noise floor is low, no hiss even with sensitive earbuds, which matches what a DAC of this calibre should manage. Hidizs quote a recommended headphone impedance range of 8 to 100 Ohm on both outputs. Push past that with something high-impedance like a Sennheiser HD650 and the single-ended output is likely to struggle, which is really what the balanced output is for. The settings menu exposes five hardware-level filters from the Cirrus DAC, unusual at this price, along with six EQ presets and a custom EQ option. Whether the difference is audible depends on the chain and the ears, but I'm glad it's there.

The USB-C port doesn't carry audio out. I'd hoped to be able to use a pair of USB-C earphones. Not an option, the port is strictly for charging and for using the AP30 itself as a DAC source for another device. The only listening outputs are the 3.5mm single-ended jack and the 4.4mm balanced port, and the aforementioned Bluetooth.

I tested exclusively on the 3.5mm output during this review, and it sounds fine, clean and neutral with nothing to complain about through the earbuds and headphones I used. I don't currently have a 4.4mm balanced cable to hand, so I can't speak to how the balanced output performs in practice (on paper it offers notably more headroom at 137mW per channel versus 61mW on the SE.)

## Battery life

Hidizs claim 10 to 12 hours from the 3.5mm output and 8 to 10 hours from the balanced jack. I haven't timed it precisely, but across a couple of weeks of dipping in and out on holiday it roughly held up to that claim, and nothing left me short. Charging from empty takes around an hour, fast for a 1200mAh cell, so a quick top-up before leaving the house actually got me somewhere. It charges via USB-C, and the short cable in the box is clearly there for DAC duty rather than being an oversight.

## Form factor and carrying options

The Kickstarter pitch leans hard on wearability (neck strap, bag clip, or magnetic phone attachment). The protective case has two holes for looping a strap through, but no strap is actually in the box, so it's a bring-your-own-lanyard situation. I tried the magnetic attachment on the back of my Pixel 7a with a MagSafe-compatible case, and it felt cumbersome, an extra lump on a phone I was already handling all day. Between the protective case and the magnetic adapter ring it adds a fair bit of thickness, and the phone stops sitting flat on anything. I ended up just carrying the AP30 loose in my pocket instead.

{% include posts/figure.html src="2026-08/ap30/backpack.png" %}{:.center}

On its own the physical size means it disappears into a pocket anyway, so the magnetic carrying pitch reads more like marketing than something I actually needed.

The plastic edition comes in Classic White, Shadow Black, and Crystal Ocean Blue. The aluminium edition comes in Arcade Black and Pixel Purple, and at 80g against the plastic's 56g it's a different object in the hand, not just a different finish. I've had the Classic White, which has held up well, no marks or scuffs despite two weeks of being in and out of a pocket alongside keys and other bits. The whale print is consistent across all variants.

{% include posts/figure.html src="2026-08/ap30/colourways.png" %}{:.center}

## The Kickstarter

The AP30 funded on Kickstarter, and funded hard, a goal of £3,773 against over £323,960 pledged from more than 3,600 backers. I've written before about [my history with Kickstarter hardware](/post/every-kickstarter-project-ive-backed/), and crowdfunding audio kit always makes me a bit tense unless it's a manufacturer I've bought from before. Hidizs aren't new to this though, they've run successful campaigns before, shipping is promised for early October 2026, and the pledge comes with a one year warranty against factory defects. In this case the device exists and does what it says, and Hidizs have been responsive during the review process. Early bird pricing was $85 for the plastic edition and $93 for aluminium, with retail at $119 and $129.

[The campaign has a few days left to run](https://www.kickstarter.com/projects/hidizs/ap30-music-boy-the-first-truly-wearable-hi-res-music-player?ref=ckchy2), if the early bird pricing is tempting.

## Inside the case

The case comes apart easily enough, the back is glued on, but a plastic prying tool gets it off without any drama, and the mainboard is held in with five cross-head screws. Four test pads on the back looked promising for UART, but soldering on and capturing at various baud rates got me nowhere, one of them turned out to be an SPI flash clock rather than a TX line, and the actual TX pad stayed completely silent. Either the console is disabled in production firmware, or I've got RX and TX mixed up.

The more productive route has been the loader mode instead. Holding the d-pad and A/B buttons while plugging in USB-C drops the AP30 into a Rockchip loader mode, which is enough to pull a full firmware dump straight off the eMMC and confirm what's actually running. It's bare metal on Rockchip's RKNano SDK, not Linux and not a true RTOS either, with the touted "HidizsOS" being a UI skin on top rather than the core OS itself. The firmware format and resource layout turn out to be similar to Snowsky's Echo Mini, which uses the same RKNanoD chip, so community tooling for parsing and repacking it already exists.

{% include posts/inline-svg.html src="ap30-memory-map.svg" class="full-width center" %}

## Worth backing?

It's an odd device. The Cirrus DAC stack is better than the price suggests, the balanced output isn't just a spec sheet line, and USB DAC mode is something most competitors at this price skip. The form factor is charming in a way that's hard to quantify but easy to feel when holding it.

The firmware is the problem, though less of one than when I started. A firmware update landed partway through this review that fixed the screen-off lockout outright, along with A/B button input recognition, DSD256 playback compatibility, and a blank-screen issue in Favourites, which may or may not be the same favouriting bug I ran into (I haven't retested since the update). The remaining bugs aren't catastrophic, but they stack up (the scan times, the general library awkwardness). Hidizs have indicated they're still working on the rest, and a bug isn't fixed until it ships, but this is clearly a device getting better under me as I write.

For shuffle listening on wired headphones, with better audio hardware than my phone at a price cheap enough not to think about, I've been happy carrying it. It isn't a Rockbox-style open platform to tinker with, and I'll be honest, that's what I was hoping for. A fair chunk of the code that must be gluing HidizsOS together isn't in the firmware image at all, it looks like it lives in mask ROM baked into the chip itself, or possibly a second flash chip I haven't gone looking for yet, and getting any new instruction actually running turned out to be blocked hard. It reads as a deliberate integrity check rather than an accident. I can still change data, not code, so the homebrew Game Boy emulator dream I had going in isn't happening here. At least not yet.
