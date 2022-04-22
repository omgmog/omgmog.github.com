---
comments_issue: 73
title: Getting Notified when a process is using 100% CPU on Mac OS X
---

{% include posts/figure.html src="hotmacbook.jpg" %}{:.massive.center}

Lately I've noticed `node.js` occasionally spawning a process that's using 100% CPU. When this happens, the battery on my MacBook quickly drains.

<!-- more -->

```text
17/08/2015 19:32:36.000 kernel[0]: process node[9119] caught causing excessive wakeups. Observed wakeups rate (per sec): 718; Maximum permitted wakeups rate (per sec): 150; Observation period: 300 seconds; Task lifetime number of wakeups: 45006
```

Now, I've not worked out what's starting this `node.js` process, but I have my suspicions that it's probably down to one of the plugins I'm using with Sublime.

So until I can work out what the cause is, let's treat the symptom: `node.js` uses 100% CPU and shags my battery.

My solution is creating a daemon that shows a notification when a process is using 100% CPU, so I can then find it and kill it.

### Install `terminal-notifier` ([github](https://github.com/julienXX/terminal-notifier))

```bash
$ brew install terminal-notifier
$ brew linkapps terminal-notifier
```

### Create a script to check if the CPU is being excessively used by a process

I found a nice simple script on [Stack Overflow](http://apple.stackexchange.com/a/90295/48776), which does exactly what I want.

```bash
#!/bin/bash

cpulimit=50
prefix=${TMPDIR}cron_cpu
current=$(ps -erco %cpu,command | tail -n+2 | sed 's/^ *//')
echo "$current" > $prefix$(date +%s)
a=($prefix*); for ((i=0;i<=${#a[@]}-3;i++)); do rm "${a[i]}"; done
[[ $(awk '{s+=$1}END{printf "%i",s}' <<< "$current") -lt $cpulimit ]] && exit
averages=$(awk '{cpu=$1;sub(/[^ ]+ /,"");a[$0]+=cpu;c[$0]++}END{for(i in a){printf "%.1f %s\n",a[i]/c[$0],i}}' $prefix* | sort -rn)
if [[ $(awk '{s+=$1}END{printf "%i",s}' <<< "$averages") -ge $cpulimit ]]; then
    terminal-notifier -title "CPU use" -message "$(head -n5 <<< "$averages" | paste -sd / -)"
fi
```

So save this to somewhere, I saved mine in `~/bin/check100proc.sh`

Now you need to make this script run periodically. This is done using `launchdaemon`.

Save the following plist somewhere, I saved mine in `~/Library/LaunchDaemons/com.omgmog.check100proc.plist`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.omgmog.check100proc</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/max/bin/check100proc.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
</dict>
</plist>
```

This plist will daemonise the `check100proc.sh` that you created earlier, to make it run every 5 minutes (or 300 seconds).

You'll want to change the path to reflect wherever you saved the `check100proc.sh`.

Then load the plist with `launchctl`:

```bash
$ launchctl load -w ~/Library/LaunchDaemons/com.omgmog.check100proc.plist
```

That's it. You can check that the plist has been daemonised and is running using the following command:

```bash
$ launchctl list | grep check100proc
```






