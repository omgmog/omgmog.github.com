---
title: O cursor, where art thou?
comments_issue: 170
tags: [macos, ux]
---

All too often on my computer, I'll finish typing something, reach for my mouse, and have no idea where the cursor has got to. Not on the monitor I was looking at. Possibly on the laptop screen, but I'd have to turn my head and check. So I do what I always do, shake the mouse until macOS inflates the cursor to the size of a dinner plate, and carry on.

<!-- more -->

I wondered at first whether this was a problem with my eyes. I've had two pairs of glasses for a couple of years now, one of them purely for sitting in front of a computer, and I recently switched to varifocals, which trade a wide focus band for having near and far in one lens. With the right pair on I can see the cursor perfectly well once it's in front of me, but the narrower band makes scanning a 32" panel slower than it used to be.

{% include posts/figure.html src="2026-09/tiny.gif" alt="A small cursor arrow getting lost against a busy desktop background" %}{:.center}

Eyes aside, there's also the area to cover. My 32" 4K monitor and the MacBook's own 16" panel give me around 550 square inches to lose a cursor in, a long way from where the cursor started. [Alan Kay drew the arrow at PARC](https://jameshk.com/mouse-cursor) on a 16x16 grid of one-bit pixels, angled because that was what read clearly at that size, and the Mac inherited it in 1984. On that 9" screen, [running 512x342 at 72ppi](https://512pixels.net/2025/05/original-macintosh-resolution/), the cursor was about 0.22" (5.6mm) tall. The screen area I'm searching is sixteen times bigger now.

{% include posts/inline-svg.html src="cursors-screen-comparison.svg" class="center" %}

[Forty years of work has gone into how the cursor looks](https://unsung.aresluna.org/the-curse-of-the-cursor/), almost none into where it is. It's antialiased now, with a white outline and a soft drop shadow, and it scales smoothly instead of stepping between fixed bitmaps. macOS will make it considerably bigger if you ask, and let you recolour the fill, which helps more than size does when it's sitting over something the same tone. It all helps once you're looking at the thing, but nothing tells you which corner to look in.

{% include posts/figure.html src="2026-09/cursors.png" alt="The cursor arrow through the years: PARC, System, OS X and macOS" %}{:.center}

I suppose I've also stopped using the mouse as much. Almost everything I do happens on [the keyboard](/post/why-im-using-a-low-profile-keyboard) now, shortcuts inside whatever app I'm in, and [Raycast](https://www.raycast.com/) for the rest. I use it as a `cmd`-`space` replacement and for window management, which matters on a display this size, since snapping something to a half or a third by keyboard beats dragging it there. The mouse gets picked up for dragging files around and for the occasional site that still insists on hover. The rest of the time the cursor sits motionless in a corner of a screen I haven't looked at for ten minutes.

{% include posts/figure.html src="2026-09/cursor-shake.gif" alt="Shaking the mouse on macOS causes the cursor to balloon in size so it's easier to spot" %}{:.center}

Apple's answer is [the shake](https://support.apple.com/guide/mac-help/mchlp2920/mac), which has been in macOS since El Capitan and lives under Accessibility, Display, Vision. I'd guess most people using it every day have never once thought of it as an accessibility feature. Windows made the same admission in a different shape, press `ctrl` and concentric circles close in on the cursor. Someone even [ported the shake itself to Windows](https://github.com/carlosmva/CursorShake), for anyone who prefers macOS's version.

Neither puts anything permanent on screen, which is right. A constant locator would be noise for anyone with a hand on the mouse all day. It's only worth anything once you've drifted far enough from the cursor to lose track of it.
