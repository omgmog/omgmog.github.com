---

title: "The HP Chromebook 11"
---

I bought a [HP Chromebook 11](http://www.google.com/intl/en/chrome/devices/hp-chromebook-11/#hp-cb-11-everyday&tab=colour-blue) as soon as I possibly could when it was announced. I've had a couple of weeks to play with it now, so here are my thoughts...

<!-- more -->

## The HP Chromebook 11

{% include posts/figure.html src="Image%202013.11.09%2012_02_22.jpeg" %}{:.massive.center}

This is the latest in the range of Chromebooks to be released. Finally the Chromebooks are getting to the point where they're cheap enough to buy as a second or third computer, and they don't look or feel cheap.

For £229 you get the following:

- 11.6" screen (resolution is 1366x768)
- 2GB ram
- 16GB SSD storage
- Exynos 5250 ARM Cpu
- 2 USB ports
- WiFi a/b/g/n
- Bluetooth 4.0

This is quite a similar spec to most Android tablets these days, except that it has a physical keyboard and no touch screen.

The Chromebook 11 weighs in at 1.04kg, so it's very light, and the 11" form factor means it's not too large to carry around, or just throw in to your bag on your way out.

{% include posts/figure.html src="Screen%20Shot%202013-11-09%20at%2016.42.17.png" %}{:.massive.center}

## Using the Chromebook in real life

As with any new gadget, the videos that are used to announce the Chromebook 11 make it look really fun, and possible to use the Chromebook in any situation.

{% assign iframe_url = "https://www.youtube.com/embed/xArQDa1j634" %}
{% include posts/figure.html type="iframe" %}

The first reality smack-in-the-face is that you need a WiFi connection to do anything with the Chromebook.

This isn't a problem if you're at home or work and you have a WiFi connection. When out and about you will find yourself relying on open networks, or mobile tethering.

I had no trouble hopping on to the omnipresent BTWiFi hotspots around Oxford, and logging in with my BT account, but I found that after a while if the signal was particularly weak the Chromebook would decide to forget that it was connected to Wifi, or even how to connect to WiFi.

## Performance

As a device that's designed to *just* run Google Chrome, it does that well. The Chromebook boots fast, and it's very easy to connect your Google account.

Viewing pages with lots of inline images will cause the Chromebook to lag a bit, but that's not an everyday use case.

The Chromebook handles YouTube videos fine, and can even handle Netflix. The only problem being that the battery won't last very long if you're streaming YouTube or Netflix for hours on end.

The Chromebook is advertised as having a 6 hour battery life. With some not too resource-intensive use that's pretty easy to hit. If you're looking at a lot of pictures/videos, or listening to music (the speakers are awesome btw!) then you might find that you get closer to 4 hours.

## Getting the most out of the Chromebook

Originally my reason for buying the Chromebook, besides "ooooo shiny!", was to have something small/light/smart-looking that Jenny could take to [Marmalade &amp; Jam](http://marmaladeandjam.co.uk) meetings.

Most of the time though, the Chromebook is used for any of the following internet-based activities:

- Looking at a recipe online while cooking
- Checking Facebook
- Checking email
- Browsing Reddit
- Editing Google documents
- Shopping on Amazon

All of which are mostly done in/around the house, or anywhere else that there's a good WiFi connection.

## Making the Chromebook do *more*

Now that I've talked about the *boring* aspects of the Chromebook, I'll get on to the most interesting: running a full Linux distribution on the Chromebook.

Within the first couple of hours of owning the HP Chromebook 11 I had switched it to developer mode so that I could get more potential out of this nice device.

The steps for enabling developer mode can be found on the [Chromium Project wiki](http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/hp-chromebook-11).

After that's done, and the Chromebook has wiped and rebooted itself, you can use a tool called `crouton` to install a Linux chroot.

- Download `crouton` from [https://github.com/dnschneid/crouton](https://github.com/dnschneid/crouton)
- Open the terminal (`ctrl`+`alt`+`t`)
- `cd` to your downloads directory and run the `crouton` script:

```bash
$ cd ~/Downloads
# this will output the help text
$ sh -e ./crouton
# this will install ubuntu 12.04 with xfce4
$ sh -e ./crouton -t xfce
```

After that's all done, you should be able to get in to your Linux chroot by typing `sudo startxfce4` (or whatever the installer tells you to do).

There are some caveats to running Linux on the ARM-powered Chromebook, such as the fact that you're limited to running applications that have armel/armhf builds available, but luckily there are lots of ARM applications available.

## Closing thoughts

Over-all the Chromebook is nice. If you keep telling yourself that it's not designed to replace your laptop, but rather it's just *another* device to browse the web from while sat on your sofa.

I've tried to do some *real* work on it using the Linux chroot, and it works alright (the Chromebook runs [jekyll](http://jekyllrb.com) and Git quite nicely, so it's a good blogging device).

The size/weight make it preferable over my Early 2011 Macbook Pro, especially for taking on trips where I've got one backpack that I'll be hauling around.
