---
title: "What's the most popular number in Hacker News titles?"
comments_issue: 163
tags: [programming, database]
---

Two consecutive titles on the HN front page yesterday had a 6 in them. This means _nothing_. But it's the sort of nothing that lodges in your brain until you do something about it, so what is the most popular number in Hacker News titles?

<!-- more -->

ClickHouse hosts the full HN dataset in their [public playground](https://play.clickhouse.com), and I am exactly the kind of person who finds that exciting. The [obvious query](https://play.clickhouse.com/play?user=play&tab=Query%20A#U0VMRUNUIG51bSwgY291bnQoKSBBUyBjCkZST00gKAogICAgU0VMRUNUIGFycmF5Sm9pbihleHRyYWN0QWxsKHRpdGxlLCAnXGQrJykpIEFTIG51bQogICAgRlJPTSBoYWNrZXJuZXdzX2hpc3RvcnkKICAgIFdIRVJFIHR5cGUgPSAnc3RvcnknIEFORCB0aXRsZSAhPSAnJwopCkdST1VQIEJZIG51bQpPUkRFUiBCWSBjIERFU0MKTElNSVQgMTA=) is barely a query at all:

<div class="query-result" markdown="1">

```sql
SELECT num, count() AS c
FROM (
    SELECT arrayJoin(extractAll(title, '\d+')) AS num
    FROM hackernews_history
    WHERE type = 'story' AND title != ''
)
GROUP BY num
ORDER BY c DESC
LIMIT 10
```

| Number | Titles  |
|--------|---------|
| 2      | 119,351 |
| 3      | 114,397 |
| 1      | 114,017 |
| 5      | 82,066  |
| 4      | 63,482  |
| 0      | 60,931  |
| 10     | 50,534  |
| 6      | 38,440  |
| 7      | 37,261  |
| 8      | 37,190  |
{:.compact}

</div>

The most popular number in HN titles is 2. Case closed, post _over_.

But why are the numbers so small?

{% include posts/figure.html type="iframe" src="https://www.youtube.com/watch?v=TN25ghkfgQA" title="That's the Vsauce jingle. This post is about to become 'but why is 19 like that'." %}

A table where small digits beat large ones looks, for one exciting second, like [Benford's Law](https://en.wikipedia.org/wiki/Benford%27s_law): the observation that in a lot of naturally occurring datasets, the leading digit is far more likely to be 1 than 9. It shows up in river lengths, stock prices, physical constants, election results, and it's genuinely spooky the first time you see it. It does not show up here. Benford's Law is about the leading digit of numbers that span several orders of magnitude (populations, incomes, file sizes), not single digits extracted from headline prose. The real explanation is duller than a law of the universe.

Except sixth place is 0, with 60,931 appearances. Sixty thousand titles do _not_ contain a bare zero. What they contain is "2.0" and "1.0", which `\d+` happily splits into their component digits. The same regex pulls the 3 out of "S3", chops "1,000 users" into a 1 and a meaningless 000, and generally treats every digit sequence as its own number regardless of context. 2's 119k lead is mostly the ghost of Web 2.0 and a decade of version numbers with decimal points. The numbers are accurate, they're just answering a slightly wrong question.

So I tried [a smarter pattern](https://play.clickhouse.com/play?user=play&tab=Query%20A#U0VMRUNUIG51bSwgY291bnQoKSBBUyBjCkZST00gKAogICAgU0VMRUNUIHJlcGxhY2VBbGwoCiAgICAgICAgYXJyYXlKb2luKGV4dHJhY3RBbGwodGl0bGUsCiAgICAgICAgICAgICdcXGJcXGR7MSwzfSg/OixcXGR7M30pK1xcYnxcXGJcXGQrKD86XFwuXFxkKyk/XFxiJwogICAgICAgICkpLCAnLCcsICcnKSBBUyBudW0KICAgIEZST00gaGFja2VybmV3c19oaXN0b3J5CiAgICBXSEVSRSB0eXBlID0gJ3N0b3J5JyBBTkQgdGl0bGUgIT0gJycKKQpXSEVSRSB0b1VJbnQ2NE9yWmVybyhudW0pIE5PVCBCRVRXRUVOIDE5MDAgQU5EIDIwMzAKR1JPVVAgQlkgbnVtCk9SREVSIEJZIGMgREVTQwpMSU1JVCAxMA==), one that captures comma-grouped numbers whole, treats decimals as single tokens, respects word boundaries, and filters years, because "years are popular on a news site" would not surprise anyone. The doubled backslashes below are because ClickHouse turns `\b` into a literal backspace character before the regex engine ever sees it, which produces an empty result set and takes longer than I'd like to admit to diagnose:

<div class="query-result" markdown="1">

```sql
SELECT num, count() AS c
FROM (
    SELECT replaceAll(
        arrayJoin(extractAll(title,
            '\\b\\d{1,3}(?:,\\d{3})+\\b|\\b\\d+(?:\\.\\d+)?\\b'
        )), ',', '') AS num
    FROM hackernews_history
    WHERE type = 'story' AND title != ''
)
WHERE toUInt64OrZero(num) NOT BETWEEN 1900 AND 2030
GROUP BY num
ORDER BY c DESC
LIMIT 10
```

| Number | Titles |
|--------|--------|
| 1      | 48,559 |
| 2      | 45,970 |
| 3      | 40,056 |
| 5      | 37,683 |
| 10     | 33,336 |
| 4      | 25,915 |
| 7      | 22,013 |
| 8      | 18,876 |
| 6      | 17,933 |
| 19     | 17,842 |
{:.compact}

</div>

Tokenising numbers is also more of a tar pit than it looks: "Python 3.11.2" still splits into "3.11" and "2", and the year filter can't tell 1984 the year from 1984 the novel. Good enough to move on from, at least.

2 loses nearly two thirds of its count and the title. 1 takes the crown. The phantom 0 is gone. The years were there all along. Without the filter, 2018, 2017 and 2020 chart at 8th to 10th; the naive regex was just inflating the small digits enough to bury them.

So why do small numbers dominate? HN titles are doing three things that all pull in the same direction.

The first is listicles. "3 ways to do X", "5 things I wish I'd known", "10 tools I actually use". The listicle is practically the native unit of the link post, and its count is almost always small and round. Nobody writes "17 things I wish I'd known" unless they genuinely have 17 things, which is rare, whereas "5 things" is a decision made in a title editor.

The second is version numbers. The highest-scoring titles for 1, 2 and 3 are almost entirely major software releases: Ghostty 1.0 and Rust 1.0 for 1, Llama 2 and Dall-E 2 for 2, Meta Llama 3 and Gemini 3 for 3. Software versioning starts at 1 and increments slowly, so the small numbers accumulate years of release announcements. This is also why 2 ranks above 3, which ranks above 4, almost perfectly. The earlier version numbers have simply existed longer.

The AI era is making this more pronounced. 2, 3, 4 and 5 are all getting a fresh wave of high-scoring model release posts on top of everything else.

The third is round numbers used as thresholds and rankings. "Top 10", "the No. 1 reason", "100 days of X". Digits get pressed into service as emphasis, and the rounder the number the more often it gets chosen. 10 charts well above both 9 and 11 specifically because of this: nobody writes "top 9 tools" unless they actually ran out at nine.

[Plotting all ten numbers over HN's full history](https://play.clickhouse.com/play?user=play&tab=Query%20A#U0VMRUNUCiAgICB5ZWFyLAogICAgbnVtLAogICAgY291bnQoKSBBUyBjCkZST00gKAogICAgU0VMRUNUCiAgICAgICAgdG9ZZWFyKHRvRGF0ZVRpbWUodGltZSkpIEFTIHllYXIsCiAgICAgICAgcmVwbGFjZUFsbCgKICAgICAgICAgICAgYXJyYXlKb2luKGV4dHJhY3RBbGwodGl0bGUsCiAgICAgICAgICAgICAgICAnXFxiXFxkezEsM30oPzosXFxkezN9KStcXGJ8XFxiXFxkKyg/OlxcLlxcZCspP1xcYicKICAgICAgICAgICAgKSksICcsJywgJycpIEFTIG51bQogICAgRlJPTSBoYWNrZXJuZXdzX2hpc3RvcnkKICAgIFdIRVJFIHR5cGUgPSAnc3RvcnknCiAgICAgIEFORCB0aXRsZSAhPSAnJwogICAgICBBTkQgdG9ZZWFyKHRvRGF0ZVRpbWUodGltZSkpIEJFVFdFRU4gMjAwNyBBTkQgMjAyNQopCldIRVJFIG51bSBJTiAoJzEnLCAnMicsICczJywgJzQnLCAnNScsICc2JywgJzcnLCAnOCcsICcxMCcsICcxOScpCkdST1VQIEJZIHllYXIsIG51bQpPUkRFUiBCWSB5ZWFyIEFTQywgbnVtIEFTQw==) reveals two moments where something external breaks the pattern:

{% include posts/inline-svg.html src="hn-popular-numbers-over-time.svg" class="full-width" %}

19 is the obvious one. Its all-time total of 17,842 is nothing special, until you look at 2020, where it logged 10,439 appearances, five times any other year. That's what a global pandemic named after the number does to its ranking. It was still elevated in 2021 as COVID-19 remained front-page news, then fell back to baseline as the headlines moved on.

The subtler one is 4 in 2023, where it jumps from around 1,400 the previous year to 2,298, briefly pulling level with 1 and 2. GPT-4 launched in March 2023 and dominated the front page for months. A single model release, visible as a kink in a line chart.

As for 6: 9th place, 17,933 appearances. The two 6s I saw on the front page in a row were entirely unremarkable. I have spent an evening establishing exactly that, and I regret _nothing_.

## Addendum

HN commenters, who exist to find the hole in any analysis, pointed out three problems with this.

First, the listicle explanation has a hole in it. HN's submission guidelines actively discourage gratuitous numbers in titles ("10 Ways To Do X" gets edited down to "How To Do X"), so the listicle numbers that survive into this data are the ones moderation let through. If anything that _strengthens_ the version number and round number explanations: what's left over is what got waved through as actually meaningful.

Second, the phantom zero isn't fully dealt with. The smarter regex catches "2.0" as one token, but "2.0.0" still leaks a bare 0, and [titles like "From 0 to 1M" or "ZeroVer: 0-Based Versioning"](https://play.clickhouse.com/play?user=play&tab=Query%20A#U0VMRUNUIHRpdGxlLCBjb3VudCgpIEFTIGMKRlJPTSBoYWNrZXJuZXdzX2hpc3RvcnkKV0hFUkUgdHlwZSA9ICdzdG9yeScKICBBTkQgdGl0bGUgIT0gJycKICBBTkQgbWF0Y2godGl0bGUsICdcXGIwXFxiJykKR1JPVVAgQlkgdGl0bGUKT1JERVIgQlkgYyBERVNDCkxJTUlUIDIw) contain a genuine zero. It's a mix of noise and real signal that would need proper version-string parsing to untangle.

Third, and this is the one that actually changes the story: [collapsing decimal versions into their integer base](https://play.clickhouse.com/play?user=play&tab=Query%20A#U0VMRUNUCiAgICB0b1N0cmluZyh0b1VJbnQ2NE9yWmVybyhudW0pKSBBUyBiYXNlX251bSwKICAgIHN1bShjKSBBUyB0b3RhbApGUk9NICgKICAgIFNFTEVDVCBudW0sIGNvdW50KCkgQVMgYwogICAgRlJPTSAoCiAgICAgICAgU0VMRUNUIHJlcGxhY2VBbGwoCiAgICAgICAgICAgIGFycmF5Sm9pbihleHRyYWN0QWxsKHRpdGxlLAogICAgICAgICAgICAgICAgJ1xcYlxcZHsxLDN9KD86LFxcZHszfSkrXFxifFxcYlxcZCsoPzpcXC5cXGQrKT9cXGInCiAgICAgICAgICAgICkpLCAnLCcsICcnKSBBUyBudW0KICAgICAgICBGUk9NIGhhY2tlcm5ld3NfaGlzdG9yeQogICAgICAgIFdIRVJFIHR5cGUgPSAnc3RvcnknIEFORCB0aXRsZSAhPSAnJwogICAgKQogICAgV0hFUkUgdG9VSW50NjRPclplcm8obnVtKSBOT1QgQkVUV0VFTiAxOTAwIEFORCAyMDMwCiAgICBHUk9VUCBCWSBudW0KKQpXSEVSRSB0b1VJbnQ2NE9yWmVybyhiYXNlX251bSkgPiAwIE9SIGJhc2VfbnVtID0gJzAnCkdST1VQIEJZIGJhc2VfbnVtCk9SREVSIEJZIHRvdGFsIERFU0MKTElNSVQgMTU=) (so "2.0", "2.5" and "2" all count as 2) puts 0 in the lead by a wide margin, 121,450 appearances, nearly three times 1's count. Almost all of it is ".0" version suffixes: every "Webkit 18.0", "Vue.js 2.0" and "Semantic Versioning 2.0.0" adds one. The most common number in HN titles might genuinely be 0. It just never shows up alone.

It also turns out [2.0 has 10,506 appearances against 1.0's 5,283](https://play.clickhouse.com/play?user=play&tab=Query%20A#U0VMRUNUIG51bSwgY291bnQoKSBBUyBjCkZST00gKAogICAgU0VMRUNUIHJlcGxhY2VBbGwoCiAgICAgICAgYXJyYXlKb2luKGV4dHJhY3RBbGwodGl0bGUsCiAgICAgICAgICAgICdcXGJcXGR7MSwzfSg/OixcXGR7M30pK1xcYnxcXGJcXGQrKD86XFwuXFxkKyk/XFxiJwogICAgICAgICkpLCAnLCcsICcnKSBBUyBudW0KICAgIEZST00gaGFja2VybmV3c19oaXN0b3J5CiAgICBXSEVSRSB0eXBlID0gJ3N0b3J5JyBBTkQgdGl0bGUgIT0gJycKKQpXSEVSRSBudW0gSU4gKCcxLjAnLCAnMi4wJywgJzMuMCcsICc0LjAnLCAnNS4wJykKR1JPVVAgQlkgbnVtCk9SREVSIEJZIGMgREVTQw==), which knocks a hole in the "earlier version numbers just existed longer" idea. 2.0 beats 1.0 because Web 2.0 is a culturally loaded phrase in a way Web 1.0 never was, and that swamps the longevity effect entirely. The ordering explanation holds for whole numbers. It falls apart for decimals.

The conclusion stands, small numbers dominate, but the reasons underneath are messier than one evening's digging suggested.
