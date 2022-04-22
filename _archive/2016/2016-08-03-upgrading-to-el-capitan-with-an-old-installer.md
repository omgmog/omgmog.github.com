---
title: Upgrading to El Capitan with an old installer
comments_issue: 72
---

I upgrade my Macbook to El Capitan as soon as I could, and have had very few issues with the release. On my iMac at work though, I've been putting off the upgrade since last October -- due to time constraints and not wanting to mess anything in my dev environment up.

Today I tried to install El Capitan using the `Install OS X El Capitan.app` installer.

<!-- more -->

{% include posts/figure.html src="2016-08-03/installer.png" %}{:.massive.center}

I was greeted with this message. How could this be? The installer has simply been sat in my Applications directory since October, nothing has changed.

I used the following command to verify the integrity of the installer image:

```shell
hdiutil verify /Applications/Install\ OS\ X\ El\ Capitan.app/Contents/SharedSupport/InstallESD.dmg
```

Which told me the image `is VALID`. Alright, so there must be another cause?

Well I downloaded the installer in October 2015; In February 2016 Apple's Signing Certificate expired. I actually encountered this issue when doing a fresh install of El Capitan on another Macbook earlier this year, the solution is simple: change the system date to earlier than February 2016.

```shell
date 1021120015
```

That command changes the date to `October 21st 2015 at 12:00`.

Alternatively you can use the Date & Time System Preferences pane:

{% include posts/figure.html src="2016-08-03/datetime.png" %}{:.massive.center}

Now you can run the installer without issue.

After OS X El Capitan has installed, it will set the date and time back to their correct values.

Now, rather than having to re-download a 7GB installer image, I just have to download a 2GB update!
