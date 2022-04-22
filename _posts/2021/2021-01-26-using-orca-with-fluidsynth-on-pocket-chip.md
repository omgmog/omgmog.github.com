---
title: Using ORCA with FluidSynth on the Pocket CHIP
comments_issue: 106
tags: [chip]
---

This post is about using the [ORCA](https://hundredrabbits.itch.io/orca) _livecoding playground_ on the [Pocket CHIP](https://en.wikipedia.org/wiki/CHIP_(computer)#Pocket_CHIP_and_Pockulus)

From the [ORCA wiki](https://wiki.xxiivv.com/site/orca.html):

> Orca is a two-dimensional esoteric programming language in which every letter of the alphabet is an operator, where lowercase letters operate on bang, uppercase letters operate each frame. This livecoding language is designed to procedurally generate MIDI, UDP or OSC messages.

<!-- more -->

So let's get started...

Follow the official ORCA instructions for [installing on Raspberry Pi](https://git.sr.ht/~rabbits/orca):

```shell
sudo apt-get install git libncurses5-dev libncursesw5-dev libportmidi-dev
git clone https://github.com/hundredrabbits/Orca-c.git
cd Orca-c
make          # Compile ORCA
./build/orca    # Run ORCA
```

After you've installed ORCA, install the binary to make it usable from anywhere:

```shell
sudo cp build/orca /usr/local/bin
```

Next, you'll want something for ORCA to output to (to make noise!) so you will need either a real MIDI device (e.g. over USB), or you could use a synthesizer. For this I'd recommend [FluidSynth](http://www.fluidsynth.org). You can install FluidSynth easily from the Debian apt repository:

```shell
# install the fluidsynth midi synthesizer
# this should also install the fluidsynth-soundfont-gm package too
sudo apt install fluidsynth
```

To launch FluidSynth:

```shell
# start fluidsynth, using the soundfont that installed with it:
fluidsynth --audio-driver=alsa /usr/share/sounds/sf2/FluidR3_GM.sf2
```

If you want to launch FluidSynth in the background you can use the `-i` flag.

Next you need to start ORCA and set it to output to the fluidsynth MIDI output device:

1. Press Ctrl+D in ORCA to bring up the menu
2. Go to "Midi Output"
3. Select "Synth input port (xxxx:0)"

Channels 0-8 should be piano, and 9 is a drum kit.

If you want to launch ORCA from the Pocket CHIP home menu, you could use pocket-home ([instructions here](https://github.com/o-marshmallow/PocketCHIP-pocket-home)) and add a shortcut to launch ORCA.

The icon command to use would be `vala-terminal -fs 8 --fullscreen -e orca`, but you'll also need to have FluidSynth or your MIDI synthesizer of choice running before you launch ORCA.
