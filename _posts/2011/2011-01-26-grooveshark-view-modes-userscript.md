---
title: "Grooveshark view-modes userscript for Fluidapp/Chrome/GreaseMonkey"
tags: [javascript, tutorial]
archived: true
archive: blog.omgmog.net
archived_comments:
- author: "Tim"
  date: April 15, 2011
  content: |
    This is fantastic! Thank you so much!- Tim.
---

{% include posts/figure.html src="2011-01/gs-ss-fullmode.jpg" %}{:.center}

I've created a userscript to give the Grooveshark website some view modes. This is specifically for use with Fluid, but I imagine it would work okay with Chrome/etc too.

More information about the userscript/setup after the break!

<!-- more -->

## Prerequisites

- Fluid - [http://fluidapp.com/](http://fluidapp.com/) (Mac OS X - Windows users might be able to use [Prism](https://addons.mozilla.org/en-US/firefox/addon/mozilla-labs-prism/))
- My "Grooveshark view modes" userscript
- A nifty Grooveshark icon (I found this on Google, it's 512x512 so right-click and save it)

## Setting up Fluid

After you've downloaded and install Fluid, open the Fluid.app and you will be presented with a screen asking for the following details:

**URL:** [http://listen.grooveshark.com](http://listen.grooveshark.com)

**Name:** Grooveshark Web

**Location:** can leave this as your Applications directory

**Icon:** find the Grooveshark.png that you saved earlier

After that's done, and you've created your new Grooveshark app, go to your Applications directory and open it, you should be presented with a browser window with just Grooveshark loaded in it.

Now you need to change some of the application preferences

Under '**Appearance**' you'll want to set the following:

**Window Style:** Chromeless (None)

**Window Level:** Normal

**Window Shadow:** Off

Now to load the userscript. With the Grooveshark app loaded, in your menubar you should see a little 'script' icon next to the menu.

Click this and go to "Open Userscript Folder", this will open up the userscript folder for this Grooveshark Fluid application. You can copy or save my "viewmodes.user.js" to this directory now, and then go back to the 'script' menu, select "Reload All Userscripts", and then when you go to the 'script' menu again you should be able to select the "Grooveshark view modes" script.

You can now hit Cmd+R to reload the app, and you should now notice that the window positions itself to the top of your screen, and spans the whole width of the screen. This is now the default view mode.

You should notice four new icons at the top of the window:

- **Sidebar Toggle** - toggles the left sidebar. Currently there's an issue where you get some blank space to the right side of the playlist when using this, but this can be resolved by opening/closing the queue tray at the bottom of the window.

- **Fullmode Toggle** - returns you to this default 'fullmode' if you're already in either the queuemode or barmode.

{% include posts/figure.html src="2011-01/gs-ss-fullmode.jpg" %}

- **Queuemode Toggle** - collapses the window so that only the titlebar, controls/progress bar and queue tray are visible. This view is 250px tall.

{% include posts/figure.html src="2011-01/gs-ss-queuemode.jpg" %}

- **Barmode Toggle** - collapses the window even further so that only the titlebar and controls/progress bar are visible. This view is 110px tall.

{% include posts/figure.html src="2011-01/gs-ss-barmode.jpg" %}

## Manual configuration

If you'd like to adjust the default/full window height, you'll need to open the viewmodes.user.js in your favourite text editor, and look for the line that begins `var fullheight = 400;` you can change this to any numerical value.
