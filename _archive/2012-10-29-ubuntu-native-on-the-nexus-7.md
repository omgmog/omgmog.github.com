---
comments_issue: 67
title: Ubuntu (native) on the Nexus 7
---
Last week, a Ubuntu native installer for the Nexus 7 was released, along with [instructions on how to install Ubuntu on the Nexus 7](https://wiki.ubuntu.com/Nexus7/Installation). The plan is that the Nexus 7 will be the 'core' device that Canonical will build their tablet version of Ubuntu around. Right now, it's quite experimental -- the interface sees no tweaks for the tablet interface, beyond having an onscreen keyboard available.

<!-- more -->

The installation instructions I mentioned earlier are explicitly for installing Ubuntu on your Nexus 7 from an existing Ubuntu 12.10 install on your computer. Now, I don't have any Ubuntu installations kicking around, so I can't vouch for how well this process works, but there are plenty of videos around the internet already.

The installer just uses `fastboot` under a GUI, so we can get away with doing this from our Mac OS X terminal if we have the `.img` files required. Well, these can be acquired from [this site](http://hwe.ubuntu.com/uds-r/nexus7/), just select the appropriate storage size for your Nexus 7 (8GB or 16GB), and we'll be ready to begin.

## Here be dragons - Warning, this will wipe everything on your Nexus 7!

1. Install fastboot/adb if they're not already installed. You can use this simple script to do this - [https://github.com/teamblueridge/adb-fastboot-install](https://github.com/teamblueridge/adb-fastboot-install)
2. Connect your Nexus 7 by USB and boot it into fastboot mode (reboot holding `vol -` button)
3. If you haven't unlocked the bootloader on your Nexus 7 already, run `fastboot oem unlock`
4. In the terminal, locate your downloaded image files, and execute the following:

```bash
$ fastboot flash boot boot.img
$ fastboot erase userdata
$ fastboot flash userdata rootfs.img
$ fastboot reboot
```

After that's all finished, when your Nexus 7 boots it will take a couple of minutes to finalise the Ubuntu installation, so go make yourself some coffee or something. When you return, it should have loaded the Ubuntu Unity desktop. It's usable with just the touch screen, but the experience isn't great. You can join your Wifi network, install LXDE or XFCE or something, and log out and select a different desktop environment.

The password for the user account is `ubuntu`, though this wasn't mentioned anywhere

{% include posts/figure.html src="ubuntu-ss.jpg" %}{:.massive.center}

## But what about going back to Android?!

I didn't keep Ubuntu on my Nexus 7 for very long. It's not currently a great tablet experience, so here are the steps to reload Android on there:

1. Download the `Android 4.1.2` image for the Nexus 7 - [https://dl.google.com/dl/android/aosp/nakasi-jzo54k-factory-973f190e.tgz](https://dl.google.com/dl/android/aosp/nakasi-jzo54k-factory-973f190e.tgz)
2. Untar the file with `tar -zxvf nakasi-jzo54k-factory-973f190e.tgz`
3. Open a terminal and `cd` to the extracted directory
4. Run the `flash-all.sh` file: `sh ./flash-all.sh`
5. (Optional) reflash a custom recovery `fastboot flash recovery <custom-recovery>.img`

I don't think Ubuntu is a good fit for the Nexus 7 at the moment. If a nice tablet interface for Ubuntu is released it might be better, but in the mean time you're probably better off keeping Android. There isn't much else to say.
