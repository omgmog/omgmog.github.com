---
title: Installing Arch Linux ARM on the HP Chromebook 11
comments_issue: 95
---

I concluded in my [previous post](/post/hands-on-with-the-hp-chromebook-11/) about the HP Chromebook 11 that it's a good device for casually browsing the internet, but it's no replacement for a regular laptop or desktop for getting stuff done.

{% include posts/figure.html src="IMG_20140210_150652.jpg" %}{:.massive.center}

Since that post I've not used the Chromebook very much, so with a vacant weekend I've decided to blow the dust off of the Chromebook and try to squeeze some more functionality out of it.

<!-- more -->

## Enter Arch Linux for ARM.

This guide will take you through installing Arch Linux ARM on a USB stick that can be booted by your HP Chromebook 11. I'll also explain how to go a step further and remove Chrome OS from your HP Chromebook 11 and install Arch Linux ARM directly on the eMMC (internal memory).

### Prerequisits
- HP Chromebook 11
- USB Stick (2GB should be enough)
- Some time (an hour or so)

### Pre-install steps
First of all, your Chromebook must be in Developer Mode. To do this, either boot while holding `esc` + `refresh` + `power`, or press those three keys while the Chromebook is booted.

When the device reboots it will present you with a scary message, where you should then press `ctrl` + `D` to enable Developer mode. It'll take a couple of minutes to download and install the Developer Mode files, but when it's done and it reboots, you can then boot Chrome OS by again pressing `ctrl` + `D` at the boot screen.

Next, you need to join your Wifi network, and then you can choose to 'browse as guest' or sign in to your Google profile. If you're going to be installing to the eMMC later, it'll be easier to just browse as guest.

When you're logged in to Chrome, press `ctrl` + `alt` + `T` to open the `crosh` terminal. Here you can become root and enable USB booting:

```bash
$ shell
$ sudo su -
$ crossystem dev_boot_usb=1 dev_boot_signed_only=0
```

### Using my `install.sh` to install Arch
Insert your USB stick, and dismiss any of the File Browser windows that open. Now, in your terminal execute the following commands, where `/dev/sda` is your USB stick:

```bash
$ cd /home/root
$ wget https://raw.githubusercontent.com/omgmog/archarm-usb-hp-chromebook-11/master/install.sh
$ sh install.sh /dev/sda
```

You'll be prompted through the process, it shouldn't take very long.

After the `install.sh` has finished creating the USB stick, you can reboot your Chromebook, and then press `ctrl` + `U` at the boot screen to boot from USB.

Login as `root`, with no password. You can turn on Wifi and connect to your Wifi network using the following:

```bash
$ wifi-menu mlan0
```

If you want to finish here, I would suggest using my `post-install.sh` to install Mate and lightdm, then get on with enjoying your new Arch install.

```bash
$ pacman -S wget
$ wget https://raw2.github.com/omgmog/archarm-usb-hp-chromebook-11/master/post-install.sh
$ sh post-install.sh
```

If you're feeling hardcore, why stop here? Let's install to the eMMC!

### Installing Arch to the eMMC on the Chromebook

Just like with installing to the USB stick, you need to download the `install.sh` and then invoke it, but this time specify `/dev/mmcblk0`

```bash
$ pacman -S wget
$ wget https://raw2.github.com/omgmog/archarm-usb-hp-chromebook-11/master/install.sh
$ sh install.sh /dev/mmcblk0
```

The installer will set up the partitions as before, install Arch, and then configure the Kernel so that your Chromebook can boot in to Arch.

Regarding the modification of the PKGBUILD for `trousers`:

This is the only package you need to modify. When prompted, press `y` to edit, open in `nano` or your preferred text editor, find the line that reads:

```bash
arch=('i686' 'x86_64')
```

and replace it with

```bash
arch=('armv7h')
```

## Doing real work on the HP Chromebook 11

{% include posts/figure.html src="IMG_20140211_130139.jpg" %}{:.massive}

Now that you've got Arch installed you can start using the Chromebook to do some real work. I use `Geany` as my text editor, have `git`, `ruby`, `gem`, `jekyll` and many other important applications installed.

I even authored this blog post from Arch on my Chromebook!

Let me know if you have any problems, or if you can improve the process in any way.

- [Arch ARM HP Chromebook 11 installer on GitHub](https://github.com/omgmog/archarm-usb-hp-chromebook-11/)
