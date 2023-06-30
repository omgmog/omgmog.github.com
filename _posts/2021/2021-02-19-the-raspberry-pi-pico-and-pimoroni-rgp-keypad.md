---
title: "The Raspberry Pi Pico and the Pimoroni Pico RGB Keypad"
comments_issue: 108
tags: [rpi]
---

In January the [Raspberry Pi Pico was announced](https://www.raspberrypi.org/blog/raspberry-pi-silicon-pico-now-on-sale/). The Pico is a [RP2040 microcontroller](https://www.raspberrypi.org/documentation/pico/getting-started/) featuring a dual-core Arm Cortex-M0+ processor with 264KB internal RAM and support for up to 16MB of off-chip Flash. It's comparable to certain Arduino or ESP32 boards and at less than £4 per board it's a well-priced alternative.

<!-- more -->

{% include posts/figure.html src="picogpio.jpg" %}{:.center}

The Pico comes with 30 GPIO pins. These feature through-holes so you can solder your own header pins, and [castellations](https://www.pcbdirectory.com/community/what-are-castellated-holes-on-a-pcb) so you can easily flush mount the Pico to another circuit board and permanently integrate it into a larger project.

{% include posts/figure.html src="IMG_20210219_160021.jpg" %}{:.center}

## Everything's better with RGB lighting

I picked up a Pico along with [Pimoroni's RGB Keypad](https://shop.pimoroni.com/products/pico-rgb-keypad-base) add-on board from the Pimoroni store so that I could have a project for it from the get go.

The Keypad features 16 conductive buttons with translucent silicone keys, each with an individually addressable RGB LED, all arranged in a visually pleasing 4x4 grid.

By using the header slots on the RGB Keypad to hold the Pico and header pins in place I made short work of soldering the 40 header pins. Additionally I added a switch between the `RUN` pin and a nearby `GND` to allow the Pico to be easily rebooted without having to unplug/plug the USB cable.

{% include posts/figure.html src="IMG_20210219_160035.jpg" %}{:.center}

### So what can it do?

When you connect the Pico to your computer while holding the `BOOTSEL` button it mounts as a disk drive. From here you can configure the Pico to run C/C++, Python (CircuitPython or MicroPython). After that's done you just need to drop your Python script on to the drive and it will be executed. If you've ever used any of the Adafruit Feather family of boards, you will feel right at home here.

With the RGB Keypad the Pico can be used as a keyboard or any other HID device, which makes it perfect as a macro keyboard or _stream deck_. It could also be configured as a MIDI device so that it can be used as a _pico [launchpad](https://novationmusic.com/en/launch/launchpad-x)_.

Pimoroni have [released some example code](https://github.com/pimoroni/pimoroni-pico) to help with getting started with the Pico and RGB Keypad. Others have made fully working projects that [utilise the RGB Keypad as a macro keyboard](https://github.com/qbalsdon/pico_rgb_keypad_hid) to send keystrokes and switch macro profiles, all while making great use of the RGB LEDs.
