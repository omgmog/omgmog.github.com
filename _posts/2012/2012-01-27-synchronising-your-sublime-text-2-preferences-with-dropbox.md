---
title: Synchronising your Sublime Text 2 preferences with Dropbox
comments_issue: 93
tags: [sublime-text, dropbox, guide]
archived: true
archived_comments:
- author: "Tomás Mayr"
  date: January 27, 2012
  content: |
    You forgot to thank me.
- author: "Max Glenister"
  date: January 27, 2012
  content: |
    No problem :)
- author: "Michael Merline"
  date: February 03, 2012
  content: |
    I'm getting a "syntax is incorrect" error on Windows. Any idea what I'm doing wrong? mklink /D “C:\Users\USER\AppData\Roaming\Sublime Text 2\Packages” “C:\Users\USER\Dropbox\Apps\Sublime Text 2\Packages"Also, should the folders I'm trying to link already exist before running the command?
- author: "Oaattia"
  date: February 13, 2012
  content: |
    Great One, thanks
- author: "Benaiah Mischenko"
  date: April 29, 2012
  content: |
    First, you have to replace the quotes - the quotes you copy from here are fancy curly quotes, and will kill the command. Second, The syntax of his command *is* incorrect: it should have the arguments the other way around. Third, you should create all but the final folder in the link path in your Dropbox folder. Hope this helps!
- author: "Guest"
  date: October 05, 2012
  content: |
    One issue to beaware of is related to keystroke bindings. Windows and Mac keystroke bindings are different, so it's probably best that you do this only if allyou computers run the same OS. Yes I found this out the hard way. Maybe there is a way around this, but I don't know what the solution is.
- author: "Guest"
  date: October 05, 2012
  content: |
    One issue to be aware of is related to keystroke bindings. Windows and Mac keystroke bindings are different, so I suggest you do this only if all your computers run the same OS. Yes, I found this out the hard way! There may be a way around this issue but I don't know the solution.
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
