---
comments_issue: 37
title: Redesigning and relaunching Dingoonity
---

Over the weekend I relaunched [Dingoonity.org](http://dingoonity.org). I launched the site back in November 2009, a bit of a rush job as far as the design of the boards was concerned &mdash; it coincided with me getting a full-time web design job at RS Components, so while giving the paid job my 100%, Dingoonity's design got neglected.

<!-- more -->

Since then I have tried to find time to finish up the design, and early last year I got pretty close to releasing a new design based on the existing Simple Machines Forum 1.1.x software, but I never found it a particularly nice experience to work around the muddy tables of the board pages, and so never finished the design.

Cut to earlier this month, after neglecting the community more than I care to admit, I was chatting with one of the co-founders and it occurred to me that even though I'm neglecting and not nurturing the website, the community continues to thrive.

Dingoonity has 2750 members who have written 26600 posts in 2900 topics. Not bad for a niche community about a [Chinese portable console](http://en.wikipedia.org/wiki/Dingoo) that is able to play hundreds of retro console games, and hundreds of new homebrew games.

Amidst some future plans for the site, I decided I would finally get around to finishing up the design of the site, and so I created a development server with a copy of the database from the live site, and set about trying out some things. The site now runs on Simple Machines Forum 2.0 RC4 &mdash; so it has with that a whole load of improvements.

The main focus of the new design was to make the home/news page more connected to the boards, and I've done that by having a fixed persistant header section with links to all major areas of the site (profile/messages/help/rules/search/admin/etc.), as well as throwing in a rather nice modal login box that I wrote using jQuery.

The relaunch went pretty smoothly, though initially I had some problems with transferring packages/modifications from my development server over to the live site, but during the early hours of last night and much of today I've successfully squashed most of the major issues.

There are some features that I was unable to bring over from the old SMF install, but I hope to be able to add these as soon as their packages have been updated/fixed to work correctly.

If you're interested in seeing the difference of the board from before, to now, here are a couple of full-page screenshots comparing the old and new:


{% include posts/figure.html src='Dingoonity---Index-OLD-thumb.png' linkurl='/images/Dingoonity%20-%20Index%20OLD.png' %}{:.massive.center}

{% include posts/figure.html src='Dingoonity---Index-NEW-thumb.png' linkurl='/images/Dingoonity%20-%20Index%20NEW.png' %}{:.massive.center}
