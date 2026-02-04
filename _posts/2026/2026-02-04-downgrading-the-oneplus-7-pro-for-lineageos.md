---
title: Downgrading the OnePlus 7 Pro for LineageOS
comments_issue: 133
tags: [guide, android]
---

I've had a OnePlus 7 Pro sitting in a drawer for a couple of years. I used it from 2019, found it too big, got a Pixel 5a, and now I'm on the Pixel 7a. The usual thing, fiddling with an old gadget that's been kicking about doing nothing. It's a nice phone with nice features. Shame it's stuck on such an old version of Android. Time to get LineageOS on there.

<!-- more -->

## The bootloader problem

With the Android 12-based OxygenOS the bootloader can't be unlocked. To get around this I needed to downgrade to Android 11 first.

The URLs floating around the internet for the official rollback packages are broken, the `oxygenos.oneplus.net` domain doesn't serve them anymore. The files still exist on AWS though. Just swap the domain:

```
https://oxygenos.oneplus.net/OnePlus7ProOxygen_21.E.41_OTA_0410_all_2112101752_downgrade_3821c2d4496c48fc.zip
```

becomes:

```
https://s3.amazonaws.com/oxygenos.oneplus.net/OnePlus7ProOxygen_21.E.41_OTA_0410_all_2112101752_downgrade_3821c2d4496c48fc.zip
```

I found this via [a thread on the OnePlus community forums](https://community.oneplus.com/thread/1181167844348919809).

## Downgrading to Android 11

1. Download the rollback update package using the S3 URL above
2. Enable **Developer Options** (tap the build number 7 times in Settings → About Phone)
3. Enable **USB Debugging** in Developer Options
4. Push the file to the phone:

```
adb push OnePlus7ProOxygen_21.E.41_OTA_0410_all_2112101752_downgrade_3821c2d4496c48fc.zip /sdcard/
```

5. On the phone, go to **Settings → System → About Device → System Updates → Local Install**
6. Pick the zip, extract, and hit **Install Now** (the phone will reboot)

## Unlocking the bootloader

After the downgrade completes:

1. Enable **Developer Options** again
2. Enable **USB Debugging** again
3. Reboot into fastboot:

```
adb reboot bootloader
```

4. Unlock the bootloader:

```
fastboot oem unlock
```

## Installing LineageOS

The [LineageOS installation guide for the OnePlus 7 Pro (guacamole)](https://wiki.lineageos.org/devices/guacamole/variant1/) covers this in detail. The rough process:

Flash the partition images:

```
fastboot flash dtbo dtbo.img
fastboot flash vbmeta vbmeta.img
```

Reboot back into fastboot and flash the boot image:

```
fastboot reboot bootloader
fastboot flash boot boot.img
```

Factory reset from the recovery, then sideload LineageOS and GApps (I wanted the Play Store):

```
adb sideload lineage-23.0-20260202-nightly-guacamole-signed.zip
adb sideload MindTheGapps-16.0.0-arm64-20250812_214353.zip
```

Reboot the device and it's done.

LineageOS 23 runs fine. An evening spent downgrading from Android 12 to 11 so I could upgrade to 16, as one does. Back in the drawer it goes.
