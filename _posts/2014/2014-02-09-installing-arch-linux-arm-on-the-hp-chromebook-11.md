---
title: Installing Arch Linux ARM on the HP Chromebook 11
comments_issue: 95
tags: [chromebook, arch-linux, linux, guide]
archived: true
archived_comments:
- author: "Max Glenister"
  date: February 11, 2014
  content: |
    From manually triggering sleep it wakes fine, and if I close the lid, wait a little while, then open the lid it wakes fine.edit:After closing it before going to bed, and it being closed for 8 hours, when I opened it this morning it resumed fine and had only used 2% battery
- author: "radicalpi"
  date: February 17, 2014
  content: |
    I'm having issues getting this to work. I encounter the following issues during the install process:"[: 13: Illegal number /dev/sda" - This is thrown at the start, doesn't seem to cause any actual issues. It still recognizes /dev/sda as my paramMounting Filesystems from /dev/sda"mount: /dev/sda3 already mounted or /tmp/root busy""mount: according to mtab, /dev/sda3 is already mounted on /tmp/root""[: 109: Illegal number: /dev/sda"I've tried forcing a umount of /tmp/root before this step.Writing uboot to /dev/sda11360+0 records in1360+0 records out"umount: /tmp/root: device is busy."Nothing seems to outright fail, but trying to boot with Ctrl+U just results in a beep, and it returning to the Recovery Menu
- author: "Max Glenister"
  date: February 17, 2014
  content: |
    How big is your USB stick? I've done the install now using a 2GB, 4GB and 32GB stick.Are you able to manually partition it using the isolated portion of the installer I've put here: https://gist.github.com/omg...When I have a moment tomorrow I'll back up my current (awesome) Arch setup and do an install from scratch again to see if I run in to problems like you've experienced.
- author: "radicalpi"
  date: February 17, 2014
  content: |
    I'm using a 32GB drive.I had to replace the $P variables with the actual partitions, but I was able to run the partition script without any troubles.
- author: "radicalpi"
  date: February 18, 2014
  content: |
    I went through the script and did each of the steps manually.I think the illegal number error is due to on line 11, using -eq to compare strings.The first resource busy error was due to /tmp/root not being unmounted before trying to remount it.The second error was do to trying to umount /tmp/root when /tmp/root/dev, /tmp/root/proc, etc were still mounted. umounting them in reverse order doesn't cause any issues.So, nothing seems to have failed in the script, just some warnings. However, it still won't boot from the flash drive.So I'm wondering if I'm doing something wrong at the boot prompt or if I missed a step.
- author: "Max Glenister"
  date: February 18, 2014
  content: |
    Thanks for your further investigation. I've updated the install.sh to use `if [ "$DEVICE" == "$EMMC" ]; then` on lines 7 and 75, so this should all work now.I'll be doing a complete run through on my Chromebook later today to ensure it's all working.
- author: "radicalpi"
  date: February 18, 2014
  content: |
    I believe my problem is the same one outlined here: http://archlinuxarm.org/for...Basically, larger drives may initialize too slowly for U-BOOT to detect them. There's a patch, but it hasn't been merged in.I tried the install script on a 16GB drive and it booted just fine.Thanks for your help.
- author: "Raychaser42"
  date: March 02, 2014
  content: |
    Hey. thanks for this. It was super helpful. Two things I noticed: When installing on mmcblk0 afterwards it doesn't recognize the terminal so I needed to switch my environment to TERM=rxvt in order to get the wifi-menu working so I can do anything else.Also my chromebook won't wake from sleep and the window manager won't load when I come back from terminal using CTRL-ALT-F7. Haven't solved that one.
- author: "Phil Norris"
  date: March 21, 2014
  content: |
    Hi. Thanks for writing this up. I got as far as running the 'sh install.sh /dev/sda' and got two error lines in response:install.sh: 12: declare: not foundinstall.sh: 13: Syntax error: "(" unexpectedDidn't get any further. Does that mean anything to you?
- author: "Phil Norris"
  date: March 21, 2014
  content: |
    OK. I have run those two lines manually and they work correctly. But they won't work within the script. So I am guessing that for whatever reason the script can't find the declare command. Does that help at all?The script is running in the /home/root directory
- author: "Max Glenister"
  date: March 21, 2014
  content: |
    Hi, thanks for your comment. It would appear that a recent pull request that I merged isn't working as expected. If you take the install.sh from my previous version it should work alright: https://github.com/omgmog/a...edit: I've reverted the pull, so the regular install.sh should work correctly now.
