---
title: Installing OS X Snow Leopard on the Dell Inspiron 1525
tags: [hackintosh, mac-os-x, guide]
archived: true
archive: omgmog.net
archived_comments:
- author: Rob
  content: >-
    I came across your page trying to find a alternative method to booting Snow
    Leo as I've ran into a lot of problems. I keep getting still waiting for root
    device, even using your boot flags doesnt work for me. Any chance you could
    send me your Boot 132 iso, or did you do anything special other than the
    guide you've posted. I've tried all the iso's from Mac your PC with no joy :(
- author: max
  content: >-
    My boot 132 was just the one from Mac Your PC. The only thing that I'm sure
    effects the "still waiting for root device" is the wireless, but it could be
    another hardware issue. I hope that helps, if you have any further problems
    feel free to leave another comment.
- author: Rob
  content: >-
    Thanks for the response… I think I know what the problem is. When I change
    something like wifi on Bios to disabled it says factory enabled underneath.
- author: MoNcHeE Yuson
  content: Hi there, is there any way of dual booting Snow Leopard and Windows 7 rc?
- author: max
  content: >-
    There are a number of guides explaining how to dual boot Snow Leopard and
    Windows 7 over at the InsanelyMac forums.
- author: MoNcHeE Yuson
  content: is installing Snow Leopard easier than Leopard? Is it less complicated?
- author: max
  content: >-
    Using this method, on the Dell Inspiron 1525 it is a lot less complicated
    than Leopard. Hard to say for other laptops/computers though…
- author: Victor Lee
  content: >-
    I've gotten everything to work on my friend's Dell 1525 except for sleep.
    Did you just follow the macyourpc guide to the T and got sleep to work?
    I can't for the life of me get sleep to work…… with power adapter or
    without…
- author: Anton
  content: >-
    I'm trying to install SL 10A432 GM on Dell 1525, but every time while trying
    to boot setup disk I see kernel panic, despite any flags. Tried "-x -v -f
    -legacy platform=X86PC cpus=1", downloaded BootSLv3wifi and
    BootSLv3-no-wifi, both with kernel panic.
- author: Dan
  content: >-
    I followed all instruction, everything went fine except i had to use the
    Boot132 without wireless and i got the VoodooHDA.prepane error. Figured this
    wasn't enough to stop it from booting so i restarted. Chameleon loaded, i hit
    enter to load my osx partition, got a nice shiny apple loading screen with a
    spinner and a grey bg, then BLACKNESS. For that brief time when it was
    running, it was beautiful.
- author: max
  content: >-
    @Dan – you could boot into verbose safe mode and see if it can continue, use
    the flags "-x -v" at the Chameleon screen
---

I've had a Dell Inspiron 1525 for about 18 months now. It's not my main computer, so I'm often messing with it.

Some time last year I made the jump to running OS X Leopard on the Dell, with some work and guides put in by the folks over at the InsanelyMac forums and a guide by Espresso Report/Daily Blogged. I had Leopard running on my Dell perfectly, and all of the hardware that I cared to work worked.

Earlier this month I decided that I wanted to subject my Dell to being a test bench for Windows 7, so I decided to run that on the Dell for a while before running it on my main computer.

Now that I have no need for Windows 7 on my Dell I've decided to return to OS X, but this time with the newly released Snow Leopard.

<!-- more -->

My Dell Inspiron 1525 is probably the most bottom of the range spec available, but it's as follows:

- CPU: Celeron 540 1.86GHZ, 533Mhz fsb, 1MB cache
- Memory: 1GB, 667Mhz fsb
- Graphics: Intel GMA X3100 – Just like the graphics chipset on the Macbooks!
- Screen: 15.4" Glossy WXGA screen (1280x800)
- HDD: (upgraded) 120GB, 7200rpm, 8MB cache, SATA2
- Wireless: "Dell Wireless 1390" – This is a Broadcom wireless card, just like Apple's Airport cards!

I installed using a retail Snow Leopard DVD, and a "Boot-132" boot CD created for the Dell Inspiron 1525 by the guys over at Mac your PC. At the time of writing this post I should note that many people have understandably had problems getting Snow Leopard installed on their computers.

I had a couple of initial troubles myself, but eventually worked through them by trying some alternate darwin boot flags, and now I've got a vanilla install of OS X Snow Leopard running better than Leopard ran previously on my Dell Inspiron 1525.

The process (outlined in more detail at Mac your PC) is relatively simple:

- burn the Boot-132 CD to a CD-R/CD-RW
- boot the Dell with the CD, it will load the "Chameleon" bootloader
- swap the Boot-132 CD for your retail Snow Leopard DVD (the upgrade DVD works fine here too!)
- type some darwin boot flags (the guide said to use "-x -v" which would be "single user mode" and "verbose", but for me using "-x -v -f -legacy cpus=1 platform=X86PC" seemed to be the only way to boot the installer)
- install Snow Leopard as usual, but first partition/format the HDD
- after install, boot the computer with Boot-132 CD again, but this time select the HDD to boot with "-x -v" flags
- install remaining "Post-install" packages, which includes Chameleon for the HDD, and then a couple of .kext (driver) files to make OS X play nicely with the Dell hardware!

Now that that's all done, I've got a perfectly functioning Snow Leopard install on my Dell Inspiron 1525 laptop.

During the installer my WiFi worked and picked up my home network, and unlike with Leopard I didn't need to do any "sleep tricks" to get the display to turn on once OS X had booted.

The differences between Leopard and Snow Leopard, though small in comparison to other upgrades, were quite noticable. Some really nice small touches, from the way the stacks on the Dock.app function, to how the multiple desktops on spaces work. I'm really impressed.

Update: [You can see the updated version of this guide here](/post/installing-mac-os-x-snow-leopard-on-the-dell-inspiron/)
