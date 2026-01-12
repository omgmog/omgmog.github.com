---
title: Building an emoji-only chat app
comments_issue: 127
tags: [emoji, javascript, web-development]
---

My daughter finds emoji hilarious. She's 6 and will scroll through an emoji picker for ages. My wife and I started by letting her use WhatsApp's emoji picker to send us messages, but that quickly polluted our chat history with emoji spam. We tried a few dedicated emoji-only apps like Emojichat, but there was this uncertainty about how they handled data. Most of them were also 1:1 only. I wanted the three of us in the same room.

<!-- more -->

{% include posts/figure.html src="2026-01/emoji.png" %}{:.center}

I built [Moji](https://moji-frontend.fly.dev/) over a weekend to see what happens when everything gets stripped down. Emoji only. No accounts. Rooms are just URLs with random IDs. Messages sync peer-to-peer and persist in browser storage.

The constraints are simple. Emoji only - the app only allows non-alphanumeric characters. Random room IDs get generated when starting a chat, but any string works. No accounts means nothing to store, nothing to manage. Type a name when joining and that's it.

I used [GunDB](https://gun.eco) for peer-to-peer messaging so messages stay between whoever's in the room, not on my server or in the cloud. The frontend is React, using Vite and Tailwind. The relay server is just Express with GunDB, about 15 lines - it only helps peers find each other.

I deployed both to [Fly.io](https://fly.io). Frontend as a static site, relay as a separate app. The free tier covers what I need, and deployment is just `fly deploy`. Didn't have to think about it much.

She picked it up immediately. No explanation needed. She doesn't just send single emoji back and forth - she builds little narratives. A sequence of emoji that tells a story. Sometimes it makes sense. Sometimes it doesn't. She'll periodically ping me messages throughout the day when she has screen time and I'm working in another room.

{% include posts/figure.html src="2026-01/moji-app.png" %}{:.center}

Emoji render differently across devices. The picker shows one set of glyphs, but messages display in whatever the system provides. I tried using Twemoji to keep things consistent but gave up - too much overhead. Works fine for now.

Messages are stored locally in browser storage, so there's no central database. Nothing to archive, nothing to moderate, nothing to maintain. I don't worry about what she's sending or who might see it.

It's live at [https://moji-frontend.fly.dev/](https://moji-frontend.fly.dev/) and works as a PWA. Source is on [GitHub](https://github.com/omgmog/moji-emoji-chat). She uses it occasionally - her interest is sporadic, as with most things 6-year-olds do. It's not her go-to when she has screen time, but it's been fun watching her use it.
