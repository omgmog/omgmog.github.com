---
title: Building a Home NAS from Mostly Spare Parts
comments_issue: 138
tags: [linux, nas, guide]
syndication:
  - https://social.omgmog.net/2026/new-blog-post-building-a-home-nas
  - https://indieweb.social/@omgmog/116120634329000893
---

I've had a SNUNMU GK3 mini-PC kicking about since early-2023, barely used. An impulse buy that ended up on a shelf, alongside a drawer full of old drives from various machines and NAS attempts that never quite came together. Picking up a 5-bay USB enclosure finally gave me a reason to use all of it. It's not polished and it's not redundant, but it's simple, flexible, and entirely under my control.

<!-- more -->

## The hardware

{% include posts/figure.html src="2026-02/snunmu-gk3.png" %}{:.center}

The SNUNMU GK3 is one of those cheap Chinese mini-PCs from Amazon.

| Feature | Details |
|---------|---------|
| **CPU** | Intel Celeron J4125 (quad-core, 2.0GHz base, 2.7GHz burst) |
| **RAM** | 12GB DDR4 |
| **Storage** | 128GB M.2 SSD (built-in) |
| **Network** | Gigabit Ethernet + Wi-Fi |
| **USB** | USB 3.0 ports |
| **Cost** | About £150 back in 2023 |
{:.massive}

There's no official website or support page for the SNUNMU GK3. The Amazon listing is about all you'll find. That's pretty typical for these no-name mini-PCs, but it does mean you're on your own if anything goes wrong.

