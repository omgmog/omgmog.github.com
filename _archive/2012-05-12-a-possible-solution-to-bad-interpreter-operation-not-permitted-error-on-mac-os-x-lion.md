---
comments_issue: 49
title: "A possible solution to 'bad interpreter: operation not permitted' error on Mac OS X Lion"
---
Out of the blue I started having an issue in my Terminal.app on Lion where downloaded scripts/applications wouldn't run. I first noticed this when trying to setup the Android SDK.

<!-- more -->

The problem looks like this:

```bash
$ ./android: /bin/sh: bad interpreter: Operation not permitted
```

After a bit of Google-fu, and a bunch of Apple Support Community threads that ended in people arguing about whether or not TextEdit caused this issue, I found a cause and a solution.

It turns out that for some reason, on Mac OS X Lion 10.7.3 apple is storing a `com.apple.quarantine` metadata file, which prevents executable files from being executed. Why is it doing this? Probably because the executable file was downloaded from the internet? who knows?

Anyway, there is a solution:

```bash
$ xattr -rd com.apple.quarantine [directory containing the executables]
```

So, for me with the Android SDK, I ran the following:

```bash
$ xattr -rd com.apple.quarantine /android-sdk/
```

This command deletes the `com.apple.quarantine` metadata files, allowing you to execute the executables.
