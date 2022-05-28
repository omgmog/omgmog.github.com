---
title: Using a Raspberry Pi to Host a local Visual Studio Code Server
tags: [rpi, guide]
comments_issue: 117
syndication:
  - https://social.omgmog.net/2022/-a-new-blog-post-using-a
  - https://indieweb.social/@omgmog/108370156996002839
---

I tend to work on this blog from multiple machines in my home. These include a desktop PC running Windows, a MacBook Pro running macOS, and a Chromebook with the [Linux environment enabled](https://chromeos.dev/en/linux). Across all of these machines I primarily use [Visual Studio Code](https://code.visualstudio.com).

<!-- more -->

This blog and many other projects that I work on are hosted on Github and so each of these machines has it's own locally cloned copy of each projects repository. Each time I switch machines I have to ensure that I've pulled the latest version of the repository for the project I'm working on to the machine I'm working on.

I often [stash changes](https://www.git-scm.com/docs/git-stash) and forget about them. I might spend an evening working on a project from one machine to then not have those changes available on another machine when I have a moment to pick up where I left off. It's quite frustrating and leads to work being duplicated or forgotten about. Because of this changes don't make it up to the main project repository and don't get published (as is often the case with this blog).

Today I decided to finally try and tackle this issue by setting up a single offline point of change for working on my projects that I can pick up from any of my machines.

### Setting up the Raspberry Pi

I'm using a [Raspberry Pi 4 - 4GB](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/specifications/) that features a Quad core Cortex-A72 (ARM v8) CPU and supports the ARM64 variant of Raspberry Pi OS. 

{% include posts/figure.html src="2022-05/pi-code-server/pi-imager.png" %}{:.center}

Using the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) you can easily create a Raspberry Pi OS Lite 64-bit SD card. You can preconfigure the default hostname/user/Wifi credentials/SSH from the [Advanced options](https://www.raspberrypi.com/documentation/computers/getting-started.html#advanced-options) menu.

I'm using the hostname `dev` so that thanks to [mDNS](https://www.raspberrypi.com/documentation/computers/remote-access.html#resolving-raspberrypi-local-with-mdns) this Raspberry Pi will be accessible via `http://dev.local` when it's up and running.

### Setting up the Visual Studio Code clients

On each machine that you want to use to connect to the Raspberry Pi you'll need to configure Visual Studio Code. Begin by installing the [Visual Studio Code Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) and then open the command palette and select to _Connect to Host..._

{% include posts/figure.html src="2022-05/pi-code-server/remote-ssh-command-palette.png" %}{:.center}

The first time you do this it will prompt you for the host name and login credentials for the user on the host. After you've connected it will setup the VS Code Server on the host. You will now have access to a terminal and you will be able to select the remote directory to browse to in the file explorer.

Any software that you start up that exposes itself via a port will be magically forwarded to your `localhost` so it will function seemlessly as if you were working on the files locally.

### My particular use case

Back to my particular use case for this: working on my projects that are hosted on Github. First I needed to install and configure `git`.

```
sudo apt install git
```

And then go through the process of sorting out the [git user config](https://docs.github.com/en/get-started/getting-started-with-git/setting-your-username-in-git) and [SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/about-ssh).

```
# Config the user info
git config --global user.name "Your name"
git config --global user.email "youremail"

# Generate a new SSH key
ssh-keygen -t ed25519 -C "youremail"

# Add your SSH private key to the ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Next install `rvm` to select an appropritate `ruby` version.

```
# Run the RVM installer
gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable

# Make rvm available at login
echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile

# This is the version of Ruby that github-pages needs
rvm install 2.7 
```

Install the `github-pages` Gem to give us Jekyll and all of the Jekyll plugins that Github Pages supports

```
gem install github-pages
```

We can now run `jekyll` and Visual Studio Code will make it available to your local machine at `http://localhost:4000`.

I'm using `screen` so that I don't have to worry about stopping and restarting Jekyll as I move between machines:

```
# Install screen
sudo apt install screen

# Start screen
screen
```

If you start a new Terminal tab you can reconnect to the running screen easily to get back to what you were doing.

```
# Reconnect to the screen session
screen -r
```

### Going further...

One annoying thing with Jekyll is that if you've got your `site.url` configured and you use the `absolute_url` filter all over the place it might serve the site on one address (e.g. `127.0.0.1:4000`) but generate all internal URLs and resource URLs with another.

To get around this you can use the `--config` command line parameter and create a second config file that overrrides some of your main `_config.yml` options.

```yaml
# _dev.yml

url: http://dev.local:4000
host: dev.local
```

```
jekyll serve --watch --incremental --config _config.yml,_dev.yml
```

Now you can access your Jekyll site from the hostname of the remote server and all of it's generated URLs will use the same baseurl.

### Comparison to running locally

With a large website containing a lot of pages Jekyll can be a bit of a slog. Here's how the complete build times compare on my desktop, MacBook Pro,  Chromebook, and Raspberry Pi 4 (SD card):

| Device | Build time (cold, seconds) | Build time (serve/watch, seconds) |
| :----- | :------------------------: | :---------------------------: |
| Desktop (Windows 10)            | 2.674/2.537/2.656 | 1.527/1.449/1.266 |
| MacBook Pro (macOS Monterey)    | 1.513/1.556/1.552 | 0.963/0.509/0.541 |
| Chromebook (Linux environment)  | 8.539/8.744/8.698 | 8.033/7.918/7.864 |
| Raspberry Pi 4                  | 8.703/8.938/8.785 | 8.002/8.048/8.059 |
{:.massive}

~~As you can see the build time on the Raspberry Pi 4 is a bit slower than building locally on the desktop or MacBook. I can work around this by using the `--incremental` build flag to just build the pages that are actually being changed and cut the build time to around 2 seconds.~~

I wasn't happy with the ~8s build times on the SD card-based install. Thanks to [a comment from Philip Newborough](https://indieweb.social/web/@corenominal/108374237744275808), I was pointed to the fact that the Raspberry Pi 4 supports booting from USB so I switched to using an SSD with a USB 3.0 to SATA adapter.

Here's the build time with the SSD:

| Device | Build time (cold, seconds) | Build time (serve/watch, seconds) |
| :----- | :------------------------: | :---------------------------: |
| Raspberry Pi 4 (SD card)        | 8.703/8.938/8.785 | 8.002/8.048/8.059 |
| Raspberry Pi 4 (USB SSD)        | 4.922/5.022/4.965 | 1.846/1.797/1.652|
{:.massive}

If I use the `--incremental` build flag I see build times of ~0.7s. Much better!

### Closing thoughts

This is the setup I've been using for a couple of days now. I've been gradually bringing the various stashes and variations of my blog repository over to the main repository. 

I had originally tried this setup on a Raspberry Pi Zero W 2 but found that it wasn't powerful enough to run Visual Studio Code Server and my development stack without regularly crashing or taking a long time to build. 

Luckily the SD card I had setup for the Raspberry Pi Zero W 2 worked just fine in the Raspberry Pi 4 so I didn't hsve to configure everything from scratch when moving it over.