---
title: The DS Pico might be the last DS flashcart you'll ever need
comments_issue: 140
tags: [nintendo, retro-gaming, review]
---

In 2007 I was deep in the DS flashcart scene, cycling through a string of carts. [GBATemp](https://gbatemp.net) threads, firmware drama, custom skins, compatibility lists. By 2009 I'd moved on.

{% include posts/figure.html src="2026-02/dspico/backin.gif" %}{:.center}

Nearly twenty years later, the DS Pico has pulled me right back in. Open-source, built around an RP2040, and around £10 from [Chiscart on AliExpress](https://www.aliexpress.com/item/1005011543735291.html). I've bought three.

<!-- more -->

DS emulation is pretty much solved at this point. It runs fine on a phone without much effort. The case for real hardware isn't compatibility. It's that picking up a DS means playing a game.

No lock screen, no notifications, no browser tab in the background. The clamshell clicks shut when you're done and slips into a pocket. When you open it again there's no boot screen, no updates, no fuss.

## A Pi in a DS slot

{% include posts/figure.html src="2026-02/dspico/slot1.jpg" %}{:.center.massive}

The DS Pico is an open-source flashcart for the Nintendo DS family. It's the result of about four years of work by the [LNH Team](https://www.lnh-team.org/), a group focused on preserving classic consoles and creating new hardware to keep them alive.

| Feature | Details |
|---------|---------|
| **Chip** | RP2040 microcontroller (same as Raspberry Pi Pico) |
| **Storage** | MicroSD card slot |
| **Read speed** | Up to 6MB/s sequential |
| **Power** | Dual power support (~57mW average) |
| **Port** | Micro USB for firmware updates |
{:.massive}

The schematics, firmware, software, and shell designs are all on [their hardware page](https://www.lnh-team.org/dspico_hw.html). Anyone can make them, and bundle them up with extras, which is why the price varies so much.

The LNH Team also built [their own software](https://www.lnh-team.org/dspico_sw.html) to go with it. [Pico Launcher](https://github.com/LNH-team/pico-launcher) is the front-end, [Pico Loader](https://github.com/LNH-team/pico-loader) runs the games, and load times are nearly instant compared to alternatives like [nds-bootstrap](https://github.com/DS-Homebrew/nds-bootstrap). It supports custom themes and box art display ([PicoCover](https://github.com/Scaletta/PicoCover) is the easiest way to fetch and convert NDS and GBA cover art from [GameTDB](https://www.gametdb.com/) into the right format), though themes are fairly basic.

I've since switched to [TWiLight Menu++](https://github.com/DS-Homebrew/TWiLightMenu) as my launcher of choice. There's a DS Pico-specific build, it looks like the DSi menu out of the box, and it integrates [GBARunner2](https://github.com/Gericom/GBARunner2) so GBA ROMs launch right alongside everything else (particularly nice on the DS Lite). It also supports Pico Loader as its game loading backend (the `.bin` files go in a `_pico` folder on the card, with Game Loader set to "pico" in Settings, Games and Apps), which is a lot faster than the default nds-bootstrap (though a small number of titles have known compatibility issues). Other launchers are available too.

## In the box

{% include posts/figure.html src="2026-02/dspico/unboxing.jpg" %}{:.center.massive}

Each came in a small Chiscart-branded box, with the cart in an injection-moulded case (the purple PCB visible through it), a tiny white micro USB cable, and two stickers (one DS Pico logo, one Chiscart). I've got three (clear, clear charcoal, and clear red).

No SD card included, which was fine. I've got a stack of reputable branded cards already, and a library of game backups to go with them.

Some sellers are starting to offer a USB-C version for a bit more, worth it if you'd rather not dig out a micro-USB cable (though the larger port apparently means a smaller label on the cart).

Build quality is good. The injection-moulded shell feels premium, clicks in properly and doesn't rattle around or feel too tight. Some sellers use 3D-printed shells, and there are reports of quality issues with those. I'd check the listing before buying. Only complaint with mine is that the microSD protrudes about 0.5mm from the shell.

## Getting started

Most units come pre-flashed with [WRFUxxed](https://github.com/LNH-team/dspico-wrfuxxed), which works across the whole DS family including unmodded DSi and 3DS. There's also an ntrboot variant for softmodding those consoles, but the DS Lite needs the standard build. Mine came with it already on there, though not every seller ships it enabled. I reflashed to the latest build before testing anyway. The [flashcart-guides setup guide](https://sanrax.github.io/flashcart-guides/cart-guides/dspico/) has more detail if needed.

To flash, eject the SD card and plug in the USB cable. It goes straight into BOOTSEL, showing up as `RPI-RP2`. Drop the `.uf2` on and it reboots. If the card's already in, hold the button while plugging in.

Getting the launcher and games on to the SD card:

1. Format a microSD card as FAT32 with 32KB clusters (it won't detect other formats; 32KB is the standard recommendation for flashcarts)
2. Download a pre-built SD card setup, such as [this one on Archive.org](https://archive.org/details/dspico-bootloader-fw-sd-files.-7z), and extract it to the card
3. Add your ROMs anywhere on the card (I use a `roms` folder)
4. Pop the card in and you're done

The cart **needs** a FAT32 SD card to be detected. By design, no card means no boot, which keeps BOOTSEL mode always accessible. The [DSi hacking Discord](https://ds-homebrew.com/discord) has a dedicated DS Pico channel if you have any problems.

## Console support

The DS Pico works across the whole DS family, though what you get varies by console.

**On the DSi and 3DS**, this is where it earns its keep. Full DSi mode means DSi-enhanced games use the camera and modern WiFi, and everything that used to need a proper DSi flashcart just works. On the 3DS it shows up as "Nintendo DS Demonstration" in the home menu (I haven't been able to test this personally, having sold mine a couple of years back, but it's well-documented to work).

WRFUxxed autoboots on the DSi by default. The exploit kicks in on power-on, there's a brief red WRFU Tester screen, and it's straight into Pico Launcher without ever touching the DSi menu. The [archive.org package](https://archive.org/details/dspico-bootloader-fw-sd-files.-7z) includes a `DSPico - NoAutoDSI.uf2` as of v1.1.4 if that's not wanted, or it can be disabled by building from source with `ENABLE_PREVENT_DSI_AUTOBOOT`.

Everything I've thrown at it has worked. NDS games load without issue, and DSi-enhanced games that use the camera get proper camera access. DSiWare packaged as `.nds` files works fine too. The firmware also supports [ntrboot](https://wiki.ds-homebrew.com/ds-index/ntrboot) as an optional feature you enable when building from source, useful if there's an unmodified DSi or 3DS that needs softmodding and a DS Pico already kicking about (the LNH Team recommend powering the board via micro-USB rather than the console for DSi ntrboot).

{% include posts/figure.html src="2026-02/dspico/dsi.jpg" %}{:.center.massive}

**On the DS Lite**, it's DS mode only. No DSiWare, no DSi-enhanced features. Shows up as "DSpico LNH Team" in the menu and acts as a standard NDS flashcart. The DS Lite needs a non-ntrboot firmware variant. DS games run perfectly, and DSi-enhanced titles fall back to their DS functionality as expected. DSiWare fails to launch, and leaves you with a white screen.

## Micro USB tricks

The micro USB port isn't just for firmware updates. The LNH Team put out [four experimental homebrew apps](https://github.com/LNH-team/dspico-usb-examples/releases) that use it:

- [`mass-storage.nds`](https://github.com/LNH-team/dspico-usb-examples/releases), which mounts the microSD card over USB so you can drag files onto it without removing the card
- [`usb-microphone.nds`](https://github.com/LNH-team/dspico-usb-examples/releases), which uses the DS/DSi/3DS as a PC microphone
- [`usb-speaker.nds`](https://github.com/LNH-team/dspico-usb-examples/releases), which pipes PC audio out through the console's speaker
- [`usb-video.nds`](https://github.com/LNH-team/dspico-usb-examples/releases), which turns a DSi or 3DS into a webcam

They're very much demos rather than finished tools, and they need a bit of faffing to get running (launch the app, then plug in the cable). But `mass-storage.nds` is actually useful. If the card reader dies, it's an _easy_ way to copy games straight to the cart over USB.

## Open source, actually

Most flashcarts treat the source as a trade secret. The team behind the DS Pico publish everything online, from PCB designs through to 3D-printable shell files and box art. Anyone with the skills and equipment can build one from scratch.

This matters because the DS flashcart scene has been a mess for years. The original R4 team disbanded ages ago, and the market filled up with clones that sometimes included timebombs (code that bricks the cart after a certain date to force you to buy a new one). With an open-source design, that's not a concern.

The LNH Team won't sell boards directly, leaving it to third-party sellers at anywhere from £10 to £25. Some bundle a pre-loaded SD card (_games included_, if you know what I mean), but it's all the same open-source hardware.

## Further watching

{% include posts/figure.html type="iframe" src="https://www.youtube.com/embed/29A2TXtmSLI" %}

{% include posts/figure.html type="iframe" src="https://www.youtube.com/embed/aL5P8sHz_Uk" %}
