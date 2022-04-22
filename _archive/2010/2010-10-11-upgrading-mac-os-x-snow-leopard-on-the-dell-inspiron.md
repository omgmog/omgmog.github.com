---
comments_issue: 40
title: Upgrading Mac OS X Snow Leopard on the Dell Inspiron 1525 to 10.6.4
---

In this part of the guide, I'll be covering upgrading to 10.6.4. You can read the first part of this guide here - [Installing Mac OS X Snow Leopard on the Dell Inspiron 1525](/post/installing-mac-os-x-snow-leopard-on-the-dell-inspiron/)

<!-- more -->

## Upgrading using the 10.6.4 combo-update

This is probably the easiest method. Download the 10.6.4 combo-update from here - [http://support.apple.com/kb/DL1048](http://support.apple.com/kb/DL1048)

While that downloads, you'll need to prepare some things.

Download the kernel-independent version of **SleepEnabler.kext** - [http://code.google.com/p/xnu-sleep-enabler/downloads/detail?name=SleepEnabler.10.6.x.zip](http://code.google.com/p/xnu-sleep-enabler/downloads/detail?name=SleepEnabler.10.6.x.zip)

You will need to put this **SleepEnabler.kext** into **/Extra/KextStore/**
Copy your com.apple.Boot.plist from **/Extra/** to your desktop and open it in TextEdit. Add the following between `<string></string>` under `<key>Kernel Flags</key>`:

```xml
pmVersion=20
```

So it will read:

```xml
<key>Kernel Flags</key>
<string>arch=i386 pmVersion=20</string>
```

Then copy the com.apple.Boot.plist back to **/Extra/**.

Delete **IO80211Family.kext** from **/System/Library/Extensions** &mdash; you can do this through the terminal by opening Terminal.app and executing the following commands, and entering your password when prompted:

```
$ cd /System/Library/Extensions
$ sudo rm -rf IO80211Family.kext
$ sudo rm -rf SleepEnabler.kext
```

After these things are done, and the 10.6.4 combo-update has downloaded, you can start the installer. It will take a little while, so go grab a coffee while it installs. After the installer completes you will need to reboot.

Now you should have 10.6.4 installed, you can check for software updates and install any remaining updates.
