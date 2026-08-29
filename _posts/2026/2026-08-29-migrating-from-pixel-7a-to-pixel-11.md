---
title: Migrating from Pixel 7a to Pixel 11
comments_issue: 167
tags: [android, pixel, phones]
---

Setting up a new phone always takes longer than it should, usually with at least one app or account causing grief along the way. This one didn't, which felt almost suspicious.

<!-- more -->

I'd been using a Pixel 7a for the past couple of years and picked up a Pixel 11 as my next daily driver. The 7a is still a solid phone. No complaints that would have forced an upgrade, and it's got security updates from Google running through May 2028. But a contract renewal came around with the 11 at no extra monthly cost, plus an offer on Pixel Buds 2 Pro for £1 in a couple of weeks. Hard to turn down.

The setup started awkwardly. The Pixel 11 was only connecting to my router's 2.4GHz WiFi and complaining the connection was too slow to proceed. The fix turned out to be disabling smart networking on the router, properly separating 2.4GHz WiFi from 5GHz WiFi so the phone could connect to the faster one.

Ironically, the WiFi connection only needed to be stable long enough to initiate the transfer. Once past that handshake, I plugged a USB-C cable directly between the two phones and let it copy the 50-odd GB of data that way. Faster and more reliable, and slightly at odds with the wireless-first impression Google's setup process gives.

After the bulk transfer, the usual checklist.

- **WhatsApp** - backed up to Google Drive on the old phone, restored on the new one.
- **[Bitwarden](https://bitwarden.com)** - logged back in, everything there.
- **[Aegis](https://getaegis.app)** - exported the encrypted vault from the old phone, imported on the new one. The one step where it pays to be methodical before wiping anything.
- **Banking apps** - each one needed re-verifying individually, no way around it.

Annoyingly, none of the Chrome PWAs I'd installed carried over, so I had to reinstall them one by one.

I was mildly anxious about my active [Freestyle Libre 2](https://www.freestylelibre.co.uk/) sensor going into this. Pairing a new phone mid-session felt like it could go wrong. In practice it paired without issue and the sensor transmitted the last 8 hours of data just fine. **The one casualty was three months of historical data, which doesn't migrate to a new device.** It's still accessible via [LibreView](https://www.libreview.com/) online, so nothing's actually lost, but I'd have liked to know that before I started rather than after.

The fiddliest part of the whole process was [Microsoft Authenticator](https://www.microsoft.com/en-us/security/mobile-authenticator-app) for my work accounts. Unlike Aegis, which lets me export and import my own encrypted vault, Microsoft Authenticator ties accounts to the device. The migration path is to log into each work account from a trusted device (my work laptop, in this case) and pair the new phone as the authenticator from there. The odd wrinkle: **it wanted me to sign into a personal Microsoft account before it would attempt to sync anything across.**

Android 17 itself was nothing new, I'd already been running it on the 7a. The 11 pushes Gemini a lot harder though; it's baked into search, the assistant, even a few of the system menus. I ended up disabling a handful of built-in apps I know I'm never going to use, just to get back to something closer to how I had the 7a set up.

Once the software side was sorted, the hardware side was easy. I'd used a [Tocol case](https://www.amazon.co.uk/dp/B0H6MHP83Z) on the 7a and been happy enough with it to buy their Pixel 11 version straight away. It's a high-quality case that passes MagSafe through without any issues. The main use is a magnetic bank card holder on the back, with the occasional appearance of a [Hidizs AP30](/post/hidizs-ap30-music-boy/) music player stuck to it like some kind of audio barnacle.

For the [screen protector](https://www.amazon.co.uk/dp/B0H5CJ1P7X) I went with Tocol again, and it's the first one I've applied that came out completely bubble-free. The application method is different from the usual peel-and-pray approach, and it actually works as advertised.

Plenty of faffing along the way, but nothing that properly broke. Migrating to a new Android phone has quietly become a fairly painless thing to do.
