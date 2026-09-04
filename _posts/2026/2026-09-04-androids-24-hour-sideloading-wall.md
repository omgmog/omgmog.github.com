---
title: Android's 24 hour sideloading wall
comments_issue: 168
tags: [android, google, software]
---

I was showing a friend the Pokémon [gen1recomp](https://github.com/bryanthaboi/gen1recomp) project on my phone the other day, and he wanted it on his. Easy enough. Hand over the APK and the files it needs, walk him through the setup, ten minutes while we're sat in the same room.

<!-- more -->

Except his Pixel 10, running Android 17, wouldn't have it. Install blocked, unverified developer. [The way through](https://android-developers.googleblog.com/2026/03/android-developer-verification.html) is to enable developer mode, confirm nobody is coercing you, restart the phone, wait a day, then come back and authenticate again.

A day. He was travelling to the other end of the country the next morning. Whatever momentum we had was gone. It'll happen over WhatsApp in a week, or it won't happen at all. My money's on _won't_.

{% include posts/figure.html src="2026-09/android-unverified.png" %}{:.massive}

This is Google's advanced flow, the install path for any app whose developer hasn't registered an identity with them, and it went live everywhere in August. Not only in the pilot countries, not next year. It's on UK phones now, and staying on an older release won't help, because the component doing the checking [ships through Google System Updates](https://android.gadgethacks.com/news/what-is-the-android-developer-verifier-app-and-why-is-it-on-your-phone/) rather than the OS version.

The registration itself is a separate clock, a legal name and government ID tied to a package name and a signing certificate that developers must complete. It has a deadline at the end of September in four countries and goes global in 2027. [Google's own timeline](https://support.google.com/android-developer-console/answer/16561738) makes the gap fairly plain.

| When | What |
| --- | --- |
| August 2026 | Developer APIs, limited distribution accounts and the advanced flow launch |
| 30 September 2026 | Deadline for participating app stores in Brazil, Indonesia, Singapore and Thailand |
| 2027 onwards | Global rollout across all certified Android devices |
{:.massive}

In fairness, it's a one-time setup rather than a per-app tax, ADB is untouched, and the reasoning is specific. Google's write-up is about coercion scams, where someone stays on the phone with a victim and talks them through disabling protections. The restart cuts off the call, the wait removes the urgency. It isn't a bad-faith design. It's a design optimised for one scenario that treats every other one as acceptable collateral, and I'm one of the other ones.

{% include posts/figure.html src="2026-09/android-sideload-flow.png" %}{:.massive}

The friction isn't really aimed at the installer, it's aimed at _the moment_. Sideloading is a thing you do while someone shows you, or while the cable is already plugged in. A one-day wait isn't a small tax on that, it's fatal to it. Anyone who's tried to get a friend into a hobby knows the window is about twenty minutes wide.

Verification also tells you _nothing_ about an app, only that an identity check passed. Anyone running fraud at scale will pay [the $25](https://developer.android.com/developer-verification/guides/faq) and produce ID, a rounding error against the returns. The people who won't are pseudonymous maintainers of niche utilities and people writing free software to stay out of a registry. [F-Droid](https://f-droid.org/2026/02/24/open-letter-opposing-developer-verification.html), which signs everything with its own keys, calls it existential. **The friction lands on the people who weren't the problem.**

Not being on a certified device is a genuine dodge. AOSP builds are untouched, since the verifier is a separate Google app that [LineageOS doesn't ship](https://lineageos.org/Developer-Verification/), so my de-Googled tablets and most of my handhelds are already outside it. But F-Droid's own figure puts certified devices at **over 95%** of Android outside China, and telling someone to flash a custom ROM to try a Pokémon project isn't advice, it's a hobby with a prerequisite.

What frustrates me most is that the good version of this already exists. The old permission model was genuinely bad, granting your browser permanent install rights, buried in Settings, then forgotten forever. Android 17 QPR2 beta [replaces it](https://www.androidauthority.com/android-17-qpr2-beta-4-apk-sideloading-permissions-3704842/) with a proper per-install choice. Trying to install an APK now brings up three options. Install once, and the permission expires the moment that install finishes, so the prompt comes straight back the next time. Always allow, and it behaves like the old blanket permission, which won't ask again. Don't allow, and the dialogue just closes with nothing granted. That first option, scoped to a single install, is the whole fix. Proof the two changes were never a package deal.

The workaround for the situation I actually hit is a USB cable and `adb install`, which works fine and is exactly the wrong shape for the problem. Android's pitch, for its whole life, was that the device is yours and you decide what runs on it. That's still true. It now takes a day.