- author: "Phil Norris"
  date: March 22, 2014
  content: |
    Thanks. That's sorted it. Thanks for the prompt response.
- author: "Jason M"
  date: March 27, 2014
  content: |
    I've ran through the steps a few times. I've followed the steps to install it on the eMMC but I get 5 choices for libgl when I go through the post installation script. When I install the followinig packages step by step, mate-extra & lightdm-gtk2-greeter cause the following text to appear.resolving dependencies...:: There are 5 providers available for libgl::: Repository extra1) mesa-libgl:: Repository alarm2) gpu-viv-bin-mx6q-dfb 3) gpu-viv-bin-mx6q-fb 4) gpu-viv-bin-mx6q-wl 5) gpu-viv-bin-mx6q-x11After I select the default (1) choice, it proceeds with the installation. When it tries to change directories to /etc/X11/xorg.conf.d/ it fails to do that & then downloads the 10-monitor & 50-touchpad files into the current directory I started in. No problem, I make the directory & copy the files in there. When I reboot my HP chromebook 11 it comes up with a blank screen. Any ideas on what I'm doing wrong & did you come across these problems? Searching the web for answers with the libgl dependency is scarce. Thanks for your time.
- author: "Max Glenister"
  date: March 27, 2014
  content: |
    Hi Jason.I've not got my Chromebook with me to confirm right now, but off the top of my head you could try installing 'xf86-video-fbdev' and remove 'xf86-video-armsoc-chromium'.Let me know if that helps.Max
- author: "Jason M"
  date: March 28, 2014
  content: |
    I figured out the problem. When I ran your script, there was an unresolveable conflict between mate & mate-extra. This caused it to stop installing the remaining packages within that command. Also, I installed all of the packages that started with X, but I don't know if that made a difference. Thanks for your blog post & video for how to install arch!
- author: "Tuxie"
  date: April 08, 2014
  content: |
    How difficult would it be to install Debian and LUKS partition encryption on this machine? Any tips? Great work, - if it weren't for this article and your script, I might have passed on ordering a Chromebook. Thanks!
- author: "superneoo"
  date: April 15, 2014
  content: |
    i keep getting a watchdog messege over and over again help?
- author: "superneoo"
  date: April 15, 2014
  content: |
    it says mmcblk0 dose not exist ? and wont install to to hard emmc?
- author: "bwf"
  date: April 16, 2014
  content: |
    I successfully installed arch to my usb stick using your installer script, but when attempting to boot using `CTRL + U`, my chromebook 11 just beeps at me and throws me back to that screen; Any idea what might be wrong?
- author: "Max Glenister"
  date: April 16, 2014
  content: |
    Did you enable booting from USB? As I said in the post above:$ shell$ sudo su -$ crossystem dev_boot_usb=1 dev_boot_signed_only=0
- author: "superneoo"
  date: April 16, 2014
  content: |
    yeah it did that to me aswell try using a diffrent usb 4gb worked for me as the 8gb didnt?
- author: "Richard"
  date: April 22, 2014
  content: |
    I've followed all of these steps but all I ended up with was a blank screen.....all the steps completed corretly...but I has to install yaourt and trousers manually, because the install.sh script didn't install everything correctly. Any ideas on how I can fix this blank screen? I probably bricked the device :x
- author: "Richard"
  date: April 22, 2014
  content: |
    pacman -Syyu yaourt devtools-alarm base-devel git libyaml parted dosfstoolsThis line in install.sh causes problems. yaourt is not available in pacman repo, so need to add line to /etc/pacman.conf for this to work[archlinuxfr]SigLevel = NeverServer = http://repo.archlinux.fr/arm/This will then install yaourt from pacman: pacman -Sy yaourtThen you can install base-devel from packman, which allows you to install trousers.I did this, but still get blank screen on ctrl + d on boot?Hmmm..
- author: "Max Glenister"
  date: April 22, 2014
  content: |
    Hmm this is a new change. Thanks for looking in to that, I'll update the installer.edit:I've added this step to the installer now, could you try the eMMC part of the process again?Thanks
- author: "Richard"
  date: April 22, 2014
  content: |
    Hello Max,I get he error dd: failed to open 'arch-eMMC.kpart' no such file or directory on the last step, any ideas?
