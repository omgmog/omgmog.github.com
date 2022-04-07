---
title: Launching Sketch Toolbox from inside Sketch
comments_issue: 55
tags: [guide]
---

I've been making use of [Sketch](http://bohemiancoding.com/sketch/) a lot lately. One of the coolest features of Sketch is it's plugin support.

I'm using a tool called [Sketch Toolbox](http://sketchtoolbox.com/) to manage plugins in Sketch -- this functions a lot like Package Control for Sublime Text, but it's a stand-alone application.

<!-- more -->

To get a smoother connection between Sketch and Sketch Toolbox, I've come up with the following technique.

{% include posts/figure.html src="sketch-to-sketch-toolbox.png" %}{:.massive.center}

## 1. Create an Automator Service to launch Sketch Toolbox from inside Sketch

1. Open Automator
2. Create a new 'Service'
3. In the 'Library', select 'Launch Application' and drag it to the right
4. Set 'Service receives' to 'no input'
5. Set 'in' to 'Sketch.app'
6. Set 'Launch Application' to 'Sketch Toolbox'
7. Save this service as 'Sketch Toolbox'

{% include posts/figure.html src="Screen Shot 2015-07-30 at 15.31.30.png" %}{:.massive.center}

## 2. Create an application keyboard shortcut for Sketch to trigger the service

1. Open 'Keyboard' in 'System Preferences'
2. Select the 'Shortcuts' tab
3. Add a new 'App Shortcut'
4. Set 'Application' to 'Sketch'
5. Enter the name you used for your service in 'Menu Title' (e.g. 'Sketch Toolbox')
6. Set the keyboard shortcut you would like, I used `cmd` + `shift` + `,`

{: .center}
{% include posts/figure.html src="Screen Shot 2015-07-30 at 15.31.58.png" %}{:.massive}

Now if you go to Sketch, and press the keyboard shortcut you configured, Sketch Toolbox will launch.
