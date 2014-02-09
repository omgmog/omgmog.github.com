---
layout: post
title: "Installing Arch Linux ARM on the HP Chromebook 11"
---

I concluded in my [previous post]({% post_url 2013-11-09-hands-on-with-the-hp-chromebook-11 %}) about the HP Chromebook 11 that it's a good device for casually browsing the internet, but it's no replacement for a regular laptop or desktop for getting stuff done.

![](http://f.cl.ly/items/3N3k0y3o2O0A0e2f2R1D/HP-Chromebook-11-ports-new_thumb.jpg)

Since that post I've not used the Chromebook very much, so with a vacant weekend I've decided to blow the dust off of the Chromebook and try to squeeze some more functionality out of it.

<!-- more -->

## Enter Arch Linux for ARM.

It's all very well and good installing a `chroot` to use a regular Linux distribution side-by-side with Chrome OS, but I couldn't help feeling like I wasn't getting the best performance out of the device. Not to mention, the volatility of having the `chroot` located on the internal memory of the Chromebook meant it's very easy to accidentally lose the whole setup.

Eventually I'd like to remove Chrome OS from the Chromebook altogether, and get a full regular distribution loaded on the Chromebook. For now though, I'll settle on having Arch on a bootable USB stick.

The HP Chromebook 11 is quite similar to the Samsung Chromebook, and the steps to install Arch to a USB stick for the Samsung can be followed pretty much for the HP, with a couple of changes towards the end of the process.

I've put together a script to automate this process on the HP Chromebook 11.

## Setting up your Arch ARM USB stick for your HP Chromebook 11

Put your HP Chromebook 11 in to Developer mode

```
1. Hold esc + refresh during boot
2. Press ctrl + d when at the warning screen

Your Chromebook will be wiped and developer mode enabled.

Each time you boot, press ctrl + d to bypass the warning.
```

Enable booting from USB sticks

```
Enter crosh (ctrl + alt + t)

shell
sudo su -
crossystem dev_boot_usb=1 dev_boot_signed_only=0
reboot
```

Next time you boot, you will need to open Crosh again, become a super user, and put yourself in to a writable directory

```
shell
sudo su -
cd /home/chronos/user/Downloads
```

Then insert your USB stick and download my `install.sh`

```
wget https://raw2.github.com/omgmog/archarm-usb-hp-chromebook-11/master/installer.sh
sh installer.sh "/dev/sda" # where /dev/sda is your USB stick
```

The installer will prompt you to press `[enter]` to continue at parts, so that you know what's going on.

When it's all finished, providing nothing complained, you should now have a USB stick with Arch installed on it, that you can boot on your Chromebook. To boot the USB stick, you will need to reboot your Chromebook, and press `ctrl + u` at the warning screen.

Once you're there, you can do the following to join your Wifi network:

```
wifi-menu mlan0
```

And then you can do what you like. If you want to have a GUI and working sound, trackpad, etc. do the following:

```
wget https://raw2.github.com/omgmog/archarm-usb-hp-chromebook-11/master/post-install.sh
sh post-install.sh
```

Now, as you don't want to be running everything as `root`, you can add a user with `useradd`, switch to the user then to make `Xorg` use the `Mate` desktop that we installed do the following:

```
echo "exec mame-session" > ~/.xinitrc
```

Now you can start Xorg with the `startx` command.

If you want `Xorg` to start automatically when you boot, you can install a login manager such as `lightdm`:

```
pacman -S lightdm lightdm-gtk2-greeter
systemctl enable lightdm
```

## Doing real work on the HP Chromebook 11

Now that you've got Arch installed you can start using the Chromebook to do some real work. I use `Geany` as my text editor, have `git`, `ruby`, `gem`, `jekyll` and many other important applications installed.

I authored this blog post from Arch on my Chromebook infact!


Let me know if you have any problems, or if you can improve the process in any way.

- [Arch ARM HP Chromebook 11 installer on GitHub](https://github.com/omgmog/archarm-usb-hp-chromebook-11/)
