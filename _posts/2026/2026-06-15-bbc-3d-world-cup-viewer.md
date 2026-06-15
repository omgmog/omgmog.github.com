---
title: "Inside the BBC's 3D World Cup viewer"
comments_issue: 151
tags: [web-development, world-cup]
---

While updating scores for [AIWC26](https://blog.omgmog.net/AIWC26/) this week I came across [BBC Sport's 3D World Cup viewer](https://www.3d-bbc.co.uk/), which launched on 12 June for matches broadcast on the BBC. Every match played so far is sitting there to replay in full, not just the live ones. It's UK-only, it's a beta, and somehow this is my second football post in a row, despite still having _zero_ interest in the sport itself. The engineering underneath it is another matter.

<!-- more -->

{% include posts/figure.html src="2026-06/bbc-football/overview.png" alt="In-game overview of Belgium vs Egypt, first half" %}{:.center}

The viewer is a Unity WebGL build, compiled to WebAssembly and running natively in the browser. The technology comes from XR company [Immersiv.io](https://www.immersiv.io/), consuming official FIFA EPTS telemetry, the [standardised Electronic Performance and Tracking Systems format](https://inside.fifa.com/innovation/standards/epts/research-development-epts-standard-data-format) developed after [IFAB's 2015 mandate](https://www.theifab.com/laws/latest/the-players-equipment/) to allow wearable tracking in official matches. Every player's position and skeletal joint data is captured at 25Hz and streamed to the browser, where the Unity runtime drives character transforms directly from the feed. That's what makes the first-person view work (the viewer occupies a skeletal position in the data rather than watching from a camera).

I had a go at the first-person view, and it works far better than I expected ([Creative Bloq had much the same reaction](https://www.creativebloq.com/3d/i-tried-the-bbcs-new-3d-world-cup-app-and-football-suddenly-felt-like-a-video-game)). It's got the pitch and player fidelity of a FIFA game from the 90s, running on a rendering engine from the early 2000s, decent shadows and all, and the fact that it's all running in a browser tab on whatever device you've got to hand is the genuinely impressive part. I dabbled in a Unity-to-WebGL pipeline in a past role (at [Scriptic](https://scriptic.com/)), so I've got some appreciation for how much pain goes into shipping something like this, never mind the live-data plumbing on top. Aside from the players and ball occasionally teleporting around or snapping between poses, it holds together well.

{% include posts/figure.html src="2026-06/bbc-football/first-person.gif" alt="Player and ball positions snapping between poses in the first-person view" %}{:.center}

None of this comes from trackers on the players. The skeletal data is derived from [16 optical tracking cameras installed in every World Cup stadium](https://www.gearbrain.com/2026-world-cup-sports-tech-2676763817.html), the same setup behind semi-automated offside, watching the pitch and working out where every limb is, 50 times a second. Wearable sensors exist too, but those are for fitness data like heart rate and sprint load, not the feed driving this viewer.

Each player has a full set of licensed kit textures served from Immersiv.io's Cloudflare R2 CDN, laid out as UV maps across separate mesh components for top, bottom and shoes. The player ID, team, kit colour and resolution tier are all encoded in the asset path, so the runtime constructs texture URLs dynamically from the roster data it's already receiving.

<div class="inline-grid three-columns">
{% include posts/figure.html src="2026-06/bbc-football/shirt.png" alt="Egypt shirt UV map, M. Salah #10" %}
{% include posts/figure.html src="2026-06/bbc-football/shorts.png" alt="Egypt shorts UV map, #10" %}
{% include posts/figure.html src="2026-06/bbc-football/shoes.png" alt="Boot UV map" %}
</div>

At half time the score and team flags appear as cards rendered in the same 3D space as the pitch, rather than a flat overlay.

{% include posts/figure.html src="2026-06/bbc-football/half-time.png" alt="Half-time overview, Belgium 0-1 Egypt" %}{:.center}

The timeline UI is worth a look. The bar chart running along the bottom is a per-team shot/danger heatmap across the match, with event markers below it for cards, chances and goals. That's a structured event feed separate from the positional telemetry, rendered as a scrubbable timeline with the full match loaded even during a live game.

{% include posts/figure.html src="2026-06/bbc-football/timeline.png" alt="The timeline view, showing the shot heatmap and event markers" %}{:.center}

There's an audio toggle in the top bar which pulls in a live BBC commentary stream over CMAF/HLS, with a latency offset that keeps the commentary locked to the positional data. It works well.

Drilling into a goal from the shotmap is where it gets fun. Pick "20' Goal" and the viewer replays the shot from pitch level, ball trajectory traced in green, with the shot stats (total, on target, missed) pulled from the same event feed as the timeline. It's the sort of feature I'd expect from a professional match analysis tool, not a casual viewing feature.

{% include posts/figure.html src="2026-06/bbc-football/goal-replay.png" alt="Shotmap replay of E. Ashour's 20th-minute goal for Egypt against Belgium" %}{:.center}

It's a lot of engineering for what's ostensibly just an extra bolted onto the BBC's coverage, and if my TV licence is helping pay for stuff like this, I'm not complaining. I've still got no real reason to use it (see: zero interest in football), but I'll be straight back into devtools next time there's a match on.