- author: "Max Glenister"
  date: April 22, 2014
  content: |
    That would indicate that the vbutil_kernel build step didn't work correctly for you. I've not seen that before..When I've got a moment later today I'll go through the whole process again on my Chromebook.
- author: "Richard Macarthy"
  date: April 22, 2014
  content: |
    Hello Max, the file arch-eMMC.kpart doesn't exist, anywhere I can generate or copy this into the correct directory? Thanks, Richard.
- author: "Max Glenister"
  date: April 22, 2014
  content: |
    Yeah that's what vbutil_kernel generates, lines 87-96 here: https://github.com/omgmog/a...You could try and run vbutil_kernel manually and see if it errors out at all.
- author: "Richard Macarthy"
  date: April 22, 2014
  content: |
    Got the error : Error reading keyblockThis file doesn't exist :/usr/share/vboot/devkeys/kernel.keyblockAny ideas?Thanks for your replys thus far Max.
- author: "Max Glenister"
  date: April 22, 2014
  content: |
    It would seem that your devkeys failed to copy over when you started the whole thing.Boot back to Chrome OS, insert USB stick once booted and do this from the shell:mkdir -p /tmp/rootmnt /dev/sda3 /tmp/rootmkdir -p /tmp/root/usr/share/vboot/devkeys cp -r /usr/share/vboot/devkeys/ /tmp/root/usr/share/vboot/Then boot from the USB stick again and try the install.sh to eMMC once more
- author: "Richard Macarthy"
  date: April 22, 2014
  content: |
    I cant actually boot into ChromeOS as I get that blank screen, will I have to recover ChromeOS and then do all of the steps again, do you think? Or is there an alternative?Thanks.
- author: "Max Glenister"
  date: April 22, 2014
  content: |
    Ah yeah in that case, make a recovery USB stick, reinstall ChromeOS, enable dev mode, and then go through my process again.https://support.google.com/...
- author: "Richard Macarthy"
  date: April 22, 2014
  content: |
    I got it, thanks. Ill let you know how it goes. Thanks for your help. Richard.
- author: "Richard Macarthy"
  date: April 22, 2014
  content: |
    Hello Max, Luckily I had a spare arch USB lying around so I managed to get the kernel files off there, upload them to FTP and wget them back onto the USB instance, phew! All working now and I have CTRL+D into arch from boot menu. Thanks for all of your help.Richard.
- author: "Richard Macarthy"
  date: April 22, 2014
  content: |
    Hello Max, sorry to bother you again. I got as far as the command line from CTRL+D but when I start x I just get another blank screen? I have done $X -configure and copied your .conf files to /etc/X11/xorg.conf.d but doesn't seem to work? Do you need to work on the post-install.sh script? Richard
- author: "Richard Macarthy"
  date: April 23, 2014
  content: |
    I have solved the issues, thanks for the tutorial, it's a very good start for someone looking to do this on their chromebook, however I think that you need to fully understand the entire process in order to get this working. Simply running the install script will most likely not work for the majority of people.All the best, Richard.
- author: "Charlie Daydream"
  date: May 02, 2014
  content: |
    Would this allow me to use Skype with chromebook 11's camera/microphone?
- author: "Pankaj Kumar"
  date: May 14, 2014
  content: |
    Can I make HP Chromebook 11 Android and ArchLinuxARM dual boot system? Can I perform regular LAMP development work on HP Chromebook 11? Please confirm.
- author: "Max Glenister"
  date: May 15, 2014
  content: |
    I've not seen anybody install Android on the HP 11, so I will say no for that. But if you find a way, that would be nice!Yes you can do LAMP development. The choice of editors isn't great though, but the Zed editor is nice http://blog.omgmog.net/post...
- author: "Pankaj Kumar"
  date: May 15, 2014
  content: |
    Thanks for reply. I am in the search of a computer in which I can install both Android and ArchLinuxARM. If you know such a computer then please send me its details. I shall be thankful to you for this.
- author: "Matt"
  date: June 06, 2014
  content: |
    Is there any chance to enable USB boot without booting? Is like I'm stuck at boot. I managed to use the shell code, but after rebooting it is not saved so I'm locked off.Even developer login seems not to work pressing ctrl d I'm stuck in a view to check/uncked for safe check.Any advice?
