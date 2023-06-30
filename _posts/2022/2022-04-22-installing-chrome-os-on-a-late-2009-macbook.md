---
title: Installing Chrome OS on a Late 2009 MacBook
tags: [tech]
comments_issue: 115
syndication:
  - https://indieweb.social/@omgmog/108214705297975912
---

I've got an old [2009 MacBook 6,1 (A1342)](https://everymac.com/systems/apple/macbook/specs/macbook-core-2-duo-2.26-white-13-polycarbonate-unibody-late-2009-specs.html) kicking about in my office that I've been playing with on and off lately.

<!-- more -->

{% include posts/figure.html src="2022-04/a1342.png" %}{:.center}

The specs of the device are:

|**CPU**| Core 2 Duo (2.26Ghz)|
|**RAM**| 8GB (Upgraded from 2GB)|
|**GPU**| Nvidia GeForce 9400M (256MB shared)|
|**Storage**| 240GB SSD (Upgraded from 250GB 5400RPM HDD)|

The most recent version of macOS supported on this MacBook is High Sierra (10.13) from 2017, though I've been running Ubuntu Linux on it recently as macOS feels a bit slow these days (even with an SSD and 8GB RAM upgrade!).

I decided to try Chrome OS on the MacBook using the [Neverware CloudReady](https://www.neverware.com/freedownload#intro-text) installer.

CloudReady is described as:

> [The] easy way to transform your old PC or Mac into a high-performing Chrome device, free of charge.

It's basically Chrome OS for non-Chromebook devices. A great way to turn old/slower laptops in to capable internet devices for your kids or relatives to use.

Their offering is so good that Google actually [absorbed the company](https://cloudreadykb.neverware.com/s/article/Neverware-is-now-part-of-Google-FAQ) in December 2020.

The installation process is really simple:

1. Download the CloudReady USB writer app
2. Write the image to a USB drive
3. Boot the USB on the target computer
4. Either use it like this as a live distribution, or install it to the internal drive of the computer

{% include posts/figure.html src="2022-04/image-burner.png" %}{:.center}

Unlike on a real Chromebook device you get the Chromium variant of Chrome OS. It works just fine with a Google account, and syncs and all of that jazz too, and all of the hardware seems to be fully supported.

{% include posts/figure.html src="2022-04/Screenshot-2022-04-22-16-49-38.png" %}{:.center}

I've been comparing CloudReady to the official Chrome OS on my Lenovo Ideapad Duet Chromebook. It's missing some features that I use a lot on the Lenovo, such as Android app support. I had some problems with the installer for the  Linux development environment, but besides that it all seems to work fine.

{% include posts/figure.html src="2022-04/Screenshot-2022-04-22-16-50-18.png" %}{:.center}

Unfortunately the MacBook 6,1 will only be [supported by CloudReady until August 2022](https://cloudreadykb.neverware.com/s/article/Reference-List-of-Decertified-Models) so who knows what will happen after that point? I'll probably install something else on this MacBook before then.
