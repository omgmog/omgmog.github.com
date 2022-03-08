---
comments_issue: 47
title: Using the Zed editor with Arch Linux ARM on your Chromebook
---

I've been using Arch Linux on my HP Chromebook 11 for a little while now. One of the problems I've had with the setup has been that Sublime Text is not available for the ARM architecture.

<!-- more -->

This limitation has meant I've had to try other editors. I was making do with using Geany, but found the whole thing clunky and not nice to use.

Enter [Zed](http://github.com/zedapp/zed).

Zed is an editor that is available both as a Chrome App, and as a standalone application. The standalone version is only available for Windows, Mac, and Linux 32/64bit.

I'm running Chromium on my Arch Linux install on the Chromebook, so I've installed Zed as a Chrome App, and it works very nicely.

It's not very convenient to have to launch Chromium and then find the app launcher for Zed though, so I created a launcher directly for Zed in the following way:

```bash
$ chromium --app-id=pfmjnmeipppmcebplngmhfkleiinphhp
```

Where the `app-id` is the id of Zed Chrome App.

You can start this from the terminal, or create a launcher on your desktop, and you'll then be able to directly start Zed without having to open it via Chromium.

This method can be used to make any Chrome App directly launchable.
