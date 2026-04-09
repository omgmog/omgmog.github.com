---
title: Pulling Google Takeout straight to a NAS
comments_issue: 145
tags: [guide, google, linux, nas]
---

I've been having a bit of a think about data I've left entirely in someone else's hands. Specifically Google Photos, which has photos going back to 2011 and no local copy _anywhere_. I'm not going anywhere dramatic with it, but having a backup I actually control felt overdue.

<!-- more -->

Part of the problem is how frictionless it is. I take a photo, it syncs, it's "backed up", and I never think about it again. That's the appeal, but it's also why I'd gone fifteen years without asking where, exactly, "backed up" actually meant.

## Getting the download URLs

I requested a full Takeout export and it came back as 66 zip files, about 2GB each, 131GB total. My [NAS](/post/building-a-home-nas-from-mostly-spare-parts/) has the space; my laptop does not. I didn't fancy downloading it locally just to copy it across, so I worked out how to pull it straight to the server.

{% include posts/figure.html src="2026-04/photos/google-takeout.png" %}{:.center}

On the Google Takeout page, there's a list of all the zip files with a download link for each. There's no way to grab them all at once, but running this in the browser console pulls all the links and copies them to the clipboard:

```js
copy([...document.querySelectorAll("a.WpHeLc")].map(a => a.href).join('\n'));
```

Google obfuscates its CSS class names, so `WpHeLc` will likely change at some point. If it returns nothing, inspect one of the download buttons and find the current class. Paste the result into a `urls.txt` file on the server.

## Why cookies don't transfer

The download links are authenticated, so the trick is carrying the Google session from the browser into the terminal. The obvious approach was to export browser cookies to a `cookies.txt` file (via an extension like "Get cookies.txt LOCALLY") and pass them to `curl` or `aria2c`. _This doesn't work._

The Takeout download URLs go through a redirect chain across multiple Google domains before landing on `takeout-download.usercontent.google.com`. The cookies that matter (`__Secure-1PSID`, `__Secure-3PSID`, `SIDCC`, and a few others) don't survive that redirect in most download tools, and some cookie export extensions miss them entirely. Every download attempt ends up at the Google login page and saves an HTML file instead of a zip. The solution is to skip the redirect entirely and go straight to the final download URL, using Chrome's exact headers.

## Pretending to be a browser

Install the [CurlWget extension](https://chromewebstore.google.com/detail/CurlWget/dgcfkhmmpcmkikfmonjcalnjcmjcjjdn) in Chrome. Start downloading one of the files from the Takeout page, then immediately click the CurlWget icon. It generates an equivalent `curl` command with all the headers and cookie data Chrome used, pointing at the actual `takeout-download.usercontent.google.com` URL, no redirect involved. This works where the cookie export didn't because Chrome had already followed the redirect, so the cookies are tied to the final domain, not the Takeout one.

From that I had the `Cookie:` header string, a job ID shared across all files, a numeric user ID, and the base filename, which was enough to build all the download URLs directly. The files are numbered sequentially, so the whole lot can be constructed without touching the Takeout page again.

The cookies don't last long, though. Each session got me about 7 files (~14GB) before they expired and downloads started coming back as HTML again. The cookie lives in a separate `cookie.txt` file so it can be refreshed without touching the script. Grab a new CurlWget capture, save it to a text file, and pipe it through a helper script that pulls out just the value:

```bash
cat curlwget.txt | bash update-cookie.sh
```

```bash
#!/bin/bash
# update-cookie.sh
# Usage: pbpaste | bash update-cookie.sh
#    or: cat curlwget.txt | bash update-cookie.sh
grep -oP "(?<=Cookie: )[^'\"]*" | tr -d '\n' > cookie.txt
echo "cookie.txt updated."
```

The resulting `cookie.txt` looks something like this (heavily abbreviated):

```
SID=g.redacted; HSID=redacted; SSID=redacted; APISID=redacted; SAPISID=redacted; __Secure-1PSID=g.redacted; __Secure-3PSID=g.redacted; SIDCC=redacted; __Secure-1PSIDTS=sidts-redacted; __Secure-3PSIDTS=sidts-redacted; NID=redacted
```

## The download script

With those pieces, the script builds each URL directly and downloads with `curl`:

```bash
#!/bin/bash
set -euo pipefail

DIR=/path/to/destination
TOTAL=$(wc -l < "$DIR/urls.txt")

# From the CurlWget capture
J=your-job-id-here
USER_ID=your-numeric-user-id
BASE_NAME=takeout-YYYYMMDDTHHMMSSZ-N

COOKIE=$(cat "$DIR/cookie.txt")

# Clean up any small HTML files from previous failed attempts
find "$DIR" -name "takeout-part-*.zip" -size -1M -delete 2>/dev/null || true

for i in $(seq 0 $((TOTAL - 1))); do
    part=$(printf '%03d' $((i + 1)))
    filename="${BASE_NAME}-${part}.zip"
    output="$DIR/$filename"
    url="https://takeout-download.usercontent.google.com/download/${filename}?j=${J}&i=${i}&user=${USER_ID}&authuser=0"

    if [[ -f "$output" ]] && [[ $(stat -c%s "$output") -gt 1048576 ]]; then
        echo "[$((i+1))/$TOTAL] $filename already exists, skipping"
        continue
    fi

    echo "[$((i+1))/$TOTAL] $filename"

    curl \
        --header "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36" \
        --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7" \
        --header "Accept-Language: en-GB,en-US;q=0.9,en;q=0.8" \
        --header "Referer: https://takeout.google.com/" \
        --header "Cookie: $COOKIE" \
        --retry 10 \
        --retry-delay 15 \
        --retry-all-errors \
        --continue-at - \
        --progress-bar \
        -o "$output" \
        "$url" && echo "done" || echo "FAILED"

done

echo "All done."
```

Run it inside `tmux` or `screen` so it survives disconnecting from the server:

```bash
tmux new -s takeout 'bash download.sh'
```

`--continue-at -` handles resume if a download is interrupted, and the script skips any file over 1MB that already exists, so a mid-way cookie expiry just means refreshing it and running the script again.

## What's inside

Extracted, it's a single `Takeout/Google Photos/` directory with about 28,500 files in it. Almost exactly half are small JSON files, one per photo or video, carrying the metadata that Google doesn't embed in the image itself (taken time, location, description, view count). The actual images have _none_ of that baked in.

The folder structure is a mix of year folders (`Photos from 2011` through `Photos from 2026`), named albums I actually created (Iceland 2016, Menorca 2018, Jenny & Max Wedding, various project dumps), and 214 folders called `Untitled`, `Untitled(1)`, and so on up to `Untitled(213)`. Those turned out to be WhatsApp shares, recognisable from the `IMG-20XXXXXX-WAXXXX.jpg` filenames inside.

The JSON files are a bit annoying. The `photoTakenTime` field has the actual date the photo was taken, but that's separate from `creationTime`, which is when it was uploaded to Google Photos, and neither of those is written into the image file itself. So if I import everything into something like Immich or Lightroom without processing these first, it all ends up timestamped _wrong_. Tools like [gphotos-takeout](https://github.com/gilesknap/gphotos-takeout) and [google-photos-exif](https://github.com/mattwilson1024/google-photos-exif) can merge that data back in, but that's a job for another day.