- author: "Bijan"
  date: June 24, 2014
  content: |
    Works great for creating the USB to boot to. But when trying to install to eMMC it gives some errors and then things start to kerplode:> Cannot resolve "package-query>=1.4" a dependency of "yaourt".> The following package cannot be upgraded due to unresolvable dependencies: yaourt> Do you want to skip the above package for this upgrade?
- author: "Steven"
  date: July 12, 2014
  content: |
    I have the same problem, even try to install package-query from source by makepkg -si, but no lucky. Any idea here?
- author: "Bijan"
  date: July 13, 2014
  content: |
    I've just been working from the USB drive if I want to mess with Arch Linux. I had managed to get it working pretty well a couple of times by manually installing and fixing a few things. But it got a little painful when I'd break things and had to start all over again. I feel like at some point one of us will take the initiative to take what's here and get it updated so that it's working smoothly again; but in the meantime it's tough with all the pieces that need to come together.
- author: "Max Glenister"
  date: July 14, 2014
  content: |
    Unfortunately packages on AUR go out of date, or their dependencies change, so things break.When I've got a free weekend I'll fix everything, but currently I'm quite short on time, and debugging the installer on a Chromebook takes a long time
- author: "Bijan"
  date: July 14, 2014
  content: |
    It's still a great project and I learned a ton. Thanks so much for putting all this together.
- author: "zoof"
  date: July 17, 2014
  content: |
    So just how well does it run? I'm sure it's not speedy but is it at least acceptable?
- author: "Max Glenister"
  date: July 17, 2014
  content: |
    It's as speedy as it can be for ARM.I can be quite productive with it, and have no problem going from my Macbook to the Chromebook.It seems for the most part faster than Chrome OS
- author: "zoof"
  date: July 17, 2014
  content: |
    So editing documents and light development (python) is fine?
- author: "jman6495"
  date: July 17, 2014
  content: |
    Great Article, but I'm curious : do you get any kind of Hardware acceleration (3D ? ) out of this ? what FPS does glxgears give you ?
- author: "Alex Tyler"
  date: July 21, 2014
  content: |
    Hi Max,I've got to booting off the USB and installing, but I'm getting an error when I try to start X. It stops after trying to load GLX and dumps back to the command line. Checking the logs the message is 'EXYNOS_BO_MAP failed: invalid argument'. I also noticed some errors further back in the log file relating to the 'fb' extension. Google has failed me unfortunately.Do you have any idea what might be going wrong please?Thank you
- author: "Max Glenister"
  date: July 21, 2014
  content: |
    Hi Alex, I'm gonna have to do a reinstall to see if I get the same issue.I'll reply again if I can find anything of help.Cheers,Max
- author: "Alex Tyler"
  date: July 21, 2014
  content: |
    Thanks for the quick reply Max.I asked on #archlinux-arm too, and the only thing they could think of was that it might be something to do with the DRM module, but I don't know where to go from there.Any info (even if its just broken for now) would be greatly appreciated. Thank you :)
- author: "jman6495"
  date: July 24, 2014
  content: |
    What's it like Hardware-Acceleration wise ? any 3D Support ?
- author: "Bruce"
  date: July 28, 2014
  content: |
    Thanks for the post, Max. Any idea if your script would work on the Samsung ARM Chromebook?
- author: "Max Glenister"
  date: July 28, 2014
  content: |
    Hi Bruce, there is a fork of my script that adds Samsung support. Take a look here https://github.com/mingming...
- author: "Max Glenister"
  date: August 01, 2014
  content: |
    Using the xf86-video-fbdev graphics driver, and this is a sample of the glxgears output:1061 frames in 5.0 seconds = 212.015 FPS1061 frames in 5.0 seconds = 212.126 FPS1049 frames in 5.0 seconds = 209.797 FPS1070 frames in 5.0 seconds = 213.954 FPS1061 frames in 5.0 seconds = 212.179 FPS1072 frames in 5.0 seconds = 214.228 FPS1078 frames in 5.0 seconds = 215.420 FPS1078 frames in 5.0 seconds = 215.587 FPS1073 frames in 5.0 seconds = 214.408 FPS1075 frames in 5.0 seconds = 214.921 FPS
- author: "Max Glenister"
  date: August 01, 2014
  content: |
    Hi Alex, I've taken a look at the installation script and made some tweaks and verified that it's all working now.If you have the time/patience to attempt an install again, it should be working.The biggest new change is that it's using xf86-video-fbdev instead of xf86-video-armsoc-chromium now.
