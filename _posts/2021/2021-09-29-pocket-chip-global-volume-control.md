---
title: Adding Global Volume Control to the Pocket CHIP
comments_issue: 110
tags: [chip]
---

I've been gradually [adding internal speakers to each of my Pocket CHIPs](/post/pocketchip-internal-speaker/) lately and found it cumbersome to have to either open `alsamixer` or use the volume control page in the Pocket CHIP launcher to control volume.

<!-- more -->

The Pocket CHIP uses [awesome](https://awesomewm.org) as it's window manager. With awesome you can use the Lua language to script the appearance and behaviour of the user interface, write functions, bind shortcuts to key presses, etc.

I decided to use this to add volume control. With my changes to `~/.config/awesome/rc.lua` you can simply press `ctrl`+`↑` or `ctrl`+`↓` and the volume will increase or decrease by 10% respectively.

{% include posts/figure.html src="chip-stuff/2021-09-29-095017-480x272-scrot.png" %}{:.center}

{% include posts/figure.html src="chip-stuff/2021-09-29-095101-480x272-scrot.png" %}{:.center}

The changes are quite simple, first I defined some functions:

```lua
volume_up = function ()
    volume_ctl("up", 10);
end
volume_down = function ()
    volume_ctl("down", 10);
end

volume_ctl = function (direction, amount)
  local current_vol = awful.util.pread("amixer sget 'Power Amplifier' | awk -F '[][]' '/dB/ {print substr($2, 1, length($2) - 1)}'")
  current_vol = current_vol:gsub("[\r\n%z]", " ")
  local target_vol = current_vol
  if direction == "up" then
    target_vol = current_vol + amount
    if target_vol > 100 then
      target_vol = 100
    end
  else
    target_vol = current_vol - amount
    if target_vol < 0 then
      target_vol = 0
    end
  end
  awful.util.pread("amixer sset 'Power Amplifier' "..target_vol.."%")
  naughty.notify({
    text="Volume: "..target_vol.."%",
    timeout=1
  })
end
```

I'm using the output from `amixer sget` piped through to `awk` to get the current volume, adding/substracting 10 from that value and then using `amixer sset` to update the volume.

The Pocket CHIP is using an older `3.4.15` build of awesome, so the methods to get text from a subcommand are a bit different than the [currently available docs](https://awesomewm.org/doc/api/) but I browsed the [3.4 source on Github](https://github.com/awesomeWM/awesome/tree/3.4/lib) and worked out how to achieve what I needed.

Once the functions are defined, they just need to be bound to a key. Find the `Key bindings` block and add the new bindings:

```lua
awful.key({"Control",}, "Up", volume_up),
awful.key({"Control",}, "Down", volume_down),
```

I've posted the entire `rc.lua` as a [gist on Github](https://gist.github.com/omgmog/d48012308baf369c8637d395982b44a1).

### Caveats

I've limited the volume range to between 0-100%. You can go higher than this in `alsamixer` directly, but it seemed sensible to have a limit. A volume level of around 50% sounds best to me.

Though the volume level is changed, the slider found in the launcher UI doesn't update automatically to reflect the current volume level. That's not something I can control.

Sometimes the increment amount seems a bit random. The functions are adding/substracting 10% each time but somehow `amixer` adds a random 1% here or there. If you want more fine control you can adjust the `volume_up` and `volume_down` functions in your `rc.lua` to use a smaller value.
