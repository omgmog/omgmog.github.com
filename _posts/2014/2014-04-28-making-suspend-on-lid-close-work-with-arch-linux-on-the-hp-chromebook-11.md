---
comments_issue: 44
title: Making suspend on lid-close work with Arch Linux on the HP Chromebook 11
---

The more time that I spend using Arch Linux on my HP Chromebook 11, the more things I find to tweak and tinker with.

The latest thing I've addressed is making suspend work when the lid is closed. After speaking to [my resident Arch guru](http://lumbercoder.com) about it, he pointed me to a [blog post that he wrote on the subject](http://lumbercoder.com/2013/12/28/how-to-lock-screen-and-suspend-i3.html), before actually showing me how to make it work.

<!-- more -->

The steps for what I wanted to achieve are actually a bit different to his guide, so I'll summarise them here:

Install `acpid` and `pm-utils`

```bash
$ sudo pacman -S acpid pm-utils
```

Edit /etc/acpi/handler.sh

```bash
$ nano /etc/acpi/handler.sh
```

Find the `button/lid` case

```bash
button/lid)
case "$3" in
    close)
        logger 'LID closed'
        ;;
    open)
        logger 'LID opened'
        ;;
    *)
        logger "ACPI action undefined: $3"
        ;;
esac
;;
```

Add the `pm-suspend` command inside the close case

```bash
button/lid)
case "$3" in
    close)
        logger 'LID closed'
        pm-suspend
        ;;
    open)
        logger 'LID opened'
        ;;
    *)
        logger "ACPI action undefined: $3"
        ;;
esac
;;
```

And there you go. For this to work straight away you'll need to restart the acpi service:

```bash
$ systemctl restart acpid
```

And that's it. Now when you close the lid, you should see that the lights on the back turn off, so you can tell it has suspended. To make this permanent you'll need to enable acpid on boot:

```bash
$ systemctl enable acpid
```
