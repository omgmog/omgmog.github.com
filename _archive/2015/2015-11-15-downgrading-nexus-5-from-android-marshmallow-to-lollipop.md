---
comments_issue: 48
title: Downgrading Nexus 5 from Android 6.0 to Android 5.1.1
---

I jumped on Android 6.0 Marshmallow as soon as the developer images were available to flash, and to be honest as far as "major releases" go, it was pretty underwhelming. A lot of the new features aren't things I need, and I've found myself running in to a bug with device orientation in Chrome (only!) not working.

<!-- more -->

{% include posts/figure.html src="nexus5downgrade.png" %}{:.massive.center}

So I've decided to downgrade back to 5.1.1, here's how the process goes:

1. Backup everything
2. Download the Lollipop image (found [here](https://developers.google.com/android/nexus/images?hl=en#hammerhead))
3. Decompress the image
4. Boot the Nexus 5 in to `fastboot` mode
4. Run the `flash-all.sh`, or flash each step manually.

Thankfully I recently moved from using Google Authenticator for my 2fa, to using Authenticator Plus which has the ability to backup/restore/sync your authenticator profiles to Dropbox or Google Drive, so before wiping my Nexus 5, I set my trusty 2012 Nexus 7 up with Authenticator Plus so I can get back in to my accounts after I've finished downgrading.

As an aside, the device orientation not working bug is the real motivation for downgrading. I'm going to be presenting a talk about Google Cardboard and Javascript to a local developer group this week, and so need a device that will actually work with Google Cardboard!
