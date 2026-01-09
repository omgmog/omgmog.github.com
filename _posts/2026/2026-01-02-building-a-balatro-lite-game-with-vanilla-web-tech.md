---
title: Building a Balatro-lite game with vanilla web tech
comments_issue: 125
tags: [game-development, javascript, typescript]
---

I’ve spent countless hours playing [Balatro](https://www.playbalatro.com/), and I’ve always wanted to create my own game with similar mechanics. When [TrinketOS](https://trinketos.org/) announced a game jam, it was the perfect excuse to make it happen. 

<!-- more -->

TrinketOS is an Android launcher with built-in lore and a meta-game: 


> At its core, TrinketOS is a modular interface altar:
> - A launcher that respects buttons and joysticks.
> - A customizable home that reads like a game and plays like a tool.
> - A system that rewards you with hats and achievements for exploring its circuits.

The game jam required building a "Tapp" - an HTML/JS/CSS app that runs inside TrinketOS's webview. There's a great [overview on Github](https://github.com/ismslv/trinketos/blob/main/tapps_howto.md). 

{% include posts/figure.html src="2026-01/stellante/title-lowres.png" %}{:.massive}

I called it Stellante - a zodiac-themed Balatro-lite. Poker hands to progress through antes, ships (jokers) that modify scoring, boss blinds based on zodiac signs reimagined as spacecraft. The name comes from "Stellar" (space) and "Ante" (the poker term for progression).

You can play it at [omgmog.net/stellante](https://omgmog.net/stellante/).

## Building the foundation

I didn't have a clear vision of where this would end up. I just knew I wanted to capture Balatro's feel - that rough, shaky pixel aesthetic, the satisfying card animations, the way scoring builds up. I'd worked on web-based casino games before, so at least I knew my way around card rendering and deck systems.

{% include posts/figure.html src="2026-01/stellante/ScreenRecording2025-07-30at11.27.57-ezgif.com-optimize.gif" %}{:.center}

I made a list of the core features the game would need: card renderer, deck system, animation queue, poker hand evaluation, joker modifiers, shop phase, progression system, save/load. Then I started building them one by one. First the renderer - drawing random hands of cards on click. Then a proper deck to draw from. Animation queueing for card movements. Basic game loop with menu, play, and game over phases.

Next came scoring for poker hands (pairs, straights, flushes, etc.) and the Balatro-inspired bits: jokers with score modifying effects, a buy phase to purchase them between rounds, and a save/load system using localStorage. The save system also handles basic preferences for sound and music.


## Space zodiac theming

Instead of copying Balatro's aesthetic directly, I wanted something different. I settled on a zodiac theme - reimagining the twelve zodiac signs as spacecraft types. Aries became a corvette (fast, assault-focused), Taurus a cruiser (industrial, scaling power), Leo a battlecruiser (commanding, demanding uniqueness).

I replaced the traditional card suits with elemental symbols. Fire, Earth, Water, and Air instead of hearts, diamonds, clubs, and spades. Abstract geometric shapes that matched the space setting. The faction system used this - ships came in elemental variants, and the suits on the cards mattered for scoring.

<div class="inline-grid">
{% include posts/figure.html src="2026-01/stellante/fire_32px.png" %}
{% include posts/figure.html src="2026-01/stellante/earth_32px.png" %}
{% include posts/figure.html src="2026-01/stellante/water_32px.png" %}
{% include posts/figure.html src="2026-01/stellante/air_32px.png" %}
</div>

I used ChatGPT to craft prompts, fed them into [PixelLab](https://www.pixellab.ai/) for image generation, used Python for palette alignment, then back to PixelLab's image-to-image generation for elemental variations. Tweaked prompts as I went, kept them consistent - same style, similar detail level, cohesive pixel-crunch aesthetic across all 12 zodiac ships and their variants.

I put face cards through the same process, with a final step in Photoshop to create the traditional mirrored/split layout for Jacks, Queens, and Kings. Backgrounds matched the elemental joker backgrounds.

<div class="inline-grid">
{% include posts/figure.html src="2026-01/stellante/face_j_fire.png" %}
{% include posts/figure.html src="2026-01/stellante/face_j_earth.png" %}
{% include posts/figure.html src="2026-01/stellante/face_j_water.png" %}
{% include posts/figure.html src="2026-01/stellante/face_j_air.png" %}
</div>
<div class="inline-grid">
{% include posts/figure.html src="2026-01/stellante/face_q_fire.png" %}
{% include posts/figure.html src="2026-01/stellante/face_q_earth.png" %}
{% include posts/figure.html src="2026-01/stellante/face_q_water.png" %}
{% include posts/figure.html src="2026-01/stellante/face_q_air.png" %}
</div>
<div class="inline-grid">
{% include posts/figure.html src="2026-01/stellante/face_k_fire.png" %}
{% include posts/figure.html src="2026-01/stellante/face_k_earth.png" %}
{% include posts/figure.html src="2026-01/stellante/face_k_water.png" %}
{% include posts/figure.html src="2026-01/stellante/face_k_air.png" %}
</div>

I grabbed audio from itch.io - an 8-bit platformer music kit and various sound effect packs.

The ships ended up being the most important part. 12 zodiac types, each with five versions: a prototype plus four elemental variants (Fire, Earth, Air, Water). That's 60 ships total. Each zodiac has its own scoring mechanic, and the elemental variants each have different effects from their prototype.

I built a set bonus system that rewards you for collecting either all four ships of the same element (faction sets like "Fire Legion") or all four elemental variants of one zodiac sign (line sets like "Aries Line").

{% include posts/figure.html src="2026-01/stellante/stellante-title.png" %}{:.center}

This changed the feel completely. Instead of playing cards, it felt like commanding a fleet. Instead of collecting jokers, I was acquiring ships with special abilities. Playing cards with flame symbols whilst commanding fire-element ships made more sense than traditional hearts and spades in a space setting.

## Shop mechanics

Between each blind, there's a buy phase to buy ships. Runs start with 20 chips, earning more by beating blinds.

The shop offers a limited selection each round - just two ships in the first two antes, then three afterwards. In ante 1, only prototype ships appear. From ante 2 onwards, all 60 ships become available. The shop won't offer duplicates of ships already owned, and there's a limit of five ships total.

{% include posts/figure.html src="2026-01/stellante/stellante-shop.png" %}{:.center}

I added faction discounts. Base cost for most ships is 12 chips, but owning ships of the same element makes matching variants cheaper - up to 2 chips off per owned ship of that faction. Going all-in on one element pays off, but narrows your options.

Unwanted ships sell for half their base cost. Rerolling the entire shop costs 5 chips and gives three new options. More to juggle.

I wanted tension between short-term needs and long-term strategy. Early discounts push towards mono-element builds, but that can lock out zodiac abilities needed for later boss blinds.

## Progression system

I moved from continuous rounds to Balatro's ante and blind system. Each ante has three blinds with escalating score requirements. 

{% include posts/figure.html src="2026-01/stellante/stellante-blind-complete.png" %}{:.center}

The third blind in each ante is a boss blind with special modifiers, for example:

- Aries: forces exactly 5 cards to be played
- Gemini: deals some cards face down
- Leo: makes royal cards (J/Q/K) score zero
- Libra: treats duplicate ranks as singles
- Pisces: only counts the lowest 5 ranks
- ... and so on for the rest of the zodiacs

Getting these effects working was fiddly. Boss blinds don't just change scoring - they modify which cards can participate in hands. 

Boss blinds reuse the prototype/base ship sprite for each zodiac, with intro/outro animations, and feedback during the blind.

{% include posts/figure.html src="2026-01/stellante/ScreenRecording2026-01-05at20.25.56-ezgif.com-video-to-gif-converter.gif" %}{:.center}


## Tech stack

Building as a Tapp meant working within TrinketOS's webview constraints. No native game engines, no heavy frameworks - just HTML/JS/CSS that could run efficiently inside the webview on Android handhelds with varying performance.

I built the game in TypeScript - separate systems for state, input, rendering, animations, and game logic. Canvas 2D for cards and UI. WebGL shader for the cosmic background, with a fallback to a simple static background for devices that don't support it.

I used Vite to handle local development and bundling. I used dirty rectangles for optimised redraws, pooled animations to cut down on garbage collection, and a frame rate manager to keep things smooth.

## Shipping it

I finished it enough to submit to the game jam - the core loop worked, boss blinds fired properly, ships modified scoring the way they should. Final build came to 7.4MB.

Winners were decided by community votes on the [TrinketOS Matrix](https://trinketos.org/matrix/). The creator of TrinketOS reviewed all the entries in this video:

{% include posts/figure.html type="iframe" src="https://www.youtube.com/embed/PFMk61LbWyM" %}

I didn't win, and I haven't touched it since the game jam ended. Mobile controls could be better, and the balance needs work. But it runs, the core loop works, and building a full game with vanilla web tech was exactly what I wanted to try.

The zodiac theme gave it enough personality to stand out from other Balatro-likes. I got to mess around with AI image generation workflows, proper state management in TypeScript, and all the fiddly bits of card game logic. 

You can play it in the browser at [omgmog.net/stellante](https://omgmog.net/stellante/).
