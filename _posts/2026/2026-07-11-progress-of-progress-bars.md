---
title: "The progress of progress bars"
comments_issue: 162
tags: [ux, design, ai]
---

I was waiting for Claude to answer a token-heavy question at work the other day, the little "Thinking…" label flickering into "Wibbling…" and then "Moseying…", and I caught myself doing the thing I always do when a spinner takes too long, staring at it, trying to divine meaning from the word choice. Is it nearly done? There's no percentage, no bar, just a word standing in for "trust me, something is happening." It sent me down a rabbit hole into where progress bars came from, and it turns out they were never really about progress at all.

{% include posts/figure.html src="2026-07/progress/clauding.gif" %}{:.center}

<!-- more -->

In 1985, [Brad Myers](https://www.cs.cmu.edu/~bam/) ran a study at the University of Toronto. He gave participants identical tasks on identical computers (some with a progress bar during the wait, some without). Users who saw the bar rated the computer as faster and more trustworthy, even though the wait was identical. More tellingly, the bar didn't even need to be accurate: users preferred an inaccurate one to no bar at all.

From the beginning, the progress bar was about anxiety management, not progress.

## The honest era

The early bars at least had a simple story to tell. Bytes transferred. Files copied. A rectangle filling from left to right. The user could imagine the machine doing a finite amount of work and reporting back, honestly, as it went.

{% include posts/figure.html src="2026-07/progress/debian.png" %}{:.center}

Whether that was ever quite true is another matter. Even a byte counter has to contend with buffering, compression, network variability. But the story was simple enough to believe.

Users started trusting the number, though. And computers, it turned out, were not very good at producing accurate numbers.

## The collapse of trust

The classic example is the Windows file copy dialog. At some point it grew percentage complete, files remaining, time remaining, and transfer speed. It looked authoritative, like instrumentation.

{% include posts/figure.html src="2026-07/progress/windows.png" %}{:.center}

The problem is that most file operations are not linear. The first 90% of a large copy might be simple, big files, cached reads, predictable throughput. The last 10% might be thousands of tiny files, permissions checks, antivirus scanning, metadata writes, work the bar has no way of anticipating. A 10GB video file and ten thousand 1KB documents might contain the same data, but they're nowhere near the same amount of work.

So "2 minutes remaining" became less a measurement and more an extrapolation. The computer was not lying exactly. It was doing its best with incomplete information, projecting forward from a sample that was not representative of what came next.

This is the point where the progress bar stopped being an instrument and became a performance.

## The reassurance era

Once users stopped believing the numbers, interfaces adapted. Animated stripes moved across stalled downloads. Spinners replaced bars. Labels shifted from percentages to phrases like "preparing", "almost there", "finishing up". The goal moved from reporting a state to managing an expectation.

[Nielsen Norman Group](https://www.nngroup.com/articles/progress-indicators/), whose usability guidelines shape most of the software you use, recommends bars move quickly at the start and slow near the end, not because that reflects the actual work, but because users tolerate "almost done" better than "just getting started." The psychologically optimal progress bar is, by design, the opposite of an accurate one.

The 99% problem is the most visible symptom of all this. Every installer in history has spent an implausible amount of time there, long enough to become a running joke, expected rather than noticed. Users stopped reading it as a measurement and started reading it as a signal that something, anything, was happening.

The strangest part is that the numbers got more precise at exactly the point where the underlying estimates became less reliable. Windows would tell you "43 seconds remaining" with the same visual authority as a clock. The precision was a UI convention, not a reflection of any real calculation.

Apple drew a different conclusion. Its interface guidelines have long favoured indeterminate indicators, spinners and beach balls, over percentages for anything whose duration can't be reliably estimated. 

{% include posts/figure.html src="2026-07/progress/beachball.gif" %}{:.center}

The spinning beach ball means, in effect, "I am working, but I refuse to tell you for how long." It's honest about its dishonesty in a way the Windows dialog never was, though users learned to read it differently. The [spinning beach ball of death](https://en.wikipedia.org/wiki/Spinning_pinwheel) became shorthand not for "please wait" but for "something has gone wrong." Vagueness has its own failure mode.

## Reticulating splines

Language crept into progress bars long before AI did. SimCity 2000, released in 1993, filled its terrain generation sequence with a rapid succession of status messages, "Creating Hills", "Smoothing", "More Smoothing", "Yet more smoothing", "Tracing Rivers", and between them, ["Reticulating Splines"](https://patcoston.com/co/spline.aspx). The phrase sounds authoritative enough that players assumed it described some complex process under the hood. It didn't. Will Wright, who co-authored the game, later confirmed it was a joke, the words chosen because they look and sound as if they mean something. Individually they do: "reticulate" means to divide into a net-like structure, a "spline" is a mathematical curve. Together, in this context, they mean nothing at all.

The Sims carried the gag forward with its own variations ("Calculating money supply", "Normalising social network", "Inserting chaos generator"). It had become a tradition, fake precision as a running joke, fake tasks as loading screen folklore.

The difference from everything else in this history is that SimCity 2000 was upfront about the fiction. Nobody genuinely thought "reticulating splines" was measuring anything. It was closer to a magician's patter, filling the silence while the real work happened out of sight, a progress indicator that never once pretended to be honest, and was more charming for it.

## No percentage complete

Which brings me back to Claude's "Thinking…" label. AI has created a different version of this problem: a language model generating a response has no meaningful percentage complete. No one can say "your answer is 63% generated", the answer has no predetermined length to measure against.

So interfaces have moved back to language, the same move SimCity made thirty years earlier. "Thinking." "Reasoning." "Searching." "Drafting." "Checking my work." Whatever I was trying to read into them, these are descriptions of activity, narration rather than instrumentation. The difference is that Claude isn't joking, something is genuinely happening behind each word, I just can't measure how much is left.

It's not just Claude, either. [Alex Beals dug through the source of the major AI coding tools](https://blog.alexbeals.com/posts/claude-codes-thinking-animation) and found Claude Code cycling through well over a hundred verbs (Thinking, Cooking, Shenaniganing), each paired with its own spinning glyph, from a plain interpunct up to increasingly ornate asterisks and stars. Gemini does the same trick with a Braille spinner. Codex leans into wording that reads, depending on your mood, as either playful or faintly ominous ("Disobeying" is one of its picks). Everyone building these tools has landed on the same answer independently: when there's nothing to measure, narrate.

Some go further still. Ask Gemini to review a document and it'll tell you it's "Reviewing User Feedback", "Analysing Feedback Requirements", "Crafting the Response", messages generated for your specific request rather than drawn from a fixed list. The progress indicator isn't even pre-written any more; the model narrates its own work as it goes, either the most transparent loading screen ever built or the slickest version of the same old trick.

People customise the fixed lists themselves, too. Claude Code has a `spinnerVerbs` setting for swapping the defaults for your own, and [a whole site](https://spinnerverbs.com/) plus a [GitHub repo of a few thousand options](https://github.com/wynandw87/claude-code-spinner-verbs) have sprung up around it, reticulating splines included. Forty years on from Brad Myers, people are still tinkering with the words on a loading screen for fun rather than accuracy.

## A mind, not a meter

It's a different kind of narration to anything that came before it. A download never said "I am considering your request." An installer never said "reflecting on possible approaches" (even SimCity, taking the mick, stuck to tasks rather than thoughts). "Thinking" and "reasoning" describe a mind having a process, not the process itself. This is an interface claiming, however loosely, to have an inner life, and asking me to wait on it the way I'd wait on a person.

## What it was always about

The best progress indicators have probably never been the most accurate ones. A terminal output counting 47,381 files of 100,000 is useful because the user understands the work. An AI saying "checking a few possibilities" might be useful for the same reason, even without a number attached.

What both have in common is that they do not pretend to know something they do not know. The Windows copy dialog pretended. The installer stuck at 99% pretended. The "2 minutes remaining" that became 20 minutes pretended.

The lesson isn't "be more accurate." Accuracy was never really on the table. It's "don't imply precision you don't have." The progress bar failed when it started looking like a clock. The ones that still work are the ones that look like what they are.