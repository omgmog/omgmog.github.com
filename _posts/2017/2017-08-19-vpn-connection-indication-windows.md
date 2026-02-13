---
title: VPN Connection Indication on Windows
tags: [windows]
archived: true
---
As of tomorrow I'm going to be switching to working remotely. Same job, just from the comfort of my home office (and without 2-3 hours of commute daily!). With this change I figure I'll have about 8-10 hours of _extra time_ per week to work on things.<!-- more -->

So I've got a couple of posts lined up for my blog, and some big plans for UX of VR.

As to the technical side of working from home, I find myself predominantly using Windows 10 for this, and connecting to work over VPN.

Windows lacks a nice way to manage VPN connections and indicate VPN connection status -- it's all _click 10 times and then cross your fingers_. I've been digging around for a solution to this, and have settled on a couple of oldish Windows apps to make this nicer:

1. [VPN Connection Indicator](http://www.weseman.net/vpnconnectionindicator/)
2. [Tray Tools 2000](http://www.gregorybraun.com/TrayTool.html)

The first simply indicates if you're connected to a VPN or not, the second allows you to make custom command icons for the system tray.

I've got two commands set up in Tray Tools:

First, single-click connect to VPN. This uses the built-in `rasdial.exe` that comes as part of Windows since _forever_. You simply run that along with the name of the VPN to connect to, and it connects:

```
C:\Windows\System32\rasdial.exe "Name Of Your VPN"
```

Second, single-click disconnect from VPN. This uses the built-in `rasphone.exe` that also comes as part of Windwos since _forever_. Again you just run this with the name of the VPN to disconnect from, and the `-h` flag:

```
C:\Windows\System32\rasphone.exe -h "Name Of Your VPN"
```

Right now I'm using some of the 90s-esque icons that come bundled with Tray Tools, but I think I'm going to make something a bit nicer if I get bored.