---
title: "Your forecast is accurate and still wrong"
comments_issue: 142
tags: [ux, design]
---

Icons work because they're fast. One glance, immediate meaning, no reading required. The tradeoff is that they compress complex information into a single symbol, and compression always drops something.

<!-- more -->

Most of the time that's fine. But sometimes what gets dropped is the thing that actually matters, and the icon quietly lies to you. [Chester Zoo and 80-odd other UK tourist attractions are currently making exactly this argument](https://www.bbc.co.uk/news/articles/czj18j09wvro):

> "When families see a raincloud icon, many simply stay home. The reality might be a brief shower at 6am — but the symbol suggests a washout."
> — Dom Strange, Chester Zoo

They're not disputing the forecast accuracy. A shower did happen. The complaint is about how that accurate data gets turned into an icon, and what that icon communicates.

## Icons are lossy

Take the Google Weather app on Android. It updates roughly every hour and shows current conditions: what's actually happening outside right now. That part works well. But the daily forecast view, the strip of icons showing tomorrow and the rest of the week, is a completely different thing. Each of those icons has to stand in for an entire day, and that's where things go wrong.

{% include posts/figure.html src="2026-03/weather-google-composite.png" %}{:.center}

Google Weather this morning in Oxfordshire. Current conditions: cloudy, 10°. The hourly strip shows 10-10-10-20-25% chance of rain, pretty unremarkable. Further down, the 10-day shows today's card with a rain icon at 35%. Same data, same app, different view. The daily summary decided rain was the story.

The compression happens twice. Google Weather's API defines 40-odd distinct weather conditions, things like light showers, scattered showers, heavy rain, rain periodically heavy, and so on. Those first collapse down to a handful of recognisable icons. Sunny. Cloudy. Rainy. Stormy.

{% include posts/figure.html src="2026-03/google-weather-rain-types.png" title="Just the rain conditions from Google's Weather API — twelve variations that mostly end up looking the same at forecast-card size." %}{:.center}

Then those already-simplified icons get applied to an entire 24-hour period, picking one moment or one threshold to stand in for everything else. Which hour represents the day? Does overnight count the same as afternoon?

Those decisions are invisible to the person glancing at their phone over breakfast.

A rain cloud feels definitive in a way that "40% chance of showers" doesn't. Numbers invite interpretation. An icon just _is_. The icon closes the conversation.

That's the specific danger. Speed comes from reduction, and reduction drops nuance. By the time a day's forecast reaches your lock screen, it's been squeezed so hard that a 6am drizzle and a proper all-day downpour look identical.

Worth noting: Google just redesigned their weather icons this month (higher contrast, animated, more accessible). They look better. But there's still one per day.

## Scroll down two inches

The irony is that every weather app already has this information. Scroll down past the summary and there's an hourly breakdown, a precipitation chart, sometimes a rain radar. The data exists, it just gets stripped out before it reaches the one place most people actually look.

BBC Weather is a partial exception. It pairs each daily icon with a text label ("Strong winds and rain", "Light cloud and a gentle breeze") which already communicates more than an icon alone. Its hourly view goes further, showing a separate icon per hour alongside an actual precipitation percentage.

<div class="inline-grid two-columns">
{% include posts/figure.html src="2026-03/weather-bbc-summary.png" %}
{% include posts/figure.html src="2026-03/weather-bbc-hourly.png" %}
</div>

The inconsistency between apps doesn't help either. BBC Weather and the Met Office draw from the same underlying data but can show different icons for the same day, because each has its own rules for what tips a forecast from "cloudy" to "rainy". Check three apps and you might get three different answers.

Which circles back to Chester Zoo's actual problem. The forecast isn't wrong (there probably will be some rain). The icon has just been read as a binary signal (go or don't go). It's telling you to take an umbrella. Families are reading it as a cancellation notice.

None of this is radical, and the data to go further is already there. The hourly breakdown already exists in every app, it just never makes it up to the forecast card. A few ways it could, without reinventing anything.

{% include posts/figure.html src="2026-03/weather-mockup-split-icons.png" title="Split the icon into morning and afternoon — Tuesday shows rain early, sun later." %}{:.center}

{% include posts/figure.html src="2026-03/weather-mockup-badge.png" title="A badge showing until when rain is expected — same icon, much less alarming." %}{:.center}

{% include posts/figure.html src="2026-03/weather-mockup-timeline.png" title="A timeline strip showing wet and dry hours — glanceable, but tells you the shape of the day rather than just whether rain appears somewhere in it." %}{:.center}

The problem isn't that nobody knows how to do this. It's that somewhere in the design of these apps, someone decided one icon per day was enough, and that decision got copied across every weather app on every home screen until it stopped looking like a choice at all. It takes a consortium of zoos and theme parks losing millions before anyone notices that the thing everyone assumed was fine might not be.

