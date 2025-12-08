---
title: Exploring OTA firmware updates on the Mangmi Air X
comments_issue: 124
tags: [guide, android]

---

After [reviewing the Mangmi Air X](/post/review-mangmi-air-x/), I got curious about how the firmware updates worked. Mangmi have been pushing updates fairly regularly, which is great to see on a budget device. Officially they release full update packages via Google Drive links, but those have a tendency to disappear over time. I wanted to access the OTA update packages directly and back them up to archive.org alongside the original firmware.

{% include posts/figure.html src="2025-12/mangmi-ota-available.png" %}{:.center}

<!-- more -->

## Limited ADB access

I started by poking around via ADB, but connecting doesn't give you full root:

```bash
adb shell
AIR_X:/ $ whoami
shell
AIR_X:/ $ su
/system/bin/sh: su: inaccessible or not found
```

Most system directories are off-limits, so you can't just browse through logs or inspect the firmware directly. That ruled out the usual approach of just watching what happens when you trigger an update.

The device uses Android's [`update_engine`](https://android.googlesource.com/platform/system/update_engine/) for handling firmware updates. This writes the downloaded packages to `/data`, and without root access you can't get in there to inspect them.

## Dumping system information

I needed another approach. The Mangmi firmware includes a GUI option to run scripts as root, which I've not seen on other Android handhelds. I used this to dump any information I could about the update system:

{% include posts/figure.html src="2025-12/mangmi-sudo-gui.png" %}{:.center}

```bash
#!/system/bin/sh
OUTDIR="/sdcard/scripts"
mkdir -p "$OUTDIR"
TS=$(date +%Y%m%d_%H%M%S)

echo "Collecting OTA/Update Info - $TS" > "$OUTDIR/update_info_$TS.txt"

# Build info
echo -e "\n=== Build Info ===" >> "$OUTDIR/update_info_$TS.txt"
getprop >> "$OUTDIR/update_info_$TS.txt"

# List OTA directories
echo -e "\n=== OTA Directories ===" >> "$OUTDIR/update_info_$TS.txt"
for DIR in /data/ota /data/misc/update_engine /cache/recovery; do
    echo -e "\n--- $DIR ---" >> "$OUTDIR/update_info_$TS.txt"
    if [ -d "$DIR" ]; then
        ls -l "$DIR" >> "$OUTDIR/update_info_$TS.txt" 2>&1
    else
        echo "Directory not found" >> "$OUTDIR/update_info_$TS.txt"
    fi
done

# Last OTA logs if accessible
LOGS="/data/misc/update_engine"
echo -e "\n=== Last Update Logs ===" >> "$OUTDIR/update_info_$TS.txt"
if [ -d "$LOGS" ]; then
    for FILE in "$LOGS"/*; do
        echo -e "\n--- $FILE ---" >> "$OUTDIR/update_info_$TS.txt"
        cat "$FILE" >> "$OUTDIR/update_info_$TS.txt" 2>&1
    done
else
    echo "No update_engine logs found or permission denied" >> "$OUTDIR/update_info_$TS.txt"
fi

# Recovery logs if accessible
RECOVERY_LOG="/cache/recovery/last_log"
echo -e "\n=== Recovery Log ===" >> "$OUTDIR/update_info_$TS.txt"
if [ -f "$RECOVERY_LOG" ]; then
    cat "$RECOVERY_LOG" >> "$OUTDIR/update_info_$TS.txt" 2>&1
else
    echo "No recovery log found or permission denied" >> "$OUTDIR/update_info_$TS.txt"
fi

echo -e "\nUpdate info collection complete: $OUTDIR/update_info_$TS.txt"
```

This confirmed that the OTA directories existed but I couldn't directly access the URLs or changelog text from the logs. I considered setting up mitmproxy to intercept HTTPS traffic, but that would've required installing certificates on the device and dealing with certificate pinning if Mangmi's OTA updater uses it.

## Capturing network traffic

