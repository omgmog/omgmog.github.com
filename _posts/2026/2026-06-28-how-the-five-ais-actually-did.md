---
title: How the five AIs actually did
comments_issue: 158
tags: [ai, llm, world-cup]
---

The Group Stage of the 2026 World Cup finished today, so it's time to mark the homework. Back in [the launch post]({% post_url 2026/2026-06-11-five-ais-predict-the-world-cup %}) five AI models, a deterministic lookup table, and one football fan predicted the same 72 fixtures before a ball was kicked. I've been scoring the results on [AIWC26](https://blog.omgmog.net/AIWC26/) each day as they came in. I've got no real opinion on the teams; I'm interested in what the scoring reveals about the models.

<!-- more -->

## Final table

| Entrant | Points | Exact scores | Correct results |
|---|---|---|---|
| Claude Sonnet 4.6 | 67 | 10 | 37 |
| Claude Fable 5 | 64 | 9 | 37 |
| Gemini 3.1 Pro | 62 | 8 | 38 |
| Gemini 3.5 Flash | 62 | 10 | 32 |
| Ranking Bot | 59 | 7 | 38 |
| GPT-5.5 | 52 | 6 | 34 |
| Human 1.0 | 52 | 6 | 34 |
{:.massive}

The lookup table-powered _Ranking Bot_ beat one of the five models. _Twenty lines of Python_, no training data, no judgement. It still out-scored GPT-5.5 and the football fan who claimed to care about this in the first place. GPT-5.5 and the human didn't just tie on points, they tied on the breakdown too, 6 exact scores and 34 correct results each, arrived at by a model reasoning fixture-by-fixture and a man writing his picks down once before kickoff.

The final table also wasn't a foregone conclusion. Plotting cumulative points against the real fixture dates shows Sonnet led from the first day, Fable overtook it on 19 June and held top spot for more than a week, and Sonnet only reclaimed first place on the very last day of the group stage, 27 June.

{% include posts/inline-svg.html src="aiwc26-standings-over-time.svg" class="full-width" %}

## The model that won said it was the least sure of itself

All five AI models attached a confidence score to every prediction, their own stated probability that the result would be correct. That number predicted the final table better than anything about football knowledge did.

| Entrant | Average stated confidence | Actual hit rate | Gap |
|---|---|---|---|
| GPT-5.5 | 0.64 | 0.56 | +0.08 |
| Gemini 3.5 Flash | 0.66 | 0.58 | +0.08 |
| Gemini 3.1 Pro | 0.63 | 0.64 | -0.01 |
| Claude Fable 5 | 0.49 | 0.64 | -0.15 |
| Claude Sonnet 4.6 | 0.45 | 0.65 | -0.21 |
{:.massive}

{% include posts/inline-svg.html src="aiwc26-calibration.svg" class="full-width" %}

GPT-5.5, the single most overconfident entrant on the page, finished bottom of the table. Gemini 3.5 Flash was just as overconfident and got away with it, tied for third on points with Gemini 3.1 Pro, the best-calibrated model of the five. They got there by completely different routes, Flash's 10 exact scores against 32 correct results, Pro's 8 and 38, two more bullseyes traded for six more misses, landing on exactly the same total. The two Claude models undersold themselves instead. Their actual hit rate sat well ahead of their stated confidence, a stranger failure than overclaiming, but the one that won.

That shows up again in the spread of confidence values each model was willing to use.

{% include posts/inline-svg.html src="aiwc26-confidence-spread.svg" class="full-width" %}

Shape and colour both say the same thing here, a circle for an exact score, a triangle for a correct result, a square for a wrong one. Hover any mark to see which fixture it was. The bot and the human aren't on this chart. Both stated a flat 0.50 on every fixture, for opposite reasons (the bot has no concept of doubt and the human didn't bother varying his number).

Sonnet's confidence ranged from 0.3 to 0.65 and put fifteen fixtures below 0.4, real "I'm really not sure" territory. Fable 5 did the same on eight fixtures. GPT-5.5, Gemini 3.1 Pro and Gemini 3.5 Flash never went below 0.4 on a single one of their 72 picks. The two models that admitted real uncertainty fixture-by-fixture are the same two that finished first and second. GPT-5.5 also used thirty-one distinct confidence values down to the hundredth, against Sonnet's eight in neat 0.05 steps. Stating a number to two decimal places isn't the same as having thought about it that hard.

## The same mistake at two scales

