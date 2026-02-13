---
title: Peanut Arduboy kit
tags: [arduino, gaming, diy]
archived: true
---

I finally got around to assembling this little [Peanut kit](https://www.tindie.com/products/ampersand/peanut-kit/) that I bought from Tindie a couple of months ago.

{% include posts/figure.html src="peanut/DvvCmsn.jpeg" %}{:.center}

The kit comes with everything you need (except a battery) to build a tiny (50 x 35mm) [Arduboy-compatible](https://arduboy.com/) handheld game.

{% include posts/figure.html src="peanut/s4SB3CS.jpeg" %}{:.center}

The specs are as follows:
- Arduino Pro Micro
- 0.96" OLED screen
- Piezo speaker

The [build instructions](https://onedrive.live.com/?authkey=%21AM3170F8ksXOKps&cid=66CB300826C22FA3&id=66CB300826C22FA3%2112661&parId=66CB300826C22FA3%2110695&o=OneUp) were very simple to follow, requiring only basic soldering skills (and a tiny SMD resistor to change out).

{% include posts/figure.html src="peanut/Eb4Pp8q.jpeg" %}{:.center}

Uploading games to the Peanut is pretty straight-forward. On Windows there are a [couple of applications available](https://arduboy.com/upload-games/). On Linux the process is a [little more involved](https://community.arduboy.com/t/arduboy-uploader-for-linux/6616) but it works great once you've got it set up. The only thing to note -- in my experience -- the `ATTRS{idProduct}` for the udev rules is slightly different with the Arduino Pro Micro provided in the Peanut kit, but you can easily find the correct value by checking the output of `lsusb`.

There's a bunch of games available on the [Arduboy forum](https://community.arduboy.com/c/games/35?order=op_likes) and also a nice [curated list of games](https://arduboy.ried.cl/) that can be automatically uploaded with the desktop app.
