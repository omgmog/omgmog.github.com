---
title: Five AIs predict the World Cup
comments_issue: 150
tags: [ai, llm, world-cup]
---

The World Cup rolls around every four years, and with it the office sweepstake, the ritual where everyone gets handed a team at random and pretends to care how it does. I have no interest in football (I had to read [a beginner's guide to how it all works](https://www.theguardian.com/football/2026/jun/09/a-very-beginners-guide-to-the-world-cup-how-does-it-work-and-the-players-to-look-out-for) just to follow what's going on), and I definitely don't know enough to make an informed prediction of my own. So I thought I'd hand the job to five AI models instead, get them to commit their predictions in public, and keep score.

The result is [AIWC26](https://blog.omgmog.net/AIWC26/), a page that shows every group-stage prediction from five models side by side, scores them against the real results as they come in, and ranks the models in a league table. It looks like [Ceefax](https://en.wikipedia.org/wiki/Ceefax), because of course it does.

<!-- more -->

{% include posts/figure.html src="2026-06/ludicrous-display-ezgif.com-optimize.gif" %}{:.center}

## The setup

Each model got [an identical prompt](https://github.com/omgmog/AIWC26/blob/main/prompt.md). Here are the 72 group-stage fixtures, predict every scoreline, consider historical World Cup performance, recent form, squad make-up and venue factors, and return strict JSON. The AI entrants were Claude Fable 5 and Claude Sonnet 4.6 (Anthropic), GPT-5.5 (OpenAI), and Gemini 3.1 Pro and Gemini 3.5 Flash (Google).

There's also a sixth entry that isn't an AI at all, the Ranking Bot. It knows two things, the [FIFA world rankings](https://www.fifa.com/en/fifa-world-ranking) from April and one rule. Teams within ten places of each other draw 1-1, otherwise the higher-ranked team wins 2-1. Twenty lines of Python, no model, no judgement, fully deterministic, anyone can regenerate its picks and get an identical file. It exists to answer the question I actually cared about. Can five models beat a lookup table?

Scoring is the classic sweepstake format, 3 points for the exact score, 1 point for the right result, nothing otherwise.

All six entries were [committed to the repo](https://github.com/omgmog/AIWC26/tree/main/_data/predictions) before today's opening match, and the git history is the audit trail. Nobody gets to quietly revise their picks after Mexico go 2-0 up.

## The build

The site is Jekyll, deployed with GitHub Actions. A custom plugin does the scoring at build time, so the served HTML contains the full tables and works with JavaScript disabled (JS only handles the clock and the group filter).

Entering a result is a one-liner:

```
$ tools/results.py set A1 2 0
```

Then commit, push, and the Actions workflow rebuilds and deploys. The raw JSON stays published under [/data/](https://blog.omgmog.net/AIWC26/data/fixtures.json) for anyone who fancies their own analysis.

## What the picks already tell us

The predictions are locked, so before a ball is kicked I can say what the models think is going to happen. The short version is nothing surprising, ever.

Across all 360 predictions there is not a single major upset. No seed loses to a debutant. Nothing on the scale of Saudi Arabia beating Argentina in [2022](https://en.wikipedia.org/wiki/2022_FIFA_World_Cup), which actually happened, in the opening round, to the eventual champions. The boldest call anywhere on the page is both Gemini models taking Ghana, ranked 74th, to beat 33rd-ranked Panama, which is roughly as spicy as preferring one flavour of rice cake to another.

The strangest consensus on the page is Belgium. All five models hand them a perfect nine points, and so does the Ranking Bot, working purely off the April list that still has them ninth in the world. The press is less sure: previews tend to file Belgium under faded golden generation, big names past their best, a dark horse at most. The gap is the interesting part. The models are not arguing with the rankings, they are inheriting them, and the rankings have been slow to mark down a side that sat at the top of them for years. Five models sounding certain about Belgium is less five opinions than one lagging dataset in five voices, which is the consensus problem the whole page is about.

The consensus runs deeper than individual fixtures. Because the knockout bracket is predetermined, each model's 72 picks imply complete group tables, and from there an entire [last 32](https://en.wikipedia.org/wiki/2026_FIFA_World_Cup_knockout_stage) (an extra knockout round added by this year's 48-team expansion, feeding into the round of 16 as before). Across the five models, 30 of the 32 implied qualifiers are identical. Three teams, Bosnia, Paraguay and Türkiye, are left arguing over the last two seats. Whatever these models are doing, "five independent opinions" isn't it.

Then there's the draws problem. A football fan friend looked at the picks and said there's no way there are enough draws in them. His reasoning is that with the [new 48-team format](https://en.wikipedia.org/wiki/2026_FIFA_World_Cup), the top two from each group _plus_ the eight best third-placed teams advance. Two thirds of the field survives the groups. A draw is almost never a bad result, and in the final round it can suit both teams at once. He expects a cagey, draw-heavy group stage, like [Euro 2016](https://en.wikipedia.org/wiki/UEFA_Euro_2016) produced under the same kind of safety net.

The models, fixture by fixture, mostly disagree.

| Model | Predicted draws (of 72) | Rate |
|---|---|---|
| Ranking Bot | 10 | 14% |
| Claude Fable 5 | 12 | 17% |
| Claude Sonnet 4.6 | 13 | 18% |
| GPT-5.5 | 21 | 29% |
| Gemini 3.1 Pro | 10 | 14% |
| Gemini 3.5 Flash | 12 | 17% |
| Human 1.0 | 24 | 33% |
{:.massive}

World Cup group stages have historically run at roughly a quarter draws, before you factor in the new format's incentives. So most of the models are underweight. The odd part is that the models clearly know draws are common (1-1 is joint-top of all 360 predicted scorelines, level with 2-0), they just don't apply that base rate when you ask about matches one at a time.

The friend who spotted the draws problem initially declined to put his own picks on the record, which seemed fair enough, it's my website and his reputation.

The bot disagrees with all five models on exactly five fixtures, including calling Brazil v Morocco a draw (they are ranked 6th and 8th, two places apart) and backing Senegal to beat Norway outright. And in a twist I enjoyed, no AI model predicts fewer draws than the bot does: its 10 of 72 (14%) ties Gemini 3.1 Pro for the lowest rate on the page. So if the draw-heavy theory was right, everyone on this page was wrong together, and the theory's author was watching from the safety of not having entered.

## Human Control

Then he changed his mind. He's submitted picks of his own, filed as the seventh column on the page under Human 1.0. Unlike the other six, these didn't arrive before kickoff, they landed about twenty minutes after Mexico's opening match started, including his 2-1 for that very game. He says he wrote the whole lot down beforehand and was just slow sending them over. I believe him, so it's in and it counts, but it doesn't get the git-history alibi the rest of the page has.

His picks are everything you could have wanted from a human control. 24 of his 72 picks are draws, 33%, clear of GPT-5.5's 29% and more than double the bot's 14%. He hasn't just stated the thesis, he's bet the coupon on it.

His most-picked scoreline is 1-1 by a mile, and he's contributed the only 0-0 in the entire dataset (Uzbekistan v DR Congo), a scoreline five models and a lookup table collectively refused to imagine. He also owns the boldest pick on the page by a distance: New Zealand, ranked 85th, to beat Iran, ranked 21st, a 64-place upset that makes the Geminis' Ghana call look timid. Then there's South Korea winning at the Azteca, and France held to draws by both Senegal and Norway, which leaves his Group I in a three-way tie on five points.

Where the models predicted a tournament without surprises, he's predicted one made of almost nothing else.

## What happens next

Results go in as the group stage plays out, the table updates, and the colours fill in. Predictions for fixtures that haven't kicked off yet stay white, exact scores go green, right results go cyan, and wrong ones go red, which I expect to be the dominant colour by the end of June.

I'll write up the verdict after the group stage finishes on the 27th. Until then the table is at [blog.omgmog.net/AIWC26](https://blog.omgmog.net/AIWC26/), updating slightly slower than the [vidiprinter](https://en.wikipedia.org/wiki/Vidiprinter).
