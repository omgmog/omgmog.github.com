---
title: CHIP Stuff
comments_issue: 107
tags: [chip]
---

> This page is a changing document. I'll probably add more notes to it in the future.

These are just some notes that I've put together in the past about flashing and upgrading the [CHIP](https://en.wikipedia.org/wiki/CHIP_(computer)) (and Pocket CHIP) computer. 

<!-- more -->

This device doesn't have any first party support any more, and it's not as powerful as Raspberry Pi, but it's quite fun and the Pocket CHIP form-factor is great. If you can get hold of one, you should!

## Erasing and re-flashing the CHIP

You can erase and factory flash a CHIP from your computer using [this repo](https://github.com/Thore-Krug/Flash-CHIP). It will completely erase the CHIP, so make sure you have anything important backed up.

First you need to jumper the CHIP in FEL mode. You can do this by connecting the FEL pin to any GND pin:

{% include posts/figure.html src="felmode.jpg" %}{:.center}

Next you can clone the repo and run the `Flash.sh`:

```shell
git clone https://github.com/Thore-Krug/Flash-CHIP.git
cd Flash-CHIP
sudo chmod +x Flash.sh
./Flash.sh
```

## Making APT work with a mirror of the NTC APT repository

This will replace the now defunct _nextthing.co_ APT repositories with a mirror provided by _chip.jfpossibilities.com_

1. Open `/etc/apt/sources.list` in your editor
    ```shell
    sudo nano /etc/apt/sources.list
    ```
2. replace all instances of `opensource.nextthing.co` with `chip.jfpossibilities.com`
3. remove `jessie-updates` repositories
4. change `jessie-backports` to:
    ```
    deb http://deb.debian.org/debian jessie-backports main contrib non-free
    deb-src http://deb.debian.org/debian jessie-backports main contrib non-free
    ```
5. Disable `apt valid` check:
    ```shell
    echo 'Acquire::Check-Valid-Until "0";' | sudo tee /etc/apt/apt.conf.d/10-no-check-valid
    ```
6. In `/etc/apt/preferences` replace `opensource.nextthing.co` with `chip.jfpossibilities.com`
7. Lastly, make sure everything is up to date
    ```shell
    sudo apt update
    sudo apt upgrade
    ```

## Making APT work with a mainline Debian APT repository

This will replace all of the APT repositories with mainline Debian mirrors. This is best done on a fresh install.

1. Open `/etc/apt/sources.list` in your editor
    ```shell
    sudo nano /etc/apt/sources.list
    ```
2. Replace all lines of `sources.list` with the following (you can use a more local mirror rather than the `ftp.uk.debian.org` if you prefer):
    ```
    deb http://ftp.uk.debian.org/debian/ jessie main contrib non-free
    deb-src http://ftp.uk.debian.org/debian/ jessie main contrib non-free

    deb http://ftp.uk.debian.org/debian/ jessie-updates main contrib non-free
    deb-src http://ftp.uk.debian.org/debian/ jessie-updates main contrib non-free

    deb http://security.debian.org/ jessie/updates main contrib non-free
    deb-src http://security.debian.org/ jessie/updates main contrib non-free
    ```
3. Make sure everything is up to date and install `apt-transport-https` as it will likely be missing
    ```shell
    sudo apt update
    sudo apt upgrade
    sudo apt install apt-transport-https
    ```
4. Generate missing locales:
    ```
    sudo apt install locales
    sudo locale-gen en_US en_US.UTF-8 
    sudo dpkg-reconfigure locales          
    sudo dpkg-reconfigure tzdata    
    ```

Don't bother trying to `dist-upgrade` to a newer Debian version as it tends to break stuff. 🤷

## Installing a newer (> 3.7) version of Cmake on the CHIP

1. Remove any version of `cmake` installed from `apt`
    ```shell
    sudo apt remove --purge --auto-remove cmake
    ```
2. Download the "Unix/Linux Source" tar.gz from [https://cmake.org/download/](https://cmake.org/download/) (I've used the 3.15.0-rc1 — so long as it's newer than 3.7 you should be fine)
3. Decompress the tar.gz somewhere and `cd` to it. 
4. Start the initial _bootstrap_
    ```shell
    ./bootstrap
    ```
5. Set up a `swapfile` so that we can run `make` with our limited resources on the CHIP
    ```shell
    sudo su -
    dd if=/dev/zero of=/tmp/swapfile bs=1024 count=1048576 # 1gb swap file
    mkswap /tmp/swapfile
    chmod 600 /tmp/swapfile
    losetup /dev/loop0 /tmp/swapfile # create a loopback so we can use it
    swapon /dev/loop0

    #double check that it is mounted
    cat /proc/swaps
    ```
6. Start the build
    ```shell
    make -j2 # j4 caused the CHIP to hang
    # will take a couple of hours...
    sudo make install
    ```
7. After that, check that the new version of `cmake` is installed and working
    ```shell
    cmake --version
    ```