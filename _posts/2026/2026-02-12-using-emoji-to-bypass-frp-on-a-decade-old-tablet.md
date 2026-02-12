---
title: Using emoji to bypass FRP on a decade-old tablet
comments_issue: 135
tags: [android, hardware, emoji]
header_background: "/images/2026-02/background-emoji-frp.png"
---
I recently picked up two Pixel C tablets from a seller on eBay, along with the magnetic keyboard. One tablet had a cracked screen but worked fine and wasn't locked. The other was cosmetically perfect but the display was completely black. I figured between the two I could end up with at least one working tablet.

<!-- more -->

{% include posts/figure.html src="2026-02/pixel-c-angles.png" %}{:.center.massive}

## The Pixel C

I've been through a few Android and ChromeOS tablets over the years, from [the Nexus 7](/post/finally-a-post-about-the-nexus-7/) to [the Lenovo Duet](/post/using-chromebook-lenovo-ideapad-duet-in-2020/). The [Pixel C](https://blog.google/products-and-platforms/platforms/android/meet-pixel-c-our-take-on-tablet/) was Google's first tablet designed entirely in-house, released in December 2015. It was [originally intended to run Chrome OS](https://9to5google.com/2015/12/10/pixel-c-chrome-os-device/) before being pivoted to Android mid-development.

- **Display**: 10.2-inch IPS LCD, 2560x1800 (308 ppi)
- **Processor**: Nvidia Tegra X1, quad-core
- **RAM**: 3 GB
- **Storage**: 32 GB or 64 GB
- **OS**: Android 6.0.1 at launch, final update Android 8.1

The keyboard attaches magnetically and charges inductively from the tablet itself. Quite slick for its time. Google stopped selling the Pixel C in 2017 and ended software support in June 2019, so the two I'm working with are running the final build they'll _ever_ get.

## The black screen problem

The cracked screen unit set up without any trouble. The black screen unit was more interesting. It seemed to turn on fine (I could hear notification and lock sounds) but no picture. I hooked it up to my computer and tried poking at it with `adb`, `fastboot`, and `mtp`. I set up a quick loop to monitor what state it was in. It polls `fastboot`, `adb`, and the USB product ID every second, printing a timestamped line and beeping whenever the state changes:

```bash
serial="5A220..."
prev=""
while true; do
  fb="$(fastboot devices 2>/dev/null | awk '/fastboot$/ {print $1; exit}')"
  ad="$(adb devices 2>/dev/null | awk 'NR>1 && NF {print $1":"$2; exit}')"
  pid="$(system_profiler SPUSBDataType | awk -v s="$serial" '
    /Product ID:/ {pid=$3}
    $0 ~ "Serial Number: " s {print pid; exit}
  ')"

  cur="pid=${pid:-na} fastboot=${fb:-none} adb=${ad:-none}"
  if [ "$cur" != "$prev" ]; then
    printf "%s  %s\n" "$(date '+%H:%M:%S')" "$cur"
    osascript -e 'beep 1'
    prev="$cur"
  fi
  sleep 1
done
```

Output looked something like this as the device cycled through states:

```
14:32:01  pid=na fastboot=none adb=none
14:32:15  pid=0x5201 fastboot=5A220... adb=none
14:32:22  pid=0x5202 fastboot=none adb=none
```

It would boot to fastboot no problem, but the bootloader was locked and only read-only commands would work:

```
fastboot getvar all
(bootloader) product: dragon
(bootloader) secure: yes
(bootloader) unlocked: no
(bootloader) partition-size:chromeos: 0xe8f800000
...
```

That `chromeos` partition is a nice reminder of the Pixel C's origins. Any write attempts just bounced:

```
fastboot flash recovery recovery.img
Sending 'recovery' (13200 KB)   OKAY [  0.354s]
Writing 'recovery'     FAILED (remote: 'unsupported command')
```

Despite having `system-a` and `system-b` partitions, slot switching wasn't an option either:

```
fastboot --set-active=a
fastboot: error: Device does not support slots
```

Eventually I got the display to show a picture by applying pressure to the rear left half of the case. Turns out the internal display connector on these Pixel C units is a known weak point. The device now had a working screen, so I booted it up hoping for a simple wipe and sign-in.

Enter Factory Reset Protection (FRP). The previous owner hadn't unlinked their account, and no amount of fastboot flashing or sideloading would get it out of that state. I was effectively locked out of my _own_ hardware. In FRP mode, the setup process is completely locked down: no notifications, no settings, no home button, no app switcher, no browser, no global search. Just a single-track wizard that demands the previous owner's Google account before it'll let you do anything else.

{% include posts/figure.html src="2026-02/frp-message.png" %}{:.center}

Most of the standard "pivots" to get into the settings menu have been patched out on this build. I tried the usual talkback tricks, but they were all dead ends.

My next instinct was to try a buffer overflow. I remembered [CVE-2015-3860](https://nvd.nist.gov/vuln/detail/CVE-2015-3860), a vulnerability in Android 5.x that crashed the lockscreen by flooding the password field with a massive string. Same principle, different target. I connected to my Wi-Fi, went back to the "Add network" screen, and started flooding the SSID field with text.

I used 💥 emoji copied from the on-screen picker, then connected the physical keyboard and hammered Ctrl+V until the field was overflowing with thousands of characters.

{% include posts/figure.html src="2026-02/emoji-breakout.jpg" %}{:.center}

It worked. The settings app eventually gave up and crashed. When the "Settings has stopped" popup appeared, I tapped **Send feedback**, which is a classic escape hatch from the sandboxed setup screen.

This opens a feedback form with links to terms, privacy policy, and so on. Tapping one of those links opens a restricted webview, but I didn't have full access yet.

## Dead ends

I set up a self-hosted page with `intent://` URLs as anchor links, hoping I could navigate to one like:

`intent://com.android.settings/#Intent;scheme=android-app;end`

The restricted webviews just ignored them or looped me back to the start of the setup. Pretty frustrating.

{% include posts/figure.html src="2026-02/intent-error.png" %}{:.center}

I spent a few hours trying to find my own exploit: setting up a `dnsmasq` server to MITM the DNS requests, hoping I could redirect the login handshake to something I controlled. No luck; the certificate pinning on the June patch is quite decent.

I tried some "physical" exploits too. With the webview open, I started ripping the USB keyboard dongle in and out. Each replug spawned the webview again, and eventually the "System UI has stopped" popup appeared. But I didn't realise what state I'd got it into and rebooted manually. Spent the next hour trying to repeat it with nothing to show but a sore arm.

I found that selecting text would sometimes offer intents. A search box gave me something I could type into and select. I typed an email address and got a Gmail intent. There's an old trick where you start setting up an Exchange account, and when it asks to install certificates it prompts you to create a PIN that persists across reboots. I managed to set a PIN this way, but it didn't help bypass the FRP account check. Dead end.

I tried a street address instead. When I selected it, Android offered a **Google Maps** intent. Since Maps on the tablet was so old, it prompted me to **Use Maps on Chrome**.

{% include posts/figure.html src="2026-02/maps-intent.jpg" %}{:.center}

{% include posts/figure.html src="2026-02/chrome-launch.jpg" %}{:.center}

_Finally_, I was in a real browser.

With full Chrome, the intent URL that had failed in restricted webviews now worked:

```
intent://com.android.settings/#Intent;scheme=android-app;end
```

This dropped me straight into Settings. I did a factory reset from there, hoping it would clear the FRP flag since I was inside the OS rather than recovery. It didn't. After reboot, the same "Verify your account" screen was waiting for me. Back to square one.

I repeated the Maps trick to get back into Chrome. This time I knew I needed a different approach.

## Getting in

I headed over to `addrom.com/bypass` to grab the tools I needed. From there I downloaded two APKs:

1. **Google Account Manager 6.0.1** - an older version that still has the "Browser Sign-in" option
2. **FRP Bypass APK** - a small app that triggers the account manager

After installing both, I launched the FRP Bypass app, tapped the three dots menu, and selected **Browser Sign-in**. This opened a Google login page where I signed in with my Gmail account. The system accepted it as the new owner account.

Quick reboot, and instead of "Verify your account" I got "Account Added".

{% include posts/figure.html src="2026-02/hackerman.gif" %}{:.center}

I wasn't about to leave it at that. First thing I did was head to **Settings > About Tablet** and mash the build number until I got developer access, then toggle **OEM Unlocking** and **USB Debugging** to ON.

{% include posts/figure.html src="2026-02/developer-options.png" %}{:.center}

I've also run `fastboot flashing unlock` from my Mac to make sure I never have to do the emoji dance again.

The whole process took a couple of hours spread over two or three days. Life gets in the way of these deep dives.

As for the display fix, it's probably not permanent. According to [iFixit's teardown](https://www.ifixit.com/Teardown/Google+Pixel+C+Teardown/62277), the screen is glued down, so properly securing the ribbon cable would be quite involved. For now I'll just be careful with it.

The cracked screen unit is set up and working fine despite the cracks. It might become a dedicated Klipper display for my 3D printer. This one, with its intact screen, could become my go-to 10" tablet for magazines, comics, and books. Or more likely I'll just mess with it for a bit and then stick it on a shelf.