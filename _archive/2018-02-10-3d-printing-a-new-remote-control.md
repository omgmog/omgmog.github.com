---
title: 3D Printing a new remote control
comments_issue: 101
---

I bought a 3D printer back in November last year and have been steadily filling my home office with 3D-printed miniatures, things to fiddle with, and functional solutions to problems that I didn't realise needed fixing since then.

<!-- more -->

This is the latest of such a problem that 3D printing is the answer for; It came the time to replace the nearly 10-year-old _Creative Inspire T6100_ because the volume control became a bit wonky and had developed a non-linear level of volume control. For the new speakers I opted for some _Trust GXT 658 Tytan_ speakers -- not a lot to say about them, they make noise what more can I say? they work fine and feature a remote to control things such as:

- on/off
- source
- mute
- backlight control
- subwoofer on/off
- subwoofer volume
- center speaker volume
- surround speaker volume
- volume

That's a lot of functionality for a remote, but worse than that it's all crammed in to a tiny remote with the most illegible labelling I've ever seen on any product. Here's how the remote looks (with the benefit of good lighting and being enlarged in a photo):

{% include posts/figure.html src="2018-02-10/IMG_20180210_121006.jpg" %}{:.center}

After a month or two of trying to use this remote, I realised I only actually need four of the fourteen buttons. The _on/off_ button (top left), the _subwoofer on/off_ button (second row, right) and the _volume_ (bottom row) -- so I figured this would be a perfect thing to _solve_ with my 3D printer.

{% include posts/figure.html src="2018-02-10/chrome_2018-02-10_12-57-51.png" %}{:.center}

I began by tracing the shape and layout of the controller, to produce an SVG of the basic proportions. I then took this SVG over to [Tinkercad](https://tinkercad.com) -- a great free website for modelling things in 3D/CAD that export to .STL. 

{% include posts/figure.html src="2018-02-10/chrome_2018-02-10_12-59-17.png" %}{:.center}

From there I exported an .STL file and loaded it up in Cura -- a free piece of software that prepares and slices your models before sending them to the 3D printer as _G-code_. Once I had confirmed that the "button" holes all lined up with the original remote, I looked to creating a model that could contain the innards of the original remote while retaining just the four buttons that I needed.

{% include posts/figure.html src="2018-02-10/IMG_20180210_121114.jpg" %}{:.center}

For this I went through a couple of variations of design, mostly varying the amount of like-for-like features I wanted to retain (such as the battery drawer), adding support for the remote PCB, and deciding how best to attach the two halves of my new remote together. With the tolerances in 3D printing it's hard to create small/thin snap-fit pieces, so I opted for creating a top piece that I simply super-glued to the bottom piece.

{% include posts/figure.html src="2018-02-10/IMG_20180210_121142.jpg" %}{:.center}

I used the _conductive rubber membrane_ inserts from a cheap clone NES controller that I had kicking around in a drawer, cutting the membrane to suit each button.

{% include posts/figure.html src="2018-02-10/IMG_20180210_121157.jpg" %}{:.center}

The final remote is roughly the same dimensions as the original remote, and a lot easier to use. I had attempted to print labels of "Power", "Sub" and "Vol" in the top piece of the new remote, but as you can see the lettering didn't come out very clear.

{% include posts/figure.html src="2018-02-10/giphy.gif" %}{:.center}