A simpler approach was to just capture the network traffic directly using `tcpdump`. Since the "Run Script as Root" feature lets you run commands as root, I could capture packets without needing to root the device or mess with certificates:

1. Create two shell scripts in `/sdcard/scripts/`
2. Run the first script via the GUI to start capturing network traffic in the background
3. Trigger the OTA check from the settings menu
4. Run the second script via the GUI to stop the capture

Here's the first script to start the capture (`start_tcpdump.sh`):

```bash
#!/system/bin/sh
tcpdump -i any -w /sdcard/scripts/ota_capture.pcap &
echo $! > /sdcard/scripts/tcpdump.pid
```

And the second script to stop it (`stop_tcpdump.sh`):

```bash
#!/system/bin/sh
kill $(cat /sdcard/scripts/tcpdump.pid)
mv /sdcard/scripts/ota_capture.pcap /sdcard/scripts/ota_done.pcap
```

I ran the first script via the GUI, triggered the update check from Settings, then ran the second script to stop the capture. I then pulled the `.pcap` file via ADB:

```bash
adb pull /sdcard/scripts/ota_done.pcap
```

## Inspecting the OTA traffic

Opening the `.pcap` in Wireshark, I found the device making a POST request to:

```
https://api.mangmi.cn/api/update-package/update
```

{% include posts/figure.html src="2025-12/pcap-sent.png" %}{:.center}

The payload includes the current firmware version, device serial number, and a secret key. 

{% include posts/figure.html src="2025-12/pcap-received.png" %}{:.center}

The JSON response comes back with the next available update, including version name, changelogs in both Chinese and English, download URL, file size, MD5 checksum, and compile time.

## Querying the OTA endpoint directly

With the serial number and secret key from the capture, you can query the API yourself with `curl`:

```bash
curl -X POST "https://api.mangmi.cn/api/update-package/update" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "User-Agent: okhttp/4.12.0" \
  --data "current_version=1.0.58&sn=<YOUR_SN>&secret-key=<SECRET>"
```

You can check for updates and download packages without needing the device, which is handy if you want to archive firmware versions or inspect packages before installing them.

The API returns two types of packages: **full** and **diff**. Full packages are complete firmware images (e.g. `https://image.mangmi.com/pkg/full/v1.0.51_20250919-user.zip`), while diff packages are incremental updates from one specific version to another (e.g. `https://image.mangmi.com/pkg/diff/v1.0.58-v1.0.60_AIR_X_MQ66_20251129-user.zip`). If you're archiving, you'll likely want the full packages.

One thing that initially caught me out was that the JSON response included control characters within the Chinese language changlog that tripped up `jq`. If you're piping the output into something, make sure to sanitise it first.

```bash
# assuming $RESPONSE is the JSON result from the curl command
CLEAN_RESPONSE=$(echo "$RESPONSE" | tr -d '\000-\037')
```

## Parsing OTA changelogs

If you pipe the API response through `jq`, you can extract just the English changelog:

```bash
curl ... | jq -r '.data.details_en'
```

You'll get the changelog as plain text that's easy to copy and paste:

```text
New Features:
1. Trigger Calibration: Settings > Handheld Settings > Joysticks & Buttons > Trigger Settings > Trigger Calibration
2. Trigger Mode (Compatibility Mode | Button Mode | Linear Mode)
3. Trigger Dead Zone
...
```

Handy if you want to share changelogs online or keep your own archive of what's changed between versions.

Capturing network traffic without needing to root the device or mess with custom ROMs makes it easy to see what's going on under the hood. With the API endpoint details, you can archive firmware packages or download them without needing the device.

I've used this to collate update data and archive a few OTA updates alongside the original firmware on [archive.org](https://archive.org/details/mangmi-air-x-firmware). It's also good for pulling changelog text to share on [r/Mangmi_Air_X](https://www.reddit.com/r/Mangmi_Air_X/). Not something I'll maintain long-term, but the technique is there if anyone wants to keep track of firmware history or needs to grab a specific version.