The [Yottamaster FS5RU3](https://www.amazon.co.uk/dp/B085DS8XDS) (£179) is a 5-bay USB 3.0 enclosure with solid aluminium construction, hot-swappable bays, and a fan that's barely noticeable. I filled all five bays with old hard drives, 4TB x2, 2TB, 1TB, and 750GB.

It supports hardware RAID (0, 1, 3, 5, 10), but mismatched drive sizes make that awkward, and I don't need the extra complexity. I'm running it in JBOD mode instead, roughly 11.75TB raw, each drive mounted individually over USB 3.0.

{% include posts/figure.html src="2026-02/nas-setup.png" %}{:.center}

## The software

I tried OMV initially and it felt limiting. The web interface is nice for basic storage management, but once I wanted Docker containers, or anything beyond simple file shares, I was fighting it to do things I could do in a terminal in seconds.

So I went with plain [Debian](https://www.debian.org/releases/trixie/). On top of that I'm running:

- [**CasaOS**](https://casaos.io/) - a lightweight browser dashboard. It's in maintenance mode now (the developers have moved to [ZimaOS](https://www.zimaspace.com/)), but works fine on top of Debian. I've [tweaked it a bit](https://github.com/IceWhaleTech/CasaOS-UI/compare/main...omgmog:CasaOS-UI:main) (app grouping, a sorted app store, some clutter removed).
- [**Jellyfin**](https://jellyfin.org/) - media server for films, TV, music. Open source, no subscription nonsense.
- [**Portainer**](https://www.portainer.io/) - web UI for managing Docker containers without dropping into the CLI every time.

{% include posts/figure.html src="2026-02/casaos-dashboard.png" %}{:.massive}

## Setting up the drives

CasaOS has its own auto-mounting, but it kept overriding my mount points and dumping drives into `/DATA/USB_Storage1`. I set up fstab entries by hand instead. All the drives are ext4. USB drives can end up as a different `/dev/sdX` after a reboot, so I used UUIDs.

```bash
sudo mkdir -p /mnt/media/{4tb-a,4tb-b,1tb,750g,2tb}
```

```
# /etc/fstab - Media disks (ext4)
UUID=3040769c-... /mnt/media/4tb-a  ext4 defaults,noatime 0  2
UUID=e909fd59-... /mnt/media/4tb-b  ext4 defaults,noatime 0  2
UUID=ac8bdcdc-... /mnt/media/2tb    ext4 defaults,noatime 0  2
UUID=76c68f31-... /mnt/media/1tb    ext4 defaults,noatime 0  2
UUID=815f72aa-... /mnt/media/750g   ext4 defaults,noatime 0  2
```

The fiddly bit was permissions. Jellyfin runs as its own user, so it can't access files owned by my `max` user by default. I added it to my user group and set permissions:

```bash
sudo chown -R max:max /mnt/media
sudo chmod -R 775 /mnt/media
sudo usermod -aG max jellyfin
sudo systemctl restart jellyfin
```

For Samba, one share over `/mnt/media` covers everything. The physical layout doesn't matter. I can browse `smb://mothra/Media` (`mothra` being the hostname, Kaiju-themed) from any machine on the network and see all the drives as subdirectories. Samba has its own password database, so I needed to add my user there too (`sudo smbpasswd -a max`).

```ini
[Media]
   path = /mnt/media
   browseable = yes
   read only = no
   guest ok = no
   valid users = max
   create mask = 0664
   directory mask = 0775
   force group = max
```

One issue that crept up after a few days was the drives disconnecting overnight due to USB power management putting the enclosure to sleep. I'd have to run `mount -a` each morning to get them back.

The fix is a udev rule targeting the Yottamaster's USB controller by vendor and product ID (`152d:0567`), telling the kernel to leave power management alone:

```bash
sudo tee /etc/udev/rules.d/99-yottamaster-usb-power.rules >/dev/null <<'EOF'
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="152d", ATTR{idProduct}=="0567", TEST=="power/control", ATTR{power/control}="on"
EOF

sudo udevadm control --reload
sudo udevadm trigger
```

That sorted it.

I'm organising by media type (films, series, music) rather than worrying about which physical drive things land on. I've got about 20 years of media to consolidate from various machines and old drives, so it's a dump-and-sort job.

## Working from anywhere

Back in 2022 I [set up a Raspberry Pi as a local dev server](/post/raspberry-pi-local-dev-vscode-remote/) to keep project files in one place. It worked, but the Pi was slow, storage-limited, and only ever doing one job. The NAS replaces it, same idea but with proper storage and room for Docker containers too.

The NAS is the machine; everything else is just a keyboard and screen. This post was written that way. I started drafting it at my desk, moved to the sofa, carried on from my laptop. Same files, same project, no copying or syncing. I've got [lazygit](https://github.com/jesseduffield/lazygit) on the server for staging and committing. VS Code's Remote SSH forwards ports too, so Jekyll running in Docker appears as `localhost:4000` on whatever machine I'm on.

## The first dead drive

A couple of days after getting everything set up, I heard a loud persistent beeping from the room where the NAS lives. The Yottamaster enclosure has an alarm for drive failures, and it was _not_ subtle. The 750GB had gone bad.

I shut down the machine, powered off the enclosure, ejected the dead drive, and booted back up. Debian dropped into recovery mode because fstab still had mount points for a drive that no longer existed. Logged in as root, commented out the 750GB entry in fstab, rebooted, and everything came back up fine.

The 750GB was a random pull from my drawer of old drives. Turns out I bought it in 2008, so no great loss. I'd already moved everything off it onto the newer 4TB drives and formatted it fresh, so nothing was lost.

I'm keeping this simple on purpose. No drive pooling, no RAID, no fancy backup setup. It's a home NAS for media and project files, not a production server. If a drive dies, I lose whatever was on it, and for 20-year-old rips of films I already own, that's a risk I can live with.

## What it actually cost

The Yottamaster enclosure was the only thing I bought: £179. The mini-PC was already here doing nothing, the drives pulled from old machines and previous NAS attempts. Scraped together rather than purpose-built.

A Synology would have meant starting fresh, £400+ for a 4-bay, then drives on top, all tied to their OS and ecosystem. Instead, I got five bays, whatever OS I want, and full control for £179.
