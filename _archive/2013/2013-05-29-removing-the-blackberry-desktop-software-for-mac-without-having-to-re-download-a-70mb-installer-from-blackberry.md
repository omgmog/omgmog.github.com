---
title: Removing the Blackberry Desktop Software for Mac without having to re-download a 70mb installer from Blackberry
comments_issue: 92
---
If you happen to have installed the Blackberry Desktop Software and you want to remove it and it's annoying persistant daemons, you might have discovered that this can only be done by downloading the [70mb installer dmg](http://us.blackberry.com/software/desktop/desktop-mac.html), and running the uninstaller.

<!-- more -->

{% include posts/figure.html src="bb-trash.png" %}{:.massive.center}

That's not an issue if you still have the installer dmg from when you errantly found yourself installing the Blackberry Desktop Software, but in my case (and my fastidious `~/Downloads` cleaning habits) I no-longer posessed the installer dmg, and (even though it wouldn't take long) I didn't want to redownload it.

After a bit of Googling, I came across [a forum post with the major part of the uninstaller](http://supportforums.blackberry.com/t5/Desktop-Software-for-Mac/How-do-you-Remove-Desktop-Manager/m-p/564538) (a shell script) pasted verbatim.

Unfortunately, the uninstaller script doesn't work as is without the cushy double-clickability of the uninstaller, so I've consolidated it in to the following simple script that just does all of the unregistering and removing of files:

```bash
#!/bin/sh
if [ $UID -ne 0 ]; then
    echo "Script must run as root"
    exit 1
fi
/Library/Application\ Support/Blackberry/BBLaunchAgent.app -ndefault /Applications/BlackBerry\ Desktop\ Manager.app >> /dev/null
rm -fr "/Applications/BlackBerry Desktop Manager.app"
rm -fr "/Library/Receipts/blackberrydesktopmanager.pkg"
rm -fr /Users/*"/Library/Application Support/BlackBerryDesktop/"
rm -f /Users/*"/Library/Preferences/com.rim.blackberrydesktopmanager.plist"
rm -fr /Users/*"/Library/Caches/com.rim.blackberrydesktopmanager"
/Library/Application\ Support/BlackBerry/BBLaunchAgent.app -ipndefault /Library/Application\ Support/BlackBerry/IPModemPasswordDialog.app >> /dev/null
rm -fr "/Library/Application Support/BlackBerry/IPModemPasswordDialog.app"
rm -fr "/Library/Modem Scripts/RIM IP Modem.ccl"
rm -fr "/Library/Frameworks/RIM_VSP.framework"
rm -fr "/Library/Receipts/blackberryvsp.pkg"
rm -f "/Library/Preferences/com.rim.vsp.plist"
rm -fr "/System/Library/Extensions/RIMBBVSP.kext"
rm -fr "/Library/Receipts/blackberryvspdr.pkg"
rm -f "/Library/Preferences/com.rim.RIMBBVSP.plist"
sudo -u "${currentUser}" launchctl unload /Library/LaunchAgents/com.rim.BBLaunchAgent.plist
launchctl unload /Library/LaunchDaemons/com.rim.BBDaemon.plist
rm -fr "/Library/Frameworks/RimBlackBerryUSB.framework"
rm -f "/Library/LaunchDaemons/com.rim.BBDaemon.plist"
rm -f "/Library/LaunchAgents/com.rim.BBLaunchAgent.plist"
rm -fr "/Library/Application Support/BlackBerry"
rm -fr "/Library/Receipts/blackberryframeworks.pkg"
rm -f "/Library/Preferences/com.rim.RimBlackBerryUSB.plist"
rm -f "/Library/Preferences/com.rim.RimLaunchAgent.plist"
rm -f /Users/*"/Library/Preferences/com.rim.RimLaunchAgent.plist"
rm -fr "/System/Library/Extensions/BlackBerryUSBDriverInt.kext"
rm -fr "/System/Library/Extensions/RIMBBUSB.kext"
rm -fr "/Library/Receipts/blackberryusbdriverint.pkg"
rm -f "/Library/Preferences/com.rim.BlackBerryUSBDriverInt.plist"
rm -f "/Library/Preferences/com.rim.RIMBBUSB.plist"
pkgutil --forget "com.rim.blackberrydesktopmanager.BlackBerryFrameworks.pkg"
pkgutil --forget "com.rim.blackberrydesktopmanager.BlackBerryUSBDriver.pkg"
pkgutil --forget "com.rim.blackberrydesktopmanager.BlackBerryUSBDriverVSP.pkg"
pkgutil --forget "com.rim.blackberrydesktopmanager.BlackBerryVSP.pkg"
pkgutil --forget "com.rim.blackberrydesktopmanager.Application.pkg"
killall BBLaunchAgent.app
rm -fr /Library/Application\ Support/BlackBerry/
exit 0
```

[Download from the gist at GitHub](https://gist.github.com/omgmog/5672581)
