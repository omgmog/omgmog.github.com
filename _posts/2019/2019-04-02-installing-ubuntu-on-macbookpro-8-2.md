---
title: Installing Ubuntu on MacBookPro 8,2
tags: [linux, ubuntu, macbook]
archived: true
---

This MacbookPro8,2 has been through a lot. [I did some small upgrades back in 2012](https://blog.omgmog.net/post/upgrading-my-macbook-pro/), then in 2014 it experienced some issues with the dedicated GPU that many Macbook's of this model experienced.

For a while I managed to keep it running my forcefully disabling the dedicated GPU with some EFI trickery, and running some form of Linux for a while (I think I kept it going with [Elementary OS](https://elementary.io/)).

In 2016 (or there abouts) I took the drastic measure of _baking_ the mainboard in the oven to fix the dedicated GPU issue (by reflowing/reballing the solder), reinstalled macOS and then (besides a short stint as my wife's computer) the MacBookPro8,2 ended up back on a shelf.

until today! out of boredom I've decided to revisit this old beast.

## Installing Ubuntu on my old early-2011 MacBookPro8,2

1. Install rEFInd - https://www.rodsbooks.com/refind/
2. Create a Ubuntu USB (I used Rufus on my Windows PC, with the Ubuntu 18.04.2 iso)
3. Boot the iso (hold `alt` key to get the rEFInd menu, select the USB)

And this is where the first headache is. To make Ubuntu play nicely, you need to edit the boot commands so that certain chipset features are poked and enabled. At the Ubuntu boot menu, select the option you want (e.g. Live installer) and press `e`, which will bring you to the editor.

First disable the AMD graphics card by adding the following lines after set `gfxpayload=keep`

```
outb 0x728 1
outb 0x710 2
outb 0x740 2
outb 0x750 0
```

Next add the following after `quiet splash` on the boot command:

```
i915.lvds_channel_mode=2 i915.modeset=1 i915.lvds_use_ssc=0
```

Then press `F10` to boot, and you should successfully boot to the Ubuntu installer.

From here you can install Ubuntu. You can delete the macOS partitions if you like, just make sure you keep the ~200mb EFI partition, and create your Ubuntu partitions after that.

You'll need to do this again for your first boot after you've got Ubuntu installed, and then you can edit your Grub file permenantly using [grub-customizer](http://tipsonubuntu.com/2018/03/11/install-grub-customizer-ubuntu-18-04-lts/) or something.
