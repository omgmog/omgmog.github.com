---
title: "Rebuilding and analysing 4 years of Wordle stats from WhatsApp chat logs"
tags: [data, wordle, whatsapp, programming]
comments_issue: 164
---

Yes, I'm still playing Wordle in 2026.

According to [Wordle](https://www.nytimes.com/games/wordle/index.html), I've played 1,559 games, I win 99% of the time, my current streak is 107 days and my longest is 278. Four numbers, and they're mostly correct. What I don't get is anything behind them. No per-game history. No way to compare a Tuesday to a Sunday. No sense of whether I've actually got better at this over four years.

{% include posts/figure.html src="2026-07/Screenshot_20260726-160459.png" %}{:.center}

Each day I've played, I've also shared the result to WhatsApp. Just a habit, not a data strategy, but it turns out that habit quietly built a far more detailed record than Wordle itself ever keeps. One I can finally ask my own questions of. So I looked into rebuilding my own copy of the data.

<!-- more -->

## The problem with Wordle's own stats

Since 30th June 2025, most of that data hasn't even lived on the phone. It lives on my NYT account instead, server-side, which is exactly why today's numbers survive a device switch, a cleared cache, a reinstall. I only know the precise date because of a fossil still sitting in my phone's local storage: a key called `wordle-legacy-stats-228392857`, `currentStreak` and `maxStreak` both frozen at 234, with an embedded timestamp that decodes to that day.

```json
{
  "wordle-legacy-stats-228392857": {
    "gamesPlayed": 1170,
    "gamesWon": 1162,
    "guesses": {
      "1": 4,
      "2": 65,
      "3": 323,
      "4": 440,
      "5": 263,
      "6": 67,
      "fail": 8
    },
    "currentStreak": 234,
    "maxStreak": 234,
    "lastWonDayOffset": 1472,
    "hasPlayed": true,
    "autoOptInTimestamp": 1706429323127,
    "hasMadeStatsChoice": false,
    "timestamp": 1751262931
  },
// ...
}
```

Right next to it sits `wordle-stats-cutover-tooltip`, just a boolean set to `true`, almost certainly the one-time notice flag for the move. The old key was never reset, just abandoned mid-run, and the handover to the account-based numbers happened cleanly enough that today's 278 carried across intact.

Before that safety net existed, none of this was guaranteed. I switched from a Pixel 5a to a Pixel 7a in August 2024, nearly a year before any of this moved server-side, new device, new browser storage, no warning, whatever streak the old phone was tracking, gone. It's happened at a bigger scale too. When the New York Times moved Wordle from [Josh Wardle](https://en.wikipedia.org/wiki/Josh_Wardle)'s original site to nytimes.com in February 2022, [plenty of players reported their streaks resetting](https://www.forbes.com/sites/erikkain/2022/02/11/why-are-my-wordle-stats-and-streak-reset-and-is-there-a-fix/) in the migration, and my own earliest surviving share (puzzle #214) is from three weeks before that, so whatever I'd built up in Wordle's first weeks almost certainly didn't survive either.

## Turning a WhatsApp export into data

WhatsApp can [export a chat](https://faq.whatsapp.com/1180414079177245) as a plain `.txt` file with timestamped lines, one message per entry (or per contiguous block, for anything spanning multiple lines like a Wordle share). Every message looks like this:

```
<dd>/<mm>/<yyyy>, <hh>:<mm> - <author>: <message>
```

Which gives me everything I need, the puzzle number, date, guess count, win or loss, and the guess-by-guess grid if I ever want to go further than aggregate stats.

I wrote a small Python script that parsed the export, keeping just my own messages and pulling out puzzle numbers, dates and results via regex. 

```
19/01/2022, 22:10 - Max Glenister: Wordle 214 3/6

⬛⬛⬛⬛🟩
⬛⬛⬛⬛🟩
🟩🟩🟩🟩🟩
20/01/2022, 08:11 - Max Glenister: Wordle 215 5/6

⬛⬛⬛⬛⬛
⬛⬛⬛🟨⬛
🟨🟨⬛⬛⬛
🟩🟩🟨🟩⬛
🟩🟩🟩🟩🟩
21/01/2022, 08:17 - Max Glenister: Wordle 216 3/6

🟨⬛⬛⬛🟩
⬛🟩🟩🟩🟩
🟩🟩🟩🟩🟩
```

The actual extraction is one regex against the score line, plus a bit of logic to turn `X/6` into a proper win or loss:

```python
WORDLE_RE = re.compile(r"Wordle\s+([\d,]+)\s+([1-6X])/6", re.IGNORECASE)

match = WORDLE_RE.search(message)
puzzle_number = int(match.group(1).replace(",", ""))
guess_raw = match.group(2).upper()
won = guess_raw != "X"
guesses = int(guess_raw) if won else None

result = {
    "date": "2022-01-19",
    "puzzle_number": puzzle_number,
    "guesses": guesses,
    "won": won,
}
```

I ran that over the three messages above, and this is what comes out the other end:

```python
[
    {"date": "2022-01-19", "puzzle_number": 214, "guesses": 3, "won": True},
    {"date": "2022-01-20", "puzzle_number": 215, "guesses": 5, "won": True},
    {"date": "2022-01-21", "puzzle_number": 216, "guesses": 3, "won": True},
]
```

From there it de-duplicated by puzzle number (in case I'd ever shared the same one twice) and condensed everything down to one plain CSV row per game:

```
date,puzzle_number,guesses,won
2022-01-19,214,3,True
2022-01-20,215,5,True
2022-01-21,216,3,True
```

That's enough to compute streaks and gaps, and to slice the data however I like afterwards.

## What the squares say

The export covered 1,552 games going back to puzzle #214 in mid-January 2022, about three months after Wordle's public launch, 7 short of the 1,559 Wordle claims, probably days I played but never got round to sharing. My win rate across all of them is 99.42%, close enough to Wordle's rounded 99% with only 9 losses in the entire run. The guess distribution skews heavily toward 4 guesses (590 games), with a long tail down to 4 lucky first-guess wins, `unite`, `mouse`, `style` and `audio`. That last one's less luck than habit, audio's one of my two usual openers alongside adieu. All four first-guess wins landed in a ten-month stretch between November 2022 and August 2023, and not once since, nearly three years now, probably the same dwindling supply of easy, well-known answers.

{% include posts/inline-svg.html src="wordle-heatmap.svg" class="full-width massive" %}

And the streak. My longest is 278 days, running from 9th November 2024 to 13th August 2025, which for once matches Wordle exactly, current streak 107 and max streak 278, both confirmed independently rather than just taken on trust. The satisfying part isn't that Wordle was wrong, it's that I no longer have to take its word for it. It ended on a single missed day, not a loss. Probably just a busy summer day with the kids, and it took me two days to even notice. The only gap in all of 2025, and still enough to end it, before the next streak picked up the very next day and ran another 204.

Most other gaps are shorter, 3 to 7 days, and cluster in 2022 and early 2023. The longest is 9 days in late November 2022, right around my birthday, so I'll allow myself that one. From late 2023 onward the gaps mostly disappear and the streaks get long and dark green, which the heatmap makes obvious at a glance.


{% include posts/inline-svg.html src="wordle-guess-distribution.svg" class="full-width center" %}

Since I've saved the actual grids and not just the guess counts, I can check whether a lucky green on the opener really helps. The grid rows themselves are just five-emoji lines, so pulling them out of a message is another regex, and checking for a green is just a string search on the first row:

```python
GRID_ROW_RE = re.compile(r"[⬛⬜🟨🟩]{5}")

grid = [line for line in message.splitlines() if GRID_ROW_RE.fullmatch(line)]
had_green_opener = "🟩" in grid[0]
```

Puzzle #216 from earlier, `🟨⬛⬛⬛🟩`, comes back `True`. It does help: a first guess with at least one green tile finishes in 3.79 guesses on average, against 4.11 when the opener comes back completely blank, a third of a guess saved just from one lucky letter landing in the right place.

## Habits by day and time

None of that came with any day-by-day detail though, so I broke the guesses down by weekday to see if the solo school-run mornings (Tuesdays and Thursdays) actually cost me anything. They don't, really. Games are almost perfectly even across the week, and the average guess count barely moves, 3.94 on Sundays up to 4.07 on Wednesdays. Win rate dips slightly on Fridays and Sundays (98.2-98.6%, against 100% on four other days), but nothing that lines up with the mornings I expected to be worse.

{% include posts/inline-svg.html src="wordle-day-of-week.svg" class="full-width center" %}

The losses tell a sharper story than the averages do. Four of my nine losses landed on a Sunday, three on a Friday, two on a Tuesday, and none at all on a Monday, Wednesday, Thursday or Saturday. My guess count doesn't slip on weekends, but whatever's behind a loss clearly favours them.

{% include posts/inline-svg.html src="wordle-weekday-clutch.svg" class="full-width center" %}

The day of the week didn't move the needle, but the clock does. WhatsApp only knows when I hit send, not when I actually solved it, but even as a proxy it's heavily front-loaded: 6am to 8am accounts for about 79% of all 1,552 shares, peaking hard at 7am, tailing off to almost nothing after lunchtime. That tracks with real life, the kids have me up by 5:30 or 6 most mornings, and by 8:30 I've had my second coffee, so Wordle happens somewhere in that window before the day properly starts.

Split by weekday and weekend though, and the shape changes. Weekdays peak hard and early, 7am alone accounts for 36% of all weekday shares, then drop off fast. Weekends are flatter and shift later, 8am and 9am each pick up a bigger share than they do on a weekday, a small but clear lie-in.

{% include posts/inline-svg.html src="wordle-time-of-day.svg" class="full-width center" %}

## The trend over time

Monthly averages have crept up steadily, from a tight 3.7-3.8 guesses in early 2022 to 4.0-4.5 by 2025, well before the word-reuse period that kicks in from February 2026. That reads less like me getting worse at Wordle and more like the obvious five-letter words getting used up first, leaving the harder ones for later.

{% include posts/inline-svg.html src="wordle-monthly-trend.svg" class="full-width center" %}

The NYT [started reusing previously-answered words](https://tech.yahoo.com/puzzles/wordle/articles/groundhog-day-wordle-started-reusing-202500660.html) from February 2026 onward, having worked through most of their original ~2,300-word list, and five months on the average hasn't really moved, still sitting around 4.0-4.3. If it does start dipping later, that's not me suddenly getting better at Wordle, just more of these being repeats.

The final guess doesn't rattle me much. 100 wins came right down to the sixth and last one, against 9 losses, so on the games that go the full distance I'm still pulling it off more than 91% of the time. Those close calls are becoming more common too, from around 6% of games needing all six guesses in 2022 and 2023, up to 8.8% so far in 2026, the same creeping difficulty showing up again from a different angle.

{% include posts/inline-svg.html src="wordle-yearly-clutch.svg" class="full-width center" %}

Break the wins down by guess count year over year and the same trend shows up a third way. Four guesses stays the dominant result throughout, and 3-guess wins hold fairly steady at around a quarter of the total, but 5-guess wins have grown from about a fifth of all wins in 2022 to over a quarter by 2026. Nothing's disappearing so much as the harder tail getting heavier, the same difficulty creep as the monthly average and the six-guess close calls, just seen a third way.

{% include posts/inline-svg.html src="wordle-guess-share.svg" class="full-width center" %}

Nine losses in four years, and the actual words are worth naming for the record, `fewer`, `hound`, `scarf`, `jolly`, `rover`, `sixth`, `blaze`, `ready`, `carom`. No obvious thread between them, just the ordinary variety of five-letter words that catch me out.

Only 8 of those 9 losses have a next-day game to compare against, so it's more anecdote than finding, but every one of those 8 was a win, averaging 3.75 guesses, a touch better than my overall average rather than worse. If a loss rattles me, the data doesn't show it.

I've tried other daily puzzles over the years, and none of them stuck the way this one has. Wordle's the original, and four years and 1,552 games later, it's still the only one I open every morning without having to think about it. Habit, then. Data, now.