---
comments_issue: 69
title: Upgrading my Macbook Pro
---
I've had my Macbook Pro for about a year now. It's the [Early-2011 15" bells and whistles model](http://www.everymac.com/systems/apple/macbook_pro/stats/macbook-pro-core-i7-2.2-15-early-2011-unibody-thunderbolt-specs.html). The specs (the bits we care about, if you can't be bothered to click the link) are as follows:

- CPU: 2.2ghz Core i7
- RAM: 4gb (2x2gb) DDR3
- HDD: 750gb

<!-- more -->

At the time of purchasing the Mac this spec was fine, it was a simpler time, Mac OS had good memory management, I could multi-task to my hearts content. And then I upgraded to Lion. Lion doesn't perform well with less than 8gb of RAM available so I didn't stick with Lion for very long.

I've been toying with the idea of upgrading the Mac to have an SSD for the past couple of months, and recently I decided to do this along with upgrading the RAM to 8gb. I opted for removing the internal Superdrive so that I could install the SSD and keep the old HDD as a secondary internal drive.

To do this upgrade I had to buy a couple of things:

- [Superdrive bay to 2.5" HDD adapter ~£6.00](http://www.suntekstore.co.uk/product-10010809-25_inch_the_second_sata_hdd_ssd_caddy_for_apple_macbook.html)
- [External Superdrive USB enclosure ~£12.00](http://cgi.ebay.co.uk/ws/eBayISAPI.dll?ViewItem&item=320817912050)
- [Mushkin Chronos 120gb SSD ~£95](http://www.aria.co.uk/Products/Components/Solid+State+Drives/Mushkin+Chronos+120GB+2.5%22+SATA-III+Solid+State+Hard+Drive+?productId=45660)
- [8gb (2x4gb) of Corsair PC3-10666C9 RAM ~£35](http://www.aria.co.uk/Products/Components/Memory+-+RAM/SODIMM+-+Laptops+%2F+Compact+PC/SODIMM+DDR3/8GB+Corsair+Value+Select+%282x4GB%29+DDR3+PC3-10666C9+1333MHz+1.5v+SODIMM+Memory+-+CMSO8GX3M2A1333C9+?productId=47381)

## Pre-upgrade system information
{% include posts/figure.html src="Screen%20shot%202012-03-30%20at%2018.13.30.png" %}{:.massive}
{% include posts/figure.html src="Screen%20shot%202012-03-30%20at%2018.14.01.png" %}{:.massive}
{% include posts/figure.html src="Screen%20shot%202012-03-30%20at%2018.14.28.png" %}{:.massive}

## Post-upgrade system information
{% include posts/figure.html src="Screen%20Shot%202012-03-31%20at%2014.55.49.png" %}{:.massive}
{% include posts/figure.html src="Screen%20Shot%202012-03-31%20at%2014.56.23.png" %}{:.massive}
{% include posts/figure.html src="Screen%20Shot%202012-03-31%20at%2014.56.27.png" %}{:.massive}


## Opening up the Macbook Pro
There are guides all over the place for opening the Macbook Pro. I followed [one from iFixit](http://www.ifixit.com/Device/MacBook_Pro_15%22_Unibody_Early_2011#guideList). The only tools you need are a Torx-6 screwdriver and a small Phillips screwdriver.

Once opened, I had to do the following things:

- remove the Superdrive
- install the new SSD in the Superdrive bay adapter
- install the Superdrive bay adapter in the Superdrive bay
- install the new RAM

The whole thing took about an hour to complete, once it was done I booted the Mac, so that I could prepare for the new Lion install.

Besides the hardware installed inside the Mac, I also installed the Superdrive in its new USB enclosure. This was really simple, and it works very nicely.

## Installing Lion sans-Superdrive
Now, even though I bought an enclosure for the Superdrive I removed, I didn't want to install from a DVD (as I had no blank DVDs free). I set up a Lion install USB stick using [this guide from Lifehacker](http://lifehacker.com/5823096/how-to-burn-your-own-lion-install-dvd-or-flash-drive). It's quite simple:

1. Download Lion on the App Store.
2. "Show Package Contents" on the "Install Mac OS X Lion.app".
3. Find the "InstallESD.dmg" file.
4. Restore this dmg to a USB stick. (I used a 32gb stick, but you could probably use a stick as small as 4gb)

After the Lion USB installer was created, I booted it by selecting the boot device from System Preferences, and then proceeded to install Lion on the new SSD drive.

The install took less than 20 minutes, and after booting it prompted me to transfer my old Applications and profiles from my Snow Leopard install on the old HDD.

## Closing notes
The new SSD is insanely fast. Lion cold boots in less than 10 seconds. Photoshop opens in less than 4 seconds. I'm really amazed by it. Now that I've got 8gb of ram in there, I can use the Mac as I had liked, with oodles of browser tabs, Photoshop, and Sublime Text open.

I changed quite a few factors with this upgrade:

- from Snow Leopard to Lion
- from 4gb to 8gb of RAM
- from HDD to SSD

The upgrade costs less than £150 &mdash; the increase in speed/performance is worth infinitely more than that.

Here are some Geekbench scores comparing before/after the upgrade: [http://browse.geekbench.ca/geekbench2/compare/594952/594951](http://browse.geekbench.ca/geekbench2/compare/594952/594951)

Yes, I've named the new SSD "Gonzales" because it's so speedy!
