---
title: "The Chuwi Vi10 Plus Windows and Android Tablet"
---

{% include posts/figure.html src="2016-09-08/chuwivi10plus.png" %}{:.massive}

I've been on the hunt for a 10" tablet for a couple of months now. Besides Google's Pixel C, there isn't much choice in this area (ignoring the iPad). There are a bunch of options for cheap Atom-based Android/Windows tablets on Gearbest/Aliexpress/etc. I decided to buy a [Chuwi Vi10 Plus on Gearbest](http://www.gearbest.com/tablet-pcs/pp_413825.html). For less than £120 what could I lose?

<!-- more -->

First thing's first, the specs:

- CPU: Intel Atom "Cherry Trail" x5 Z8300 - 1.44GHz-1.84GHz ([Intel Ark link](http://ark.intel.com/products/87383/Intel-Atom-x5-Z8300-Processor-2M-Cache-up-to-1_84-GHz?q=Z8300))
- RAM: 2GB
- Storage: 32GB internal, Micro SD up to 128GB
- Display: 10.8" touch screen, 1920x1280
- Ports: USB-C, Micro USB, Micro HDMI
- Connectivity: Wifi 802.11b/g/n, Bluetooth
- Camera: Front 2MP, Rear 2MP
- Battery: 8400mAh

The Chuwi Vi10 Plus is also available in a 4GB/64GB configuration.

There are countless videos and galleries online showing how the Chuwi Vi10 Plus looks, you can find a couple at the end of this post.

Besides the Chuwi Vi10 Plus, I also bought their [Keyboard Case](http://www.gearbest.com/tablet-accessories/pp_424390.html) and [Active Stylus](http://www.gearbest.com/tablet-accessories/pp_435776.html).

The keyboard case connects via [Pogo Pin](https://en.wikipedia.org/wiki/Pogo_pin) connector and some strong magnets. It's good for working with the Chuwi Vi10 Plus on a desk, small table, or even your lap.

{% include posts/figure.html src="2016-09-08/chuwikeyboard.png" %}{:.massive}

## Remixing the OS

This version of the Chuwi Vi10 Plus came with [Remix OS 2.0](http://www.jide.com/remixos) pre-installed. Remix OS is essentially Android 5.1 with a more desktop-oriented skin on top. I've played with it in the past on laptops and the Pine64, so there wasn't much new to discover here.

I bought the Vi10 Plus with the intention of removing the pre-installed Remix OS and installing Windows. Chuwi have released a BIOS update to allow dual booting of Windows 10 64bit and Android 5.1, so I installed the BIOS update as soon as I got the Vi10 Plus home.

On the Chuwi forums there are [instructions for installing Windows](http://forum.chuwi.com/thread-2254-1-1.html) using their [provided image](http://forum.chuwi.com/thread-2116-1-1.html), which work pretty much. Chuwi provide a Windows PE-based installer to install Windows 10 Home 64bit from a USB stick. This isn't an activated copy of Windows 10 however, but it can be upgraded with the latest "Anniversary update" from Microsoft, and activated with a purchased license.

After installing Windows 10 with the Chuwi image, there are roughly 15GB of space left on the 32GB eMMC. If you try to install the Windows 10 Anniversary update using Windows Update you'll probably find that you can't as it requires 20GB of space to do the install.

I found that you can get around this by using Microsoft's Media Creation Tool to create a USB installer, and then upgrade using that.

I'm not a fan of pre-configured or OEM-customised versions of Windows, so I opted to do a "Reset PC" on the install after upgrading. This restores Windows to a clean state, and I found that it actually freed up an additional 5GB of space.

If you want a different version of Windows, you can create your own USB installer and just do a clean install with that.

I've created a repository with some notes for installing Windows on the Chuwi Vi10 Plus here: [https://github.com/omgmog/chuwi-vi10-plus/blob/master/windows.md](https://github.com/omgmog/chuwi-vi10-plus/blob/master/windows.md)

While messing around with installing Windows 10, I also gave Ubuntu Linux a go. It installed with no problem. I used [unetbootin](https://unetbootin.github.io/) to create a bootable USB stick, and it booted without issue. The only caveat being that you need to set the `nomodeset` flag in Grub to boot. Touch screen, sound and WiFi didn't work but I successfully had a USB WiFi stick working through USB OTG.

## Getting in touch with Windows 10

I've used Windows 10 with touch screen devices in quite a limited capacity before now. My wife has a Lenovo laptop that features a touch screen, and I always felt that in that form-factor a touch screen is pretty useless. Having said that, she seems to go between touch screen and trackpad quite naturally.

On a tablet device it's a completely different experience. The touch screen feels like a much more natural way to use Windows. Even when using the keyboard case, I find myself opting to prod the screen rather than awkwardly moving a cursor around with the trackpad. It could just be that I'm spoiled by having used Apple trackpads for the past 5 or so years, but the trackpad on the keyboard case isn't great.

This isn't a unique problem to the keyboard case -- trackpads on Windows computers are generally terrible in comparison to Apple computers, and with Windows 10 forcing it's gestures, I find myself triggering the gesture to unmaximise a screen more than I would like.

As I mentioned earlier, I also bought an active stylus. I was a bit sceptical of the need for a stylus that has to be charged by Micro USB, but having used it now for a couple of days it's a great way to interact with the tablet. [Windows 10's "Ink"](https://blogs.windows.com/windowsexperience/2016/04/22/a-closer-look-at-windows-ink/) works nicely with the stylus, as do a number of drawing/sketching apps. Photoshop doesn't recognise the stylus at all -- I believe this is something to do with how Windows identifies Ink vs regular mouse input.

## Final thoughts

So as I said I've been on the hunt for a 10" tablet for a while now. Android is pretty much unusable in this form factor.

The Chuwi Vi10 Plus with Windows 10 is a very good compromise. It can run the same software as my Windows 10 desktop, so doing "real work" using the tablet is not a problem.

The cameras on the Chuwi Vi10 Plus are complete trash, and I've have preferred it if there was just one nice camera, or no cameras.

The 8400mAh battery provides over 6 hours of power, so this is a nice portable alternative to my 13" Retina Macbook Pro.

In addition to the keyboard case, I bought a more general [AMNIE 11" case from Amazon](http://amzn.to/2c1yvX4) to house the tablet and all of the accoutrements.

## Useful links

- [Official Chuwi Forums](http://forum.chuwi.com/)
- [TechTablets Chuwi Vi10 Forum](http://techtablets.com/forum/forums/chuwi/chuwi-vi10-dual-os-discussion/)

## Reviews from others

Here are a couple of reviews and videos:

- ["Chuwi Vi10 Plus" on TechTablets](http://techtablets.com/chuwi-vi10-plus/)
- ["Chuwi Vi10 Plus review- The ultimate 2-in-1 device?!" on XiaomiToday](http://www.xiaomitoday.com/chuwi-vi10-plus-ultimate-2-in-1-device/)


{% assign iframe_url = "https://www.youtube.com/embed/fGSa1hhzbNo" %}
{% include posts/figure.html type="iframe" %}

{% assign iframe_url = "https://www.youtube.com/embed/D6D_AAnfSoY" %}
{% include posts/figure.html type="iframe" %}

{% assign iframe_url = "https://www.youtube.com/embed/cwRGrueyW4o" %}
{% include posts/figure.html type="iframe" %}

{% assign iframe_url = "https://www.youtube.com/embed/GBeqcxfpLGI" %}
{% include posts/figure.html type="iframe" %}

{% assign iframe_url = "https://www.youtube.com/embed/kj33FpYG3N0" %}
{% include posts/figure.html type="iframe" %}









