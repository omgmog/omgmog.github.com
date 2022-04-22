---
title: Synchronising your Sublime Text 2 preferences with Dropbox
comments_issue: 93
---

I use [Sublime Text 2](http://www.sublimetext.com/2) both at work and at home, and it's hard to manually keep my settings/packages in sync.

<!-- more -->

I decided to use [Dropbox](http://db.tt/rQKT8rQ) to keep my packages/preferences for Sublime Text 2 in one place, and then I created a symbolic link from the Dropbox directory to the Application Support directory for Sublime Text 2:

## Mac OS (and Linux)

```
ln -sfF "~/Dropbox/Application Settings/Sublime Text 2/Packages/" "~/Library/Application Support/Sublime Text 2/Packages"
```

This command will create a symbolic link of the Packages directory stored in my Dropbox in the Sublime Text 2 directory, meaning that any computer I set up in this way will use the same settings/packages.

## Windows

```
mklink /D "C:\Users\Max\AppData\Roaming\Sublime Text 2\Packages" "C:\Users\Max\Dropbox\Application Settings\Sublime Text 2\Packages"
```
