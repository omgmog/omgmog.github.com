---
title: The Anbernic RG DS
comments_issue: 149
tags: [android, review, hardware, handheld]
syndication:
  - https://social.omgmog.net/2026/anbernic-sent-me-an-rg-ds-to
  - https://indieweb.social/@omgmog/116730476793370054
---

Anbernic sent me an [RG DS](https://anbernic.com/products/rgds) to review. It's a clamshell Android handheld designed to evoke the Nintendo DS, running Android 14 on a Rockchip RK3568 with dual 4-inch screens. At around $95 (roughly £75), it sits in the same budget bracket as the [Mangmi Air X I reviewed last year](/post/review-mangmi-air-x/), but where that was a capable general-purpose handheld, this one has a much narrower brief.

<!-- more -->

{% include posts/figure.html src="2026-06/rg-ds/rgds-screens.png" %}{:.center}

The form factor is immediately recognisable. At 160 x 91 x 22mm it's a near-match for the 3DS XL (156 x 93 x 22mm), similar button layout and hinge feel, two screens stacked vertically. The corners are sharper than the XL's rounded edges though, which I noticed in my hands after longer sessions. Both screens are the same size and resolution, which wasn't the case on the 3DS XL.

## Specifications

| Feature | Details |
|---------|---------|
| **Processor** | Rockchip RK3568, Quad-core Cortex-A55, 2.0GHz |
| **GPU** | ARM Mali-G52 2EE |
| **RAM** | 3GB |
| **Storage** | 32GB internal, microSD up to 2TB |
| **Displays** | Dual 4-inch IPS, 640x480 each, OCA laminated, 60Hz |
| **Touch** | Capacitive multi-touch with stylus |
| **OS** | Android 14 (firmware V1.18 at time of writing) |
| **Battery** | 4000mAh Li-ion, 5V/1.6A charging |
| **Connectivity** | Wi-Fi 802.11 a/b/g/n/ac (2.4GHz and 5GHz), Bluetooth 4.2 |
| **Camera** | None |
| **Sensors** | Six-axis gyroscope, microphone |
| **Dimensions** | 160 x 91 x 22mm, 311g |
| **Price** | ~$95 (~£75) |
{:.massive}

## In the box

The console, a capacitive stylus, screen protectors, a wrist loop, and a 64GB microSD. Given there are two screens to scratch, the screen protectors are at least practical. There's no slot for the stylus, so it lives loose in a bag or you just use your fingers.

{% include posts/figure.html src="2026-06/rg-ds/accessories.png" %}{:.center}

The 64GB card turns out to be the official Linux firmware, with multiple partitions, one of which is a ROMs volume pre-loaded with a starter library (160 NDS files, 206 GBA files, and various other systems). With the card inserted, the device boots straight into Linux rather than Android.

## The screens

Both screens are 4 inches, matched in size and resolution. The 3DS XL ran 4.88 inches on top and 4.18 at the bottom, at different resolutions; the RG DS goes for symmetry instead. Coming from smaller devices like the Miyoo Mini or TrimUI Brick, the difference is immediately noticeable. Both panels are well-matched in brightness and colour temperature, which isn't a given at this price. Two independent screens make room for things the original DS couldn't do. A game guide on the top, the game on the bottom works well in practice.

The resolution is 640x480 per screen. The Nintendo DS ran at 256x192, so the scaling factor is 2.5x. That's not a clean integer, so pixel-perfect rendering isn't possible without borders. DraStic offers scaling filter options to take the edge off: Scale2X and HQ2X both soften things up well enough, and integer scaling with borders keeps pixels clean at the cost of black bars. Easy to stop noticing either way.

The stylus is capacitive, not resistive. The original DS's resistive panel gave more precise single-point input; capacitive is smoother for general use but hurts games that depend on drawing or tapping.

{% include posts/figure.html src="2026-06/rg-ds/rgds-and-ds.png" %}{:.center}

## The rest of the hardware

The RK3568 handles DS emulation and most 2D systems comfortably, but loses convincing ground past N64, Dreamcast, or anything with heavier 3D.

Two analogue sticks, recessed further than feels natural given the limited space. They work, but they're clearly an afterthought. Anyone coming from a flat handheld will notice.

{% include posts/figure.html src="2026-06/rg-ds/hardware.png" %}{:.center}

Closing the lid sleeps the device; opening it wakes cleanly. If the screens time out while it's open, only the power button brings them back. Touching the top screen doesn't register as activity for Android's idle detection either, so the device can go to sleep on you even while you're actively using it. Mildly annoying if your hands are already on the controls.

The hinge is solid, tight enough that the device stays open at whatever angle you set it, with a firm linear advance all the way to 180 degrees flat. Build quality is fine for the price. Mine is Black & Crimson Red; it also comes in Turquoise Blue and Polar White, the names nodding at that DS inspiration.

The bottom is completely plain bar four 1.5mm hex screws, which is a welcome change from Nintendo's tri-wing. The top edge has two USB-C ports, one for power and data transfer, one for OTG. Both are labelled, but nothing physically stops you plugging into the wrong one.

At 311g and about twice as thick as a modern phone, it doesn't fit in a front pocket but slides into a back pocket.

No camera, which is a bit odd when budget smartwatches manage to include one, but since none of the emulators need it the omission is hard to argue with.

{% include posts/figure.html src="2026-06/rg-ds/rgds.png" %}{:.center}

The speakers are loud enough and clear, but thin on bass. Bluetooth works fine. I haven't tested the 3.5mm jack; other reviewers report a fair bit of interference hum through it.

The face buttons and D-pad are clicky micro switches. The shoulder buttons are springy and clicky. Fine when gaming alone, but the noise carries (you sort of wish they were squashier if you're playing near others).

The vibration motor is far more powerful than it needs to be. It goes off when plugging in to charge, connecting via USB, and on shutdown (a full rattling buzz each time). It's all controllable from Android's sound settings though; I turned it off immediately.

## Battery life

The 4000mAh battery is rated at around six hours. DS emulation at reasonable brightness gets closer to three to four. Well below the marketing figure.

Charging is at 5V/1.6A, which is slow. Expect around three and a half hours from empty.

The battery indicator is unreliable, staying green well past what the charge warrants. The percentage is more reliable than the icon.

## Emulation

The obvious target is DraStic for DS games. Every DS title I tried ran at full speed. Games fill both screens as they're supposed to, no awkward hotkeys or workarounds. The stylus works, though it's noticeably laggier than on actual DS hardware (the capacitive panel is the culprit). For most games that's fine; for anything that depends on precise or rhythmic stylus input (Rhythm Heaven, Elite Beat Agents, Kirby Canvas Curse) it's a problem.

Running Mario Kart DS with Scale2X on for a couple of grand prix cups does make it run warm, but it keeps going without complaint.

DSiWare is a gap. DraStic doesn't support it, and melonDS (the only option that does) runs DSiWare titles very poorly on this hardware.

One DraStic annoyance is that the L2 and R2 buttons are bound to save and load state by default. On a clamshell, those sit where my fingers naturally rest, so I kept accidentally triggering a save or load mid-game until I remapped them. Easily fixed, but surprising it shipped that way.

GBA via GBA.emu is flawless. Zelda: The Minish Cap ran perfectly, and R2 fast-forward is handy for cutscenes. The hardware is massively overpowered for anything in the 16-bit era and below.

PPSSPP handles most PSP games well. GTA Liberty City Stories and Vice City Stories both ran fine via the standalone app. The RetroArch core was a _different_ story, with audio stuttering in cutscenes and lag when driving fast. Standalone PPSSPP is the better choice. The heavier 3D titles (God of War: Chains of Olympus, Crisis Core) I haven't tested, but RK3568-class hardware is generally not their friend.

PS1 via DuckStation is great. Metal Gear Solid ran without hiccups, 2x upscaling held steady. DuckStation on Android hasn't had an update since May 2025 and the developer has stepped back. It still works, but the maintained alternative is RetroArch's SwanStation core, a DuckStation fork. Save files transfer across directly.

N64 through Mupen64Plus FZ Pro standalone runs well; it handles compatibility better than the RetroArch core for a handful of games.

3DS via the stock Azahar build is mostly disappointing. The preinstalled version undersells what's possible though. Swapping to [AzaharPlus](https://github.com/AzaharPlus/AzaharPlus/releases), a community fork with extra optimisations, is worth it. New Super Mario Bros 2 Special Edition runs at 85%+ speed, which is very playable. Getting the dual-screen layout configured wasn't obvious, but once sorted it works nicely. Not every 3DS title will fare as well, but it's worth trying before writing 3DS off entirely.

## Stock firmware

Most early reviews got a device in a rough state. The headline problem was screen desync (top panel at 40Hz, bottom at 60Hz), which is hard to ignore. DraStic had noticeable input lag, the D-pad misfired on diagonals, sleep/wake was unreliable, and the launcher was sluggish. That coverage stuck, and the device's reputation took a hit before most retail units shipped. V1.15 fixed the desync. V1.18 smoothed out more of the rough edges. What most buyers get now is a different device to the one those reviews described.

Firmware updates are listed on [Anbernic's update page](https://anbernic.com/pages/ambernic-system-update-links-for-various-models), though the hosting is unreliable. V1.18 is on WeTransfer, V1.15 and the Linux build are on Google Drive.

The stock OS is workable but not especially clean. It's Android 14 with custom launcher changes. The RG button earns its place: a short press switches input focus between screens, a long press opens Anbernic's game frontend, and mid-game there's no need to reach for the touchscreen. Standard frontends like Daijisho and ES-DE install without issue, though DraStic has to be launched directly, and the patched version that fixes the 40Hz screen bug isn't automatically picked up by frontends.

The emulator lineup is hard to fault. [DraStic](https://drastic-ds.com/) for DS, [Azahar](https://azahar-emu.org/) for 3DS, and the .emu suite covering handheld and 16-bit systems ([GBA](https://www.explusalpha.com/contents/gba-emu), [GBC](https://www.explusalpha.com/contents/gbc-emu), [NES](https://www.explusalpha.com/contents/nes-emu), [SNES](https://www.explusalpha.com/contents/snes9x-ex-plus), [Mega Drive](https://www.explusalpha.com/contents/md-emu), [Neo Geo](https://www.explusalpha.com/contents/neo-emu), [Neo Geo Pocket](https://www.explusalpha.com/contents/ngp-emu), [PC Engine](https://www.explusalpha.com/contents/pce-emu), [MSX](https://www.explusalpha.com/contents/msx-emu)). There's [DuckStation](https://www.duckstation.org/) for PS1, [PPSSPP](https://www.ppsspp.org/) for PSP, [Flycast](https://github.com/flyinghead/flycast) and [Redream](https://redream.io/) for Dreamcast (both included), [Yaba Sanshiro 2 Pro](https://yabasanshiro.com/) for Saturn, [Mupen64Plus FZ Pro](https://github.com/fzurita/mupen64plus-ae) for N64, [RetroArch](https://www.retroarch.com/) as a catch-all, and [EasyRPG Player](https://easyrpg.org/) for RPG Maker games. [Apollo](https://github.com/ClassicOldSong/Apollo) and [Limelight](https://moonlight-stream.org/) handle game streaming. There's also [APKPure](https://apkpure.com/) as an alternative app store (Google Play Services removed it on my unit before I got a chance to use it), a couple of Chinese apps that don't serve much purpose outside China, and the Play Store, which I haven't signed into.

GammaOS is the one most people seem to land on for day-to-day use.

## GammaOS Next

{% include posts/figure.html src="2026-06/rg-ds/gammaos.png" %}{:.center}

Most long-term owners end up on something different: [GammaOS Next v1.2.2](https://github.com/TheGammaSqueeze/GammaOSNext/releases/tag/v1.2.2-ANBERNICRGDS), a custom Android 14 build (based on LineageOS 21) that several reviewers frame as what should have shipped from the start. When I reviewed the Mangmi Air X last year, GammaOS was Patreon-only. It went public in April 2026, and the RG DS felt like the right device to finally try it on.

It addresses the stock OS's main rough edges (sleep/wake reliability, input latency in DraStic, diagonal D-pad misfires, general sluggishness). The touch panels are bumped to 120Hz. DualStack mode makes apps behave as single-screen when needed, plus per-screen volume, system-wide audio EQ, and a global shader pipeline so CRT filters apply across all emulators without per-emulator config.

The bottom screen can't be fully turned off, only dimmed. The more demanding systems (N64, Dreamcast, PSP) are not GammaOS's strongest suit, but 3DS compatibility, full Android app support, and DraStic with shader support make up for it. DraStic runs well even in low power mode, which helps battery life considerably. Standby drain is about 3% over eight hours.

The install wipes the device (unlike Linux firmware which boots from microSD), so it's a one-way trip until reflash. _Lite_ is the better choice; Google Services overhead makes Full sluggish on the RG DS hardware.

Install is via fastboot. Post-install it sets up RetroArch and Daijisho, and comes with DraStic, Flycast, Mupen64Plus FZ Pro, and PPSSPP pre-installed. Launching Mario Kart DS from Daijisho feels near-instant. It feels more like a games console out of the box than Android with emulators dropped on it.

I went with Lite, which skips Google Services entirely and ships with Aurora Store and Firefox instead of the Play Store. Noticeably snappier than stock.

The RG button loses its special functions on GammaOS; it just pulls down the notification drawer.

DraStic comes pre-configured for dual screen. DS games run better than on stock.

GammaOS also ships with demo ROMs across a range of platforms and three Pico-8 games via the fake08 RetroArch core. Enough to get a feel for each system before digging into your own library.

## Linux flavours

Anbernic released an [official Linux firmware](https://anbernic.com/pages/ambernic-system-update-links-for-various-models) (v1.0, May 2026) taking a more console-like approach (games sorted by system, launched through DraStic and RetroArch, with a DS-themed UI). The included 64GB card is this firmware, with a starter ROM library and a handful of ports (Doom with nine WADs, Cave Story, VVVVVV, Sonic Robo Blast 2, C-Dogs) plus 39 Pico-8 carts running through the fake08 RetroArch core. Decent for a first boot.

{% include posts/figure.html type="iframe" src="https://www.youtube.com/watch?v=eKoDHtU_ELk" %}{:.center}

The UI feels unpolished. The in-game menu has tiny unreadable text, the three included themes are fairly basic, and game cover scraping is patchy. DS games run fine, but there's no scaling control (everything stretches to 640x480 with no pixel alignment), which looks rough versus DraStic on Android. Raw emulation performance is worse than Android, and high-res 3D mode struggles. Audio bugs, a "now playing" overlay on the bottom screen that can't be disabled, occasional shutdown issues. Worth revisiting as it matures. It boots from microSD, so no need to wipe the internal Android install to try it.

[ROCKNIX](https://rocknix.org/) doesn't have an official RG DS build yet. There's an unofficial workaround using the RK3566 nightly with a config edit, and there's already a [DSi-style EmulationStation theme](https://github.com/beebono/dii-ess-aye) for it. One to watch once an official build lands.

[Knulli](https://knulli.org/) is another community Linux build with the same basic install process as ROCKNIX, currently in alpha and Patreon-only. Not practical for most people yet.

## Worth it

At $95 it does one thing better than most, playing DS games in the right form factor. The clamshell, dual screens, and a hinge that folds it pocket-sized all do the same job. Save states, fast forward, and a spare screen to pull up a guide or video while playing are things actual DS hardware can't offer. The bundled emulator lineup covers a lot of ground, DraStic runs everything I threw at it, and GammaOS addresses the rough edges that hurt early reviews.

The caveats _matter_. The capacitive stylus lag rules out precision games, and DSiWare is effectively a dead end on this hardware. The RK3568 falls apart past 5th-generation 3D. Battery life is three to four hours in practice, well short of the marketing figure. The analogue sticks feel like an afterthought. The vibration motor is absurdly strong for the job. The sharp corners dig in during longer sessions.

As a DS replacement it's probably the best DS-feeling option going.

Two counterpoints worth considering. A DS Lite plus [a DS Pico flashcart](/post/ds-pico-flashcart/) comes in at around half the price, actual hardware, proper resistive touchscreen. There's also DS wifi-play, which the RG DS can't offer at all. Hard to ignore if DS games are the whole point.

Or a [3DS modded with custom firmware](https://3ds.hacks.guide/), which runs DS, DSiWare, and 3DS titles perfectly, and covers a fair few other systems besides.

The RG DS is available directly from [Anbernic](https://anbernic.com/products/rgds).