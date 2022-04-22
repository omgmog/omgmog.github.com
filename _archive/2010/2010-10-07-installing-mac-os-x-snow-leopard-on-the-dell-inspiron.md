---
comments_issue: 82
title: Installing Mac OS X Snow Leopard on the Dell Inspiron 1525
---

_This is an update to my previous guide. I've since changed platform for my site &mdash; and even changed computers &mdash; but there is enough interest in this guide to warrant a re-write, so here we go._

I'm going to be walking you through installing Mac OS X Snow Leopard 10.6.4 on your Dell Inspiron 1525. The configuration of your Inspiron 1525 might differ from mine, but generally most of the hardware will be the same.

<!-- more -->

My hardware is as follows:

- Intel(R) Core(TM)2 Duo processor (2ghz, 2mb cache)
- 2048MB DDR2 SDRAM (667MHz, 10MB dedicated to onboard graphics)
- Intel Crestline Graphics (This is the GMA X3100, just like the Macbook)
- Sigmatel 9205 HD Audio
- Dell Wireless (Broadcom BCM4315, essentially an Airport card)

## Prerequisites
- Dell Inspiron 1525

This might apply to other Dell models, but I'm not here to support you if it doesn't work. If you want help, check out the InsanelyMac forums, or the OSx86 Wiki

- OS X Snow Leopard retail DVD

I'm not going to support installing with hacked/prepackaged non-Apple DVDs. There might be working methods for those, but it won't be covered here.

