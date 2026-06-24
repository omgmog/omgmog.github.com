---
title: Making GIMP feel less like punishment
comments_issue: 156
tags: [gimp, macos, design, guide]
---

[GIMP](https://www.gimp.org/) has always had an interface problem. I'm not blaming the GIMP team (they've built something powerful on a shoestring). They've been clear they're not interested in copying Photoshop wholesale; their [FAQ](https://www.gimp.org/docs/userfaq.html) argues that designing around actual user research beats imitating someone else's interface decisions.

{% include posts/figure.html src="2026-05/gimp-default-ui.png" %}{:.center}

Fair enough in principle, but coming from years as a Photoshop user, that design still feels hostile to me. I'm just one user story out of many they've had to design for, but it still expects me to learn its own way of doing things rather than offering a config closer to what I'm used to out of the box.

<!-- more -->

[PhotoGIMP](https://github.com/Diolinux/PhotoGIMP) is a config pack that reorganises the UI to feel more like Photoshop (a compact single-window layout, a sensible brush picker, keyboard shortcuts that don't need a cheat sheet). It also swaps in a custom splash screen and icon. The kind of changes that felt overdue by about fifteen years. It's available for Linux, Windows and macOS.

I'm on macOS, where installation takes about two minutes, though it works much the same on the other platforms. The one thing I'd flag, GIMP needs to have been launched at least once already, so it's generated its own config files for PhotoGIMP to overwrite. I downloaded the latest release zip, extracted it, then copied the contents into my existing GIMP config folder at `~/Library/Application Support/GIMP/3.x` (`Cmd+Shift+G` in Finder to get there). Replaced when prompted, restarted GIMP, done.

{% include posts/figure.html src="2026-05/photogimp-layout.png" %}{:.center}

The difference was immediate. Stock GIMP spreads tools across multiple floating panels like it's 2004. PhotoGIMP consolidates everything into a single window with the toolbox on the left and docked panels on the right. Brushes are visible and browsable without hunting through menus, and layers sit where I'd expect them. It feels less like punishment.

It's still GIMP underneath. The weird terminology's still there, so is the slightly broken text tool and the arcane filter dialogues. But at least now the interface isn't working against me while I'm trying to get something done, and if GIMP's UI has put you off before, PhotoGIMP's worth trying.
