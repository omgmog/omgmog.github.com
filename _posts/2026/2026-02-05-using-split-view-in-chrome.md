---
title: Using split view in Chrome
comments_issue: 134
tags: [chrome, browser, productivity]
---

Chrome's split view tabs is one of those features that silently arrived and slipped into my workflow. I've found myself using it more and more over the past couple of weeks since it rolled out at the end of 2025. It's as intuitive as tab grouping (hold shift when selecting multiple tabs), and genuinely useful. The kind of feature that slots in and makes me wonder how I managed without it.

<!-- more -->

## How it works

Chrome added a native split screen feature back in November. Right-click any tab and there's a split view option (the wording changes depending on context - "Add tab to new split view" on the active tab, "New split view with current tab" on inactive tabs). Pick another tab and they sit side by side in the same window.

{% include posts/figure.html src="2026-02/chrome-split-tabs/split-tab-menu.png" %}{:.center}

{% include posts/figure.html src="2026-02/chrome-split-tabs/split.png" %}{:.massive}

Each half gets its own status area at the bottom right, the browser toolbar gets a split tab icon to manage things (swap sides, close one view, split it back out), and the address bar content follows whichever side has mouse focus. The divider resizes by dragging, or double-click it to quickly swap sides.

{% include posts/figure.html src="2026-02/chrome-split-tabs/split-status-menu.png" %}{:.center}

{% include posts/figure.html src="2026-02/chrome-split-tabs/split-toolbar-menu.png" %}{:.center}

## Why I'm using it

The obvious case: documentation on one side while working on the other. Reading through API docs, following a tutorial, watching a YouTube video - whilst coding or testing in the other half. No alt-tabbing, no hunting for which window's where.

I use Raycast for window management. I've got keyboard shortcuts to snap windows left and right, quarter screens, the lot. For Chrome tabs though, split view is better. With separate Chrome windows I'm managing window positions, worrying about which window's in focus, dealing with them getting buried under other apps. With split view it's _just_ one window, one thing to manage. Even if the viewports are a bit smaller than using two windows.

{% include posts/figure.html src="2026-02/chrome-split-tabs/split-vs-windows.png" %}{:.massive}

I'm running dual 2560x1440 displays with loads of windows open - editor, Slack, work stuff, personal stuff - and split view still makes a difference. Even with all that screen space and Raycast managing it, keeping related tabs in one window is simpler than juggling separate Chrome windows across displays.

Firefox is getting split view in 148. It's [currently in Nightly for testing](https://blog.nightly.mozilla.org/2026/01/26/take-note-split-view-is-ready-for-testing-these-weeks-in-firefox-issue-194/). Competition's good - hopefully it pushes both browsers to refine the feature further.
