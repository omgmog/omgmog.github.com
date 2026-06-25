---
title: Running a Tailscale exit node in a local VM
comments_issue: 154
tags: [server, linux, guide]
syndication:
  - https://social.omgmog.net/2026/spent-a-few-hours-fighting-polkit-file
  - https://indieweb.social/@omgmog/116805713025113160
---

I run Tailscale on my laptops, phone and NAS, and wanted to add an exit node so I could route traffic through my own connection when I'm out and about. The obvious place to put it was the NAS, since it's already always on, but the NAS also holds everything I'd least like exposed if something went wrong. Making it double up as an exit node, with every device's outbound traffic flowing through it, didn't sit right. What I wanted instead was a disposable, isolated VM living on the same machine doing that job, leaving the NAS untouched.

<!-- more -->

## The plan

The plan was to build a small Debian VM with KVM/libvirt, running on the NAS, that would advertise itself as the exit node.

Tailscale handles its own NAT traversal and routing, so the VM doesn't need any special bridged networking. The default libvirt NAT network is enough. The VM just needs ordinary outbound internet access; once it's part of the tailnet and advertising as an exit node, other devices can route their traffic through it.

## Creating the VM

KVM/libvirt doesn't come installed by default, so I added it.

```bash
sudo apt install virtinst libvirt-daemon-system qemu-kvm
sudo usermod -aG libvirt $USER
```

On a headless terminal with no GUI polkit agent, adding myself to the `libvirt` group isn't enough on its own, since there's nothing to approve the authentication prompts. Running libvirt commands with `sudo` sidesteps that entirely. I also needed to pass `--connect qemu:///system` explicitly to `virt-install`, since it otherwise defaults to a _session_ connection rather than the _system_ one, and the session connection has no networks defined at all, including the `default` NAT network.

The default network exists but starts inactive, so I had to bring it up.

```bash
sudo virsh --connect qemu:///system net-start default
```

```bash
sudo virt-install --connect qemu:///system \
  --name exit-node \
  --memory 1024 --vcpus 1 \
  --disk size=8 \
  --location /var/lib/libvirt/images/debian12-netinst.iso \
  --network network=default \
  --os-variant debian11 \
  --graphics none \
  --extra-args "console=ttyS0"
```

Some flags caught me out. The VM process runs as the `libvirt-qemu` user, which can't read files in a home directory with typical `700` permissions. I moved the ISO to `/var/lib/libvirt/images/` instead of loosening directory permissions.

My system's osinfo database didn't know about `debian12` yet, only up to `debian11`, so I used that as the closest match. It only affects default tuning hints, not functionality.

With no `DISPLAY` set, there's no graphical console to install through. `--graphics none --extra-args "console=ttyS0"` gets a text installer directly over a serial console in the terminal, much nicer over SSH than fiddling with VNC.

`--extra-args` also requires `--location`, not `--cdrom`. `virt-install` can only inject kernel boot arguments when it extracts the kernel itself from an install tree. Booting the ISO directly via `--cdrom` skips that step entirely, so the flag gets rejected.

After the installer finished and rebooted, GRUB came up fine, but the boot hung silently at "Loading initial ramdisk...". Nothing was actually broken, the installed system's kernel just had nowhere to send its boot messages, since GRUB's installed config didn't carry over the serial console setting the installer used.

The fix was to edit the GRUB boot entry at boot time (`e` on the GRUB menu) and append this.

```
console=ttyS0,115200n8 console=tty0
```

Then boot with `Ctrl+X`. Once confirmed working, I made it permanent. No `sudo` yet at this point (the netinst image doesn't include it), so this was done as `root`:

```bash
su -
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="console=ttyS0,115200n8 console=tty0"/' /etc/default/grub
update-grub
```

(The GRUB editor uses emacs-style navigation over a serial line. I was nested so deep (SSH into the NAS, then libvirt's console forwarding into the VM) that the arrow keys didn't behave as expected. Had to move around with `Ctrl+B`/`Ctrl+F`/`Ctrl+N`/`Ctrl+P` instead.)

## Installing and configuring Tailscale

The netinst image doesn't include `curl` or `sudo` either, so while still in that root shell I installed both rather than keep dropping back to root for everything else.

```bash
apt update
apt install -y sudo curl
usermod -aG sudo <username>
```

Then, inside the VM:

```bash
curl -fsSL https://tailscale.com/install.sh | sh

echo -e 'net.ipv4.ip_forward = 1\nnet.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

sudo tailscale up --advertise-exit-node
sudo tailscale set --advertise-routes=192.168.0.0/24
```

After authenticating via the printed link, the new exit node needs approving in the admin console. Find the VM under Machines, open its route settings and tick _Use as exit node_, then approve the subnet route too.

The NAS, meanwhile, was never touched. It stays a normal tailnet member with no exit-node flag of its own.

## Sharing it outside my own tailnet

A friend in another country wanted to route through this exit node. Tailscale's "share a device" feature means someone outside a tailnet can reach a _specific_ shared machine, but the recipient can't use a shared device as an exit node. That's limited to devices in the same tailnet.

I had a few options. Inviting them into the tailnet itself was simplest, then they'd run `tailscale up --exit-node=<vm-hostname>` like any other device (after tightening ACLs so they could only reach the exit node). I could also run a SOCKS5/HTTP proxy on the VM via `ssh -D`, or something like `dante` or `tinyproxy`, and have them point their system at it directly. For a single trusted friend, inviting them into the tailnet with scoped-down ACLs felt cleanest.

A few hours of fighting polkit, file permissions and a silent serial console later, it's working. The NAS stays a plain tailnet member and the disposable VM does all the exit-node work.