- Boot-132 CD ([from here](http://www.macyourpc.com/wp-content/uploads/2009/07/BootSLv3wifi.iso))
- A couple of hours of free time

A good install will take less than an hour, but you'll most likely want to tweak things after your install is done.

- Some patience

## Let's begin

1. Backup your files
2. Burn your Boot-132 CD
3. Setup BIOS settings
4. Boot the installer
5. Install
6. Post-installation configuration and finishing

## Backup your files

This is the most important step I guess. This install will wipe everything from the internal hard disk drive inside your Inspiron, so make sure you've backed up anything that you want to keep before continuing.

Most Inspirons come with a hard disk smaller than 500GB, so you could easily pick up a 500GB or greater sized external hard disk, and backup all of your stuff to that.

## Burn your Boot-132 CD

The Boot-132 CD is the best way to boot a retail Snow Leopard DVD on your Dell, it uses the Chameleon boot loader, a DSDT.aml and Kexts for the Inspiron 1525 hardware to allow the Snow Leopard DVD to boot.

I'm not going to walk you through burning an ISO to CD, but you can use Imgburn, Nero, Disk Utility, or any other ISO burning software.

I've done this using a CD-RW, CD-R and even a DVD, so you should have no problem finding some compatible disc to burn the ISO to.

{% include posts/figure.html src="Screen%20shot%202010-10-07%20at%2022.12.59.png" %}{:.massive}

Download the Boot-132 from macyourpc.com here - [http://www.macyourpc.com/wp-content/uploads/2009/07/BootSLv3wifi.iso](http://www.macyourpc.com/wp-content/uploads/2009/07/BootSLv3wifi.iso)

## Setup BIOS settings

For whatever reason, you may have your BIOS configured in a weird way. If you've currently got Windows XP on your Inspiron 1525, you might not have AHCI enabled for your hard disk drive.

Boot your Inspiron while pressing the F2 key repeatedly, until you are greeted by the BIOS menu.

First you will want to reset the BIOS to default settings, to do this, go to:

- **Maintenance**

  - Load Defaults = **Continue**

Below is a list of the important settings in the BIOS, which have worked for me, these should be the default settings:

- **Onboard Devices**

  - External USB ports = **Enabled**
  - Media Card and 1394 = **Enabled**
  - SATA Operation = **AHCI**
  - Module Bay Device = **Enabled**
  - Flash Cache Module = **Enabled**

- **Performance**

  - Multi Core Support = **Enabled**
  - Dynamic Acceleration = **Enabled**
  - SpeedStep Enable = **Enabled**

- **Power Management**

  - USB Wake Support = **Off**

- **POST Behaviour**

  - USB Emulation = **Enabled**

When you're finished here, press Esc to exit and choose **Save/Exit.**

## Boot the installer

After this is all setup, you can go on and insert the Boot-132 CD that you burned earlier, restart your Inspiron and press F12 for the boot menu, then select your DVD drive to boot. After a moment you should see the Chameleon menu.

Wait until the DVD drive stops spinning to make sure Chameleon has fully loaded, then eject your Boot-132 CD and insert the Snow Leopard DVD.

Press F5 and wait for Chameleon to finish refreshing the available bootable devices.

Select "**Mac OS X Install DVD**" and then type the following (this part is actully optional, and depends entirely on your hardware setup. If you've got the same CPU/RAM as me, this will work for you):

```
-v -x -f -legacy
```

You will see the text appear in the bottom-left corner of the screen. Once you've typed it, just press Enter, and wait for the DVD to finish loading.

These are boot flags, they tell Chameleon how to boot the Installer. You will also need to use these later, so I'll explain what they mean ([chameleon docs](http://forum.voodooprojects.org/index.php/topic,767.0.html)):

```
-verbose
-single user
-xsafe mode
-fboot without default configuration files

arch=x86_64 #force kernel into 64-bit mode
arch=i386 #force kernel into 32-bit mode
config=<file> #specifies where to look for a com.apple.Boot.plist file
cpus=1 #instructs the kernel to use x CPUs/cores

arch=i386: kernel: 32 bits | kexts: 32 bits | apps: 32/64 bits
arch=i386 -legacy: kernel: 32 bits | kexts: 32 bits | apps: 32 bits
arch=x86_64: kernel: 64 bits | kexts: 64 bits | apps: 32/64 bits
arch=x86_64 -legacy: kernel: 64 bits | kexts: 64 bits | apps: 32 bits
```

You will see lots of text scroll past on the screen, don't panic if it pauses for a little while.

After a minute or two the Snow Leopard installer should have booted.

## Install

The installer is pretty straightforward, so I don't think I need to go into too much detail here. The important things are the partitioning of your hard disk, and for speed of the install, removing packages.

## Partitioning

On the Menu Bar at the top of the screen click **Utilities** and then select **Disk Utility**.

In the window that opens, select your hard disk drive from the left pane, then on the right side click the **Partition** tab.

## IMPORTANT &mdash; MAKE SURE YOU HAVE SELECTED THE CORRECT HARD DRIVE, THE NEXT STEPS WILL ERASE ALL DATA FROM THE HARD DRIVE

Under **Volume Scheme:** select '1 Partition', or as many as you would like to have. For each partition, you will need to fill in the **Name:** field on the right, and select a format (**Mac OS Extended (Journaled)** is what you will need for the partition you're installing to)

Click the **Options&#8230;** button at the bottom of the window, and make sure **GUID Partition Table** is selected.

When you're done here, press the **Apply** button to begin partitioning. You can now close the Disk Utility when you are finished.

## Continuing with the installer

After you've finished partitioning, you will be taken back to the **Mac OS X Installer**. Click **Continue**, and then agree to the software license agreement.

On the next screen, select the hard drive you just formatted and click **Customize**. You can untick all of these extra options, unless you require extra languages/fonts/printer drivers. Not installing these will save loads of time.

When you're done deselecting packages you can press **Install**.

At this point all you can do is wait, so I suggest getting a coffee or something.

When the install has finished (and you've hopefully got a nice **Install Succeeded** message on your screen), turn off the Inspiron and put the Boot-132 CD back in to continue with the final part of the install.

## Post-installation configuration and finishing

When you boot the Boot-132 CD this time, you should see a nice Apple icon, with the name of your install hard drive below it.

Select this boot drive, and type in the following commands to boot:

```
-v -x
```

You'll get a screen filled with lines of text for a moment, but eventually you should be greeted by the post-installation screen, where you can set up your profile.

On the desktop you should see a **SL boot132** CD icon, double click this to view the contents of the CD, and then navigate to the **Post-Install** directory. In **Post-Install** you should find a **Read Me First** file &mdash; this will explain what everything is in this directory.

## Installing Chameleon

First thing we need to do is install the **Chameleon 2 RC3** boot loader, so you can boot the Inspiron without using the Boot-132 CD. Double click the **Chameleon 2 RC3** installer, and enter your password when prompted. 

Next, you need to copy the contents of the  **Extra** directory from **Post-Install** to the **Extra** directory on the root of your hard disk. To get to your hard disk, you can either select it on the left side of the **Finder** window that you have open, or in the **Menu Bar** at the top of the screen click **Go** and then **Computer**. 

Just paste the files from **Post-Install/Extra** into the **Extra** on your hard disk drive, and select to **Authenticate** when it asks you to.

## Installing additional kexts

The majority of your kexts (hardware drivers) are in **/Extra/KextStore**, these are for fixes specific to the Inspiron 1525 hardware. For more general kexts, these will need to be installed to **/System/Library/Extensions**. On the Boot-132 CD, in **Post-Install/Applications** you will find two applications:

1. Kext Helper - use this for installing kexts to /System/Library/Extensions
2. MKextTool - use this for rebuilding the **Extensions.mkext** if you change the kexts in **/Extra/KextStore**

You're going to need to open **Kext Helper** now to install the remaining kexts from **Post-Install/Local Extensions**.

## Extra configuration

If you've got the Dell Wireless (Broadcom-based) Wi-Fi card in your Inspiron, you should find that wireless works already, so you can connect to your wireless network now or plug in an ethernet cable and use the wired network.

If the screen colours look a bit weird (mine looked very purple), open **System Preferences** and click **Displays**, click the **Color** tab and then select one of the display profiles from the list. I find that the **Generic RGB Profile** looks the best.

To make sound work, you will need to open **System Preferences** again and go to **Sound**, select the **Output** tab and then from the device list select **Speaker (Fixed)**.

Update: [You can see part 2 of the guide here](/post/upgrading-mac-os-x-snow-leopard-on-the-dell-inspiron/)

I no longer own the Dell Inspiron 1525, and so I'm no longer supporting this guide.
