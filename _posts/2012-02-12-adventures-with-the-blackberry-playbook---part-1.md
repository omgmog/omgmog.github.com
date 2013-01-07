---
layout: post
title: "Adventures with the Blackberry Playbook   Part 1"
tags: ["geekery", "gadgets", "software", "hardware", "projects", "blog", "consumerism"]
---
I recently acquired a Blackberry Playbook, while [attending the jQuery UK conference](/post/jquery-uk-conference-2012/). Having owned a couple of tablets in the past two years (including an [Archos 101it](http://www.archos.com/products/ta/archos_101it/specs.html?country=us&lang=en) and more recently a [HP Touchpad](http://h41112.www4.hp.com/promo/webos/uk/en/tablet/touchpad.html)), I was interested in seeing what RIM have brought to the table, and how the Blackberry OS differs from Android and WebOS.

I found the Archos 101it to not be a nice tablet -- or rather, it provided the most basic Android support, with very little room for improvement by custom ROM makers. Add to this the fact that the hardware wasn't very good, with a terrible touch screen, a really flimsy kick stand and a badly earthed power connection (instead of using the already present micro-USB port), and the slightly-higher-than-justifiable price point -- the whole experience was terrible, and it's easy to see why these early Android tablets had a hard time breaking the market.

The HP Touchpad on the other hand has been a nice one. I had the fortune of picking my 32gb HP Touchpad up during the firesale, while most people I know struggled to get hold of one. I wasn't particularly looking for a tablet at the time, but the HP Touchpad soon proved to be useful as an on-the-go internet device while I holidayed in Prague and Vienna last September.

The HP Touchpad comes with WebOS as its platform of choice, which was perfectly fine for me while I didn't have the time to play around with hacking the HP Touchpad, but when I found myself with some free time I started looking to install Android on the tablet. It's fairly straight forward to load Android on the HP Touchpad, both version 2.3 (Gingerbread) and more recently 4.0 (Ice Cream Sandwich). 

Now, to the Blackberry Playbook. It would seem this poor tablet is in a tough place -- with Blackberry being renowned for their physical-keyboard driven phones (in my opinion paling in comparison to Android + touchscreen), another contender into the smart-devices market would mean for most people that they've got to manage their app purchases for three or more platforms, with three or more different accounts. 

Having already abandoned my iOS purchases in 2010 (after ditching my iPod Touch), and switching religiously over to Android (for my HTC Desire and momentarily the Archos 101it), with a slight glance in to the world of the WebOS purchases, I'm not prepared to further fragment my purchases by buying apps on the Blackberry 'App World'.

So what can I do?

Well it turns out, with the upcoming (currently in beta) Blackberry OS 2.0 has support for running _some_ Android applications -- through a built in [Android application layer](https://bdsc.webapps.blackberry.com/android/) (which seems like a virtual machine), or by converting the Android .apk files to .bar files, and then side-loading them on to the Playbook (more on that later...).

After researching what I need to do to get this Android support on my Playbook, it turns out, being a Mac user, I'm in a tough position. The community seems to be geared around creating Windows applications and batch files to automate rooting/jailbreaking the Playbook, and only relatively recently have Mac versions of the rooting software become available. The tool to use to root the Playbook is (ammusingly) called [Dingleberry](http://dingleberry.it). The steps for setting up Dingleberry on your Mac are below:

1. Setup the Blackberry on your Mac (Install the Blackberry Desktop software, add the RIM Network device for network-over-USB)
2. Download the [Dingleberry application](http://dingleberry.it)
3. Put your Playbook in to Developer mode
4. Set your device password to 'playbook' (To make further steps easier. This can be unset/reset later)
5. Connect your Playbook to your Mac by USB
6. On Dingleberry, ensure that your Playbook is connected
![Screenshot of connected Playbook](http://f.cl.ly/items/1G18240b1N2z352O3I0i/Screen%20Shot%202012-02-12%20at%2022.00.48.png)
7. Select 'Firmware', and then '2.0.0.4869' and 'Full OS', then press 'Download'. (This will take a little while as it's about 400mb of updates)
8. After the download has finished, press 'Update' (This will take a little while, you can see the progress on your Playbook screen)
9. When the update process has finished and the Playbook has rebooted, press 'Continue'
10. Now press the 'Dingle' button (this is the magical part), you should then see the following
![Screenshot of 'Dingle' process](http://f.cl.ly/items/141V0e2y051l3b0R1K2t/Screen%20Shot%202012-02-12%20at%2022.32.50.png)
11. Press 'Continue' on your Playbook screen and on Dingleberry. Your device is now rooted.

That's all I've got to say for now. I'll save explaining how to deploy .bar apps to the newly rooted Playbook in a later post.