- author: "Max Glenister"
  date: August 01, 2014
  content: |
    I think not as there is no ARM Skype client
- author: "Max Glenister"
  date: August 01, 2014
  content: |
    Yes, but I guess it depends on the editor. A full blown IDE might not be very nice, but something such as Geany or VIM will be absolutely fine.
- author: "Max Glenister"
  date: August 01, 2014
  content: |
    Hi Bijan, I've updated the script now and it should all be working fine. The script is no-longer depending on yaourt, so that shouldn't cause an issue any longer. Let me know how you get on.
- author: "Bijan"
  date: August 01, 2014
  content: |
    Nice! That's awesome Max thanks so much. I'll take a look this weekend and delve back into the darkness that is Linux.
- author: "bokal"
  date: August 01, 2014
  content: |
    I only get around 120fps with xf86-video-fbdev, care to share your xorg config or any package I may miss?
- author: "Bijan"
  date: August 02, 2014
  content: |
    Worked like a charm. Thanks so much man this is perfect.
- author: "Bijan"
  date: August 02, 2014
  content: |
    Just wanted to confirm that this is so awesome and it works great for anyone wanting to dust off their Chromebook. I've been sucked into it for hours installing things with pacman and tinkering. Thanks again, Max.
- author: "Bruce"
  date: August 02, 2014
  content: |
    Many thanks!
- author: "John Oldman"
  date: August 11, 2014
  content: |
    Hi Max, thank you for posting this.I had a couple of issues though:The link https://github.com/jquagga/...changed to:https://github.com/jquagga/...That was the easy one, my real problem is that there is no boot directory in my HP Chromebook 11 file system. Not in /root or /home/root.Have HP updated their file structure??Best regardsJohn
- author: "Max Glenister"
  date: August 11, 2014
  content: |
    Hi John,The link you mentioned is never directly used in my script, it builds the full url to https://github.com/jquagga/...Are you going through the steps exactly as I've explained above, and then running the install.sh?If you've enabled developer mode on the Chromebook you should have a root user, and so should have a /home/root when you follow my steps.It doesn't matter exactly where you download the install.sh to, so long as it's a directory that you're able to write to.
- author: "Kæde"
  date: September 09, 2014
  content: |
    He said it has 2% *less* battery, not that it only had 2% battery.
- author: "Brett Leaver"
  date: September 17, 2014
  content: |
    The Chromebook 11 only has 16GB of internal storage, has this been a problem for you?
- author: "Max Glenister"
  date: September 18, 2014
  content: |
    Nope, but I mostly just work on small git codebases, and browse the web. For large files I also use a low profile 32gb USB stick.
- author: "Petra Kowalski"
  date: September 21, 2014
  content: |
    is there a way to create a android live-usb on a hp chromebook ?
- author: "Dean Flood"
  date: October 11, 2014
  content: |
    Hi Max,When I try to boot from the USB it says:** Unable to read "/u-boot/boot.scr.uimg" from usb 0:12**.Repeated the prior steps twice now and same result. Any ideas?
- author: "Max Glenister"
  date: October 12, 2014
  content: |
    It seems that the source files for the install process may have changed. I'll fix this when I have a moment (possibly tonight).I'll let you know when it's fixed
- author: "Max Glenister"
  date: October 12, 2014
  content: |
    Hi Dean, I've updated the script with an additional step to check for the presence of boot.scr.uimg and if it doesn't exist, download and install it.If you try the process from the point of downloading my install.sh and creating your USB stick, it *should* now work.Let me know how you get on, cheers!
- author: "Dean Flood"
  date: October 13, 2014
  content: |
    Thanks Max,I'll give it a go when I have a few minutes and let you know!
- author: "Kris"
  date: October 14, 2014
  content: |
    Got everything up and running after I realized that you have to use a USB 2.0 drive. I am now having issues with the audio not working at all. Please help if you can.
- author: "Kris"
  date: October 17, 2014
  content: |
    Nevermind. I got the audio working, now to get the microphone working.
- author: "Andide"
  date: October 30, 2014
  content: |
    How did you fix the audio? I'm still frozen there.
- author: "Phil Norris"
  date: October 31, 2014
  content: |
    Hi. Just returned to this script after a few months, and it looks as if it may be broken in that it is unable to locate either parted or partprobe. I have checked that the path is set up correctly, and manually checked the directories, and they are not present. Having done a bit of research it appears that a recent update to ChromeOS has replaced them with some other similar utilities e.g partx.
