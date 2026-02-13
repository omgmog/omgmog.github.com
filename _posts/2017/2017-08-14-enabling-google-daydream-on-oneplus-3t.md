---
title: Enabling Google Daydream Support on OnePlus 3T
tags: [android, vr]
archived: true
---
I enabled Google Daydream support on my OnePlus 3T today and I'm pretty impressed.<!-- more -->

The OnePlus 3T costs about half as much as the Google Pixel or any other _Daydream compatible_ devices, but it's powerful enough to run Daydream. The screen resolution is a bit low, and OnePlus seem to not be interested in getting the device certified.

To enable Daydream support you need to root the OnePlus 3T, and then modify a couple of files:

### `/system/etc/permissions/handheld_core_hardware.xml`

Before the closing `</permissions>` tag, add the following keys:

```xml
<feature name="android.software.vr.mode" />
<feature name="android.hardware.vr.high_performance" />
```

### `/system/build.prop`

At the end of the file, add the following line:

```
ro.product.device=sailfish
```

To modify those, I used the app "Root Explorer", navigated to each file and opened them in the built-in editor in Root Explorer.

Once you're done, reboot the OnePlus 3T and the install [Daydream VR](https://play.google.com/store/apps/details?id=com.google.android.vr.home), [Google VR Services](https://play.google.com/store/apps/details?id=com.google.vr.vrcore) and [Daydream Keyboard](https://play.google.com/store/apps/details?id=com.google.android.vr.inputmethod). You might not be able to view/install these from the Play Store, but you can find the `.apk` files on [apkmirror](https://www.apkmirror.com).

I don't have a Daydream headset or controller, but I do have numerous Google Cardboard headsets (nice plastic ones with elastic straps!) and some old/spare Android phones. 

You can use a second Android phone as a controller using the _Daydream Controller Emulator_ and instructions from [Google's VR Developer Site](https://developers.google.com/vr/daydream/controller-emulator).

Over-all it works pretty nicely. It's a bit laggy in places, but not too bad. The tracking is as good you would expect -- a bit better than Cardboard experiences on Android by my experience. It's certainly not going to compate with my HTC Vive, but it's a fun thing to play with none the less.

As soon as the battery on the _controller phone_ charges a bit more, I'm going to sideload the Netflix VR apk and give that a go.