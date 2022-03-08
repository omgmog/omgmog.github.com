---
title: Pico-8 on the Raspberry Pi with Game HAT
comments_issue: 104
---

I've been playing with [Pico-8](https://www.lexaloffle.com/pico-8.php) a lot lately. I've got a small Pico-8 project site to launch soon, but in the mean time I'm more occupied with getting Pico-8 running on _things_.

<!-- more -->

Enter Raspberry Pi, and with it the [Waveshare Game HAT](https://www.waveshare.com/wiki/Game_HAT) -- this is a nifty bit of kit. A screen, controls, and battery circuit that you just plug a Raspberry Pi in to, and voila you have a portable games console.

I've got mine set up with [Retropie](https://retropie.org.uk/) and this works with the Game HAT pretty much out of the box.

Here are the tweaks needed:

### Configure the display in your `/boot/config.txt`

This seems to vary from one Game HAT to another (according to the [Retropie forum](https://retropie.org.uk/forum/topic/20308/waveshare-game-hat-thoughts/9)) but I found that the following config lines worked when added to the end of the `config.txt`:

```conf
framebuffer_width=512
framebuffer_height=384
hdmi_group=2
hdmi_mode=87
hdmi_cvt=512 384 60
```

### Configure the buttons

The buttons on the Game HAT will work if you install the `mk_arcade_joystick_rpi` driver in `~/RetroPie-Setup/retropie_setup.sh` and then edit `/etc/modprobe.d/mk_arcade_joystick_rpi.conf` to contain:

```conf
options mk_arcade_joystick_rpi map=5 gpio=5,6,13,19,21,4,26,12,23,20,16,18
```

### Installing Pico-8

This is straight-forward. First you download the Raspberry Pi zip from your Pico-8 downloads page, extract it to your home directory, and install `wiringpi`:

```bash
# get Pico-8
$ cd
$ wget <your url to pico-8_0.1.11g_raspi.zip>
$ unzip pico-8_0.1.11g_raspi.zip

# install wiringpi
$ sudo apt install wiringpi
```
### Boot to Pico-8 (and Retropie while holding L)

There are all sorts of approaches that people have detailed elsewhere online to launch Pico-8 from the Retropie launcher, but I prefer the approach of configuring this install to be Pico-8 first, and then Retropie only if we're holding the `L` shoulder button at boot. This took some fiddling, but it's quite elegant:

First, edit your `/etc/profile.d/10-retropie.sh`, you can do this over `ssh` and run `sudo nano /etc/profile.d/10-retropie.sh`. Replace the contents with this:

```bash
# launch our autostart apps (if we are on the correct tty)
if [ "`tty`" = "/dev/tty1" ] && [ "$USER" = "pi" ]; then
        # if holding L shoulder button, start retropie
        if [[ "$(gpio -g read 23)" = "0" ]]; then
          bash "/opt/retropie/configs/all/autostart.sh"
        else
        # otherwise start pico8 by default
          /home/pi/pico-8/pico8 -height 320 -width 480 -splore && sudo reboot
        fi
fi
```

We're using the `gpio` command from `wiringpi` to check the value of GPIO pin 23 (`L` shoulder button on the Game HAT). If it's `0` (pressed) we launch the usual Retropie `autostart.sh`, otherwise we default to running Pico-8.

With the Pico-8 command, I'm specifying the output resolution and launching it with `-splore` to give us a games menu. The `&& sudo reboot` bit means that if you exit Pico-8 using the menu options, it will then reboot the Raspberry Pi so you can get back to Pico-8 or hold `L` and start with Retropie.


And that's it. If you want to make the most out of this you'll need to have your Wi-fi configured in Retropie. There are loads of great games on Pico-8 to enjoy, and they all work really nicely with the Game HAT controls. If you plug a keyboard in you can even create your own games!