- author: "Max Glenister"
  date: October 31, 2014
  content: |
    Hmm, just verified this on my HP 11. I'll update the script.
- author: "Max Glenister"
  date: October 31, 2014
  content: |
    Hi Phil, would you be able to test a patch that I've written to use `partx` instead of `parted`/`partprobe`?You can find the patch linked in this issue: https://github.com/omgmog/a...
- author: "Andide"
  date: October 31, 2014
  content: |
    Sorry Max, can you please provide some directions on how to make the audio work? The drivers were copied from the chromebook, and I can see a DAISY device in the preference panels, but it's not working, and I don't know were to start debugging it. Thank you!
- author: "Max Glenister"
  date: October 31, 2014
  content: |
    Hi Andide, the audio is a bit hit and miss, try unmuting the left/right channels in alsa-mixer
- author: "Phil Norris"
  date: October 31, 2014
  content: |
    Max, will do. Thanks for the very prompt response. I'll check it out in the morning and get back to you.
- author: "Phil Norris"
  date: November 01, 2014
  content: |
    Hi Max. Ok i tried this and have had a number of issues I have been working through which all seem to be based around the partx tool having problems reading the partition table (msdos) of my USB drive. After writing a new partition table (gpt) with fdisk, partx was able to proceed, although I got a could not stat /dev/sda12 error. Although running partx -l /dev/sda confirms that sda12 is there.Eventually the script ran to a conclusion but on reboot I get the following:*** Unable to use usb 0:12 for fatload ***Loading file "/boot/vmlinux.uimg" from usb 0:3 (Root)...and the boot hangs there. I am guessing this has something to do with the /dev/sda12 error mentioned above. I'll have another couple of goes to see if I can get partx to read all the partitions correctly.
- author: "Phil Norris"
  date: November 01, 2014
  content: |
    Just a further update, another run went through without any obvious errors, but on boot I got a bad image error. At this point I am thinking there could be an issue with the USB drive, so I'll try a different one later and see how that goes.
- author: "AC"
  date: November 01, 2014
  content: |
    and after completely wiping Chrome OS and replacing it with ArchLinux, how would one go back?
- author: "Max Glenister"
  date: November 01, 2014
  content: |
    You can make a Chrome OS recovery USB using this: https://support.google.com/...
- author: "Lance"
  date: November 09, 2014
  content: |
    I'm trying to run the patched script but it's failing since it can't find cpgt. Any suggestions?
- author: "hxc"
  date: September 02, 2015
  content: |
    Hi every one, I'm getting real mad since yesterday, I'm trying to install Arch on my hp chromebook 11 but it fails again and again... My bootable key is ready but at computer reboot, I've got errors :Reading /u-boot/boot.scr.uimg349 bytes read## Executing script at 42000000Loading file "/Vmlinux.uimg" from usb device 0:2 (kernel)**File not found /Vmlinux.uimg Card did not respond to voltage select!mmc_init err -17, time 11297mmc1(part 0) is current devicemmc_init err -19, time 3759**Partition 12 not valid on device 1****Unable to use mmc 1:12 for fatload****Bad partition 2**ERROR: Could not boot from USB or SDSMDK5250#=Unknown command '=' -try 'help'I've tried to make it on sevral USB keys and SD Cards nothing works...I really want to replace chrome os by arch so if anyone could help, it would be great !!!thanks in advanceregardsthibault
- author: "Max Glenister"
  date: September 02, 2015
  content: |
    The process has changed, and the script has not been updated yet.For now you should be able to get a USB stick working by following these instructions http://archlinuxarm.org/pla...eMMC install process still needs to be fixed.
- author: "bill"
  date: September 15, 2015
  content: |
    Hi Max, just wondering are you still using the chromebook or have you upgraded?
- author: "Max Glenister"
  date: September 15, 2015
  content: |
    Hi Bill, I'm not using the Chromebook as much as I was (due to having replaced it with a new, lighter MacBook Pro), but I've been playing with it a lot lately, working on an update to my install script to make everything work.One of the problems with depending on an external project (ArchLinux ARM) is that things change outside of my control, and naturally things break, so it's a fire-fight to keep everything going smoothly.
