---
title: Replacing the macOS audio switcher with SwiftBar
comments_issue: 121
tags: [guide]
syndication:
  - https://social.omgmog.net/2025/postbetter-macos-audio-switching
  - https://indieweb.social/@omgmog/115357178600304223
---

The built-in audio output menu in macOS has always felt a bit limited. The icons aren’t very helpful, the device names can’t be customised, and if you’ve got a few different outputs, it becomes tricky to quickly tell what’s what.

<!-- more -->

I wanted a faster and clearer way to switch devices, ideally without opening System Settings. Since I already use [SwiftBar](https://github.com/swiftbar/SwiftBar), I wrote a small plugin that gives me exactly that: a dropdown with my own labels and icons for each device, plus one-click switching.

{% include posts/figure.html src="2025-10/audio-switcher.gif" %}{:.center}

It’s powered by **SwitchAudioSource** (from [switchaudio-osx](https://github.com/deweller/switchaudio-osx)). You’ll need to install it first:

```bash
brew install switchaudio-osx
```

Once that’s in place, drop the script into your SwiftBar plugins folder and make it executable:

```bash
chmod +x audio-switcher.1m.sh
```

Here’s the script:

```bash
#!/usr/bin/env bash
# <bitbar.title>Audio Output Switcher</bitbar.title>
# <bitbar.version>2.7</bitbar.version>
# <bitbar.author>Your Name</bitbar.author>
# <bitbar.desc>SwiftBar-only output switcher using SF Symbols and UID matching. Active item tinted blue.</bitbar.desc>
# <bitbar.dependencies>bash,SwitchAudioSource</bitbar.dependencies>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

SWITCH_AUDIO_BIN="${SWITCH_AUDIO_BIN:-SwitchAudioSource}"

# ---- Config: one per line: Label|UID|SF Symbol ----
DEVICES='G635 Gaming Headset|AppleUSBAudioEngine:Logitech:G635 Gaming Headset:00000000:2|headphones
Stage V2|00-02-3C-99-0B-7C:output|speaker.wave.2.fill
MacBook Pro Speakers|BuiltInSpeakerDevice|laptopcomputer'

trim(){ sed 's/^[[:space:]]*//; s/[[:space:]]*$//'; }
die(){ echo "⚠️"; echo "---"; echo "$1"; exit 0; }
command -v "$SWITCH_AUDIO_BIN" >/dev/null 2>&1 || die "SwitchAudioSource not found. Install: brew install switchaudio-osx"

# Click handler
if [ "${1-}" = "set" ] && [ -n "${2-}" ]; then
  "$SWITCH_AUDIO_BIN" -t output -u "$2" >/dev/null 2>&1
  exit 0
fi

# SF Icon config
SFCONFIG="$(printf '%s' '{"renderingMode":"Hierarchical","scale":"medium", "colors":[]}' | base64 | tr -d '\n\r' | trim)"
# echo "$SFCONFIG" | base64 -d

# Current device UID (JSON)
CURRENT_JSON="$("$SWITCH_AUDIO_BIN" -c -t output -f json 2>/dev/null)"
CUR_UID="$(printf '%s\n' "$CURRENT_JSON" | sed -n 's/.*"uid"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | tr -d '\r' | trim)"

# Menubar icon (active device’s symbol, tinted blue)
ACTIVE_SYMBOL="speaker.wave.2.fill"
while IFS='|' read -r LABEL DEV_UID SYMBOL; do
  [ -z "$LABEL$DEV_UID$SYMBOL" ] && continue
  DEV_UID="$(printf '%s' "$DEV_UID" | trim)"
  SYMBOL="$(printf '%s' "$SYMBOL" | trim)"
  if [ -n "$CUR_UID" ] && [ "$DEV_UID" = "$CUR_UID" ]; then
    ACTIVE_SYMBOL="$SYMBOL"
    break
  fi
done <<< "$DEVICES"

echo "| sfimage=$ACTIVE_SYMBOL sfconfig=$SFCONFIG"
echo "---"


# Device rows
while IFS='|' read -r LABEL DEV_UID SYMBOL; do
  [ -z "$LABEL$DEV_UID$SYMBOL" ] && continue
  LABEL="$(printf '%s' "$LABEL" | trim)"
  DEV_UID="$(printf '%s' "$DEV_UID" | trim)"
  SYMBOL="$(printf '%s' "$SYMBOL" | trim)"

  line="$LABEL | bash='$0' param1=set param2='$DEV_UID' terminal=false refresh=true sfimage=$SYMBOL sfconfig=$SFCONFIG"
  if [ -n "$CUR_UID" ] && [ "$DEV_UID" = "$CUR_UID" ]; then
    # Tick it, tint the icon and text blue
    line="$line checked=true"
  fi
  echo "$line"
done <<< "$DEVICES"

echo "---"
echo "Sound Settings… | bash='/usr/bin/open' param1='x-apple.systempreferences:com.apple.preference.sound' terminal=false sfimage=gearshape sfconfig=$SFCONFIG"
```

The only section you’ll likely want to change is the list of devices:

```
Label|UID|SF Symbol
```

You can fetch the UIDs for your outputs with:

```bash
SwitchAudioSource -a -f json
```

Pick the devices you actually use and enter them with whatever label and [SF Symbol](https://developer.apple.com/design/human-interface-guidelines/sf-symbols) you want. The active device is indicated, and the menu bar icon updates to match.

There’s also a "Sound Settings…" shortcut at the bottom of the menu if you need the full system panel.

For convenience, the script is also on GitHub Gist:
[https://gist.github.com/omgmog/5bb66598c792f98ccdbe39cfd503488c](https://gist.github.com/omgmog/5bb66598c792f98ccdbe39cfd503488c)
