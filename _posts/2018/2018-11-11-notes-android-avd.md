---
title: Some Notes About Android Virtual Devices
tags: [android]
archived: true
---

### Running AVD emulator from the Windows command line/Powershell/mingw32
This assumes you've got Android Studio installed.

First you need to have the `tools` path in your `$PATH` variable, to do this edit `Path` in Windows' Environment variables to include for example:

`C:\Users\Max\AppData\Local\Android\Sdk\tools`

Then you can use `emulator.exe` from anywhere. The [Android Studio docs](https://developer.android.com/studio/run/emulator-commandline) fail to mention this.

```bash
$ emulator -no-boot-anim -accel auto -writable-system -no-snapshot -gpu host -avd K10_API_22
```

### Installing Google Play Services

I've been messing around with older device profiles, and trying to run things in Chrome on Android 5.0 (API level 21). 

You'll need to sideload the Google Play services system APKs (from a gapps package for your target system, e.g. [for Android 5.0](https://androidhost.org/BcyG7), but you might find that the `/system` partition is full. 

No problem, you can sideload to `/sdcard` and symlink:

```bash
$ adb remount
# Fails...
$ adb push .\GmsCore.apk /system/priv-app
$ adb: error: failed to copy '.\GmsCore.apk' to '/system/priv-app/GmsCore.apk': No space left on device

# Works...
$ adb push .\GmsCore.apk /sdcard/system/priv-app
$ adb push .\GoogleLoginService.apk /sdcard/system/priv-app
$ adb push .\GoogleServicesFramework.apk /sdcard/system/priv-app
$ adb push .\Phonesky.apk /sdcard/system/priv-app

# Symlink them
$ adb shell ln -s /sdcard/system/priv-app/GmsCore.apk /system/priv-app/GmsCore.apk
$ adb shell ln -s /sdcard/system/priv-app/GoogleLoginService.apk /system/priv-app/GoogleLoginService.apk
$ adb shell ln -s /sdcard/system/priv-app/GoogleServicesFramework.apk /system/priv-app/GoogleServicesFramework.apk
$ adb shell ln -s /sdcard/system/priv-app/Phonesky.apk /system/priv-app/Phonesky.apk
$ adb shell stop
$ adb shell start
```

### Messing around with /etc/hosts

It's trivial to edit the `/etc/hosts` on your AVD, but it only works if you have blank new line at the end of the hosts file.

```bash
$ adb pull /etc/hosts hosts
$ nano hosts # make your changes to the hosts file locally...
$ adb push hosts /etc/hosts
```