- author: "Abdu9"
  date: March 03, 2017
  content: |
    How can I login as root after installing install.sh on a usb and rebooting and entering ctrl + u?What is the command?
---

I concluded in my [previous post](/post/hands-on-with-the-hp-chromebook-11/) about the HP Chromebook 11 that it's a good device for casually browsing the internet, but it's no replacement for a regular laptop or desktop for getting stuff done.

{% include posts/figure.html src="IMG_20140210_150652.jpg" %}{:.massive.center}

Since that post I've not used the Chromebook very much, so with a vacant weekend I've decided to blow the dust off of the Chromebook and try to squeeze some more functionality out of it.

<!-- more -->

## Enter Arch Linux for ARM.

This guide will take you through installing Arch Linux ARM on a USB stick that can be booted by your HP Chromebook 11. I'll also explain how to go a step further and remove Chrome OS from your HP Chromebook 11 and install Arch Linux ARM directly on the eMMC (internal memory).

### Prerequisits
- HP Chromebook 11
- USB Stick (2GB should be enough)
- Some time (an hour or so)

### Pre-install steps
First of all, your Chromebook must be in Developer Mode. To do this, either boot while holding `esc` + `refresh` + `power`, or press those three keys while the Chromebook is booted.

When the device reboots it will present you with a scary message, where you should then press `ctrl` + `D` to enable Developer mode. It'll take a couple of minutes to download and install the Developer Mode files, but when it's done and it reboots, you can then boot Chrome OS by again pressing `ctrl` + `D` at the boot screen.

Next, you need to join your Wifi network, and then you can choose to 'browse as guest' or sign in to your Google profile. If you're going to be installing to the eMMC later, it'll be easier to just browse as guest.

When you're logged in to Chrome, press `ctrl` + `alt` + `T` to open the `crosh` terminal. Here you can become root and enable USB booting:

```bash
$ shell
$ sudo su -
$ crossystem dev_boot_usb=1 dev_boot_signed_only=0
```

### Using my `install.sh` to install Arch
Insert your USB stick, and dismiss any of the File Browser windows that open. Now, in your terminal execute the following commands, where `/dev/sda` is your USB stick:

```bash
$ cd /home/root
$ wget https://raw.githubusercontent.com/omgmog/archarm-usb-hp-chromebook-11/master/install.sh
$ sh install.sh /dev/sda
```

You'll be prompted through the process, it shouldn't take very long.

After the `install.sh` has finished creating the USB stick, you can reboot your Chromebook, and then press `ctrl` + `U` at the boot screen to boot from USB.

Login as `root`, with no password. You can turn on Wifi and connect to your Wifi network using the following:

```bash
$ wifi-menu mlan0
```

If you want to finish here, I would suggest using my `post-install.sh` to install Mate and lightdm, then get on with enjoying your new Arch install.

```bash
$ pacman -S wget
$ wget https://raw2.github.com/omgmog/archarm-usb-hp-chromebook-11/master/post-install.sh
$ sh post-install.sh
```

If you're feeling hardcore, why stop here? Let's install to the eMMC!

### Installing Arch to the eMMC on the Chromebook

Just like with installing to the USB stick, you need to download the `install.sh` and then invoke it, but this time specify `/dev/mmcblk0`

```bash
$ pacman -S wget
$ wget https://raw2.github.com/omgmog/archarm-usb-hp-chromebook-11/master/install.sh
$ sh install.sh /dev/mmcblk0
```

The installer will set up the partitions as before, install Arch, and then configure the Kernel so that your Chromebook can boot in to Arch.

Regarding the modification of the PKGBUILD for `trousers`:

This is the only package you need to modify. When prompted, press `y` to edit, open in `nano` or your preferred text editor, find the line that reads:

```bash
arch=('i686' 'x86_64')
```

and replace it with

```bash
arch=('armv7h')
```

## Doing real work on the HP Chromebook 11

{% include posts/figure.html src="IMG_20140211_130139.jpg" %}{:.massive}

Now that you've got Arch installed you can start using the Chromebook to do some real work. I use `Geany` as my text editor, have `git`, `ruby`, `gem`, `jekyll` and many other important applications installed.

I even authored this blog post from Arch on my Chromebook!

Let me know if you have any problems, or if you can improve the process in any way.

- [Arch ARM HP Chromebook 11 installer on GitHub](https://github.com/omgmog/archarm-usb-hp-chromebook-11/)