All five models and the bot gave Belgium a perfect nine points across their three group fixtures, the strongest agreement of the whole exercise, and I flagged it at launch as the rankings talking rather than five independent views. Belgium actually drew twice and won once; the consensus scored 1 point out of 9, for everyone. Five models trained differently, queried separately, with no visibility into each other's answers, converged on the same wrong call and got marked down for it together. That's the inherited-dataset problem in miniature.

The same shape shows up in the [outright picks](https://github.com/omgmog/AIWC26/tree/main/_data/outrights) each model gave before kickoff (a champion, two finalists and four semi-finalists, chosen from the 48 qualifiers with nothing else to go on). Between them the five models used only six names across twenty semi-final slots (France, Spain, Brazil, England, Argentina and Germany). That's one opinion in five voices rather than five independent ones, and Belgium is what happens when that single inherited opinion is wrong. This time it's also what happens when it's right. Group stage results don't contradict any of those six picks, all of them topped their groups.

A third version of the same pattern shows up in the implied knockout bracket. At launch the five AI models agreed on 30 of the 32 qualifiers, arguing over three contested seats (Bosnia, Paraguay and Türkiye). Bosnia and Paraguay went through, Türkiye didn't, and of the 30 unanimous picks, five missed out entirely (Czechia, Iran, Scotland, South Korea and Uruguay). Individual model overlap with the real last-32 ran from 26 to 27 out of 32, the bot a little further back on 25.

[Iran got the rough end of it](https://www.bbc.co.uk/sport/football/articles/clywd8pl09do), unbeaten across all three group games and eliminated anyway, twice in one day. Their own last game, against Egypt, finished 1-1 after a stoppage-time goal was ruled out for offside, and every entrant called that scoreline right. What actually ended their tournament was a different match entirely. Algeria led Austria in the 93rd minute, which would have put Iran through, only for Austria to equalise with seconds left, handing Senegal the last seat on goal difference instead. Nobody predicted that. It hinged on a match Iran weren't even playing in.

## The draws thesis was half right, and the wrong model called it

[The launch post]({% post_url 2026/2026-06-11-five-ais-predict-the-world-cup %}) noted a disagreement. The friend who became Human 1.0 reckoned the new 48-team format, where two thirds of the field survives the groups, would push the draw rate up past the historical quarter, and the models mostly didn't buy it. The final count was 20 of 72, 27.8%, almost exactly the historical rate and nowhere near the spike the format was supposed to produce.

| Entrant | Predicted draws | Distance from actual (20) |
|---|---|---|
| GPT-5.5 | 21 | 1 |
| Human 1.0 | 24 | 4 |
| Claude Sonnet 4.6 | 13 | 7 |
| Gemini 3.5 Flash | 12 | 8 |
| Claude Fable 5 | 12 | 8 |
| Ranking Bot | 10 | 10 |
| Gemini 3.1 Pro | 10 | 10 |
{:.massive}

I'd assumed going in that the human control would end up vindicated here. He wasn't. He overshot by four. GPT-5.5 landed within a single fixture of the real draw count, the closest any entrant got. The same model most wrong about its own certainty was most right about the tournament's defining statistic. No entrant was strong at the aggregate rate, the calibration, and the fixture-by-fixture detail all at once.

## How each model described its own approach

Each entry came with a short `method_notes` field describing its own approach, [in its own words](https://github.com/omgmog/AIWC26/tree/main/_data/predictions):

| Entrant | Method notes |
|---|---|
| Claude Sonnet 4.6 | "Predictions blend historical World Cup pedigree, 2024-26 qualifying/continental form, squad quality, and host/altitude context, leaning toward favorites winning narrowly (1-2 goal margins) while predicting draws for closely matched pairings and allowing for plausible upsets among debutant nations." |
| Claude Fable 5 | "Weighted blend of FIFA ranking (Apr 2026), qualifying and recent tournament form, squad depth and key-player club seasons, plus host/venue effects. Scores are modal outcomes, not expected goals." |
| GPT-5.5 | "Predictions balance long-term World Cup strength, recent tournament and qualifying form, projected 2026 squads, host effects, and likely tactical matchups. Scorelines represent the single most likely full-time outcome rather than expected-goals averages." |
| Gemini 3.1 Pro | "Predictions synthesize historical Elo ratings, recent continental tournament form, and venue advantages for North American host nations. Baseline scoreline probabilities were adjusted based on squad depth, tactical matchups, and key player form during the 2025-26 club season." |
| Gemini 3.5 Flash | "Predictions are calculated based on historic tournament pedigrees, historical host advantages, recent qualification data, and current squad strength for the 2026 cycle." |
{:.massive}

They split into two camps. Sonnet, GPT-5.5 and Gemini 3.1 Pro all named broadly the same inputs (historical pedigree, qualifying form, squad quality, host/altitude effects) in similar language. Gemini 3.5 Flash's notes were the thinnest, just a list with nothing about how the inputs interact. Fable 5 was the only one to flag that it was predicting modal outcomes rather than expected-goals averages, a distinction that matters because an expected-goals model would hedge toward 1-1s and 2-1s far more than these predictions did.

Sonnet's notes went a step further. It said outright that it was "predicting draws for closely matched pairings and allowing for plausible upsets among debutant nations." That's the only note on the page that pre-commits to looking for upsets rather than just allowing for them in the abstract. It's also the model that finished top.

The per-fixture `reasoning` field shows the same instinct more specifically. Nine predictions across four models mention rotation or "dead rubber" energy, every one landing on a group's final fixture between an already-strong side and a weaker one, and eight of those nine got the result right. Every prediction here was locked before a ball was kicked, the project deliberately never re-prompted any of them with the actual Matchday 1 table in hand. It's a generic tournament-shape prior, the same one a casual fan would bring to a fixture list with no scores attached yet. The models know an already-qualified side plays its last group game differently, they just can't act on that knowledge adaptively because they never got to see whether it happened.

The clearest case of incentive-aware reasoning is Egypt v Iran, the one fixture every entrant called exactly right. Gemini 3.1 Pro's reasoning was "a gritty, low-risk draw that benefits both sides' qualification arithmetic," reasoning about the format's incentive structure explicitly, the exact mechanism the launch post's draws thesis argued for, and here it paid off completely. Every model, the bot, and the human landed on 1-1. It's the best evidence on the page that these models can apply the draws logic correctly, they just didn't bother often enough.

The reasoning strings also show which method notes were real and which were decoration. GPT-5.5's are the shortest, six words on average, competent boilerplate like "Two organized sides with limited separation." Both Gemini models padded theirs out with length rather than detail. Fable 5 is the outlier. Across six fixtures it names an actual player, Yamal, Mbappé, Korea playing without Son, the squad-level detail its method note claimed and the others' didn't. The human control didn't write reasoning for any of his 72 picks, just the scores, its own kind of honesty.

## Claude Fable 5 isn't there to ask about it

Claude Fable 5 finished second in the table. It's also not a model anyone can currently query. [It launched on 9 June](https://www.anthropic.com/claude/fable), entered its predictions, and on 12 June, mid-tournament, Anthropic suspended it worldwide following a [US government export-control directive](https://www.anthropic.com/news/fable-mythos-access) ordering it to cut off access for any foreign national. Anthropic's own position was that the government had shown it "only verbal evidence of a potential narrow, non-universal jailbreak," not grounds for pulling a model already deployed to hundreds of millions of people, but with no reliable way to separate foreign nationals from everyone else, the whole model went dark worldwide rather than being geofenced.

Fable 5's predictions were committed on 10 June and the suspension landed on the 12th, so I'd got its picks safely into the repo with a day to spare. Run this sweepstake a couple of days later and Fable 5 simply isn't an entrant.

None of these seven entries were ever reproducible in the way an experiment normally is. These are non-deterministic systems, and a second call to any of the five models on launch day could have returned different scorelines. What's reproducible is the artefact rather than the process, a timestamped, attributed JSON file, committed before kickoff, scored against what really happened. Fable 5 makes that distinction impossible to ignore, because nobody can put the same question to it again (results synced from the FIFA API for most of the tournament, after the first week of typing scores in by hand at 6am).

## What I'm taking from this

A deterministic lookup table built from a single ranking list and one rule finished fifth out of seven, ahead of a frontier LLM and a human who'd actually followed the tournament. The two models that beat it didn't reason their way to insights the others missed. All five converged on the same favourites and the same Belgium mistake. What they did was stay honest about their own uncertainty, and get rewarded for the picks they got right anyway. Knowing what the model didn't know mattered as much as knowing the football. Not bad for a glorified autocomplete.

{% include posts/figure.html src="2026-06/itcrowdmossGIF-ezgif.com-optimize.gif" %}{:.center}

The page will stay up at [blog.omgmog.net/AIWC26](https://blog.omgmog.net/AIWC26/) as the permanent record. Whether there's a knockout-stage follow-up is a separate decision for another day.
