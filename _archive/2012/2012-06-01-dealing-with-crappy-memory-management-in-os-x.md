---
comments_issue: 36
title: Dealing with crappy memory management in OS X
---
Using a lot of memory-intensive programs throughout the day, such as Virtualbox virtual machines, Photoshop and numerous browsers each with a couple of handfuls of tabs, you come to realise how bad the memory management in Mac OS X is.

<!-- more -->

Take the following screenshot, this is after having closed a bunch of programs because my 2011 iMac (with 12 GB of RAM) was crawling and reporting "11 MB" of free memory.

![These are not the MegaBytes of RAM you are looking for]({{ site.url }}/images/by%20default%202012-06-01%20at%2016.39.56.png)

OS X is being stupid -- or rather, it's probably trying to be quite smart, but it's failing to be smart, so it's being stupid. I've got 12 GB of RAM, and OS X is gasping for some RAM, but it has half of it set as "Inactive".

What does this mean? Well, to put it simply, when you close an application OS X retains that application in memory so that next time you open it up it opens really fast. This is great if you're only using your computer to browse Facebook in Safari, or if you're playing with Photobooth, but for any real-world tasks such as virtualising Windows 7 using Virtualbox, it's not so great.

Luckily there is a terminal command that will free up this "Inactive" RAM:

`$ purge`

Now, I'm pretty sure that you need to have the OS X Developer Tools installed to use `purge`, but if you're in the kind of situation that warrants purging your memory, you've probably already got it installed.

The result after running `purge`?

![That's more like it!]({{ site.url }}/images/by%20default%202012-06-01%20at%2016.42.44.png)

Wonderful.
