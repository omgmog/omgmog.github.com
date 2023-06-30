---
title: My workflow for discovering new VR content
comments_issue: 59
tags: [vr]
---

Since launching the [UX of VR website](https://www.uxofvr.com) last year I've been looking for ways to keep on top of new VR content. For most of the last year I relied solely on a mixture of Google Alerts, manually using the search functionality on websites and browsing VR blogs daily. Here's how I improved on that process.

<!-- more -->

A couple of weeks ago I decided that this process could be improved a lot, to move the burden of curation from discovery to consumption. I can now spend less time looking for content, and more time consuming it from one location.

At the time of writing this article, I've just passed over 1000 articles in around two weeks. That's a lot of content.

So how am I going about this?

First comes automation. I'm a big fan of automation where possible, and it's usually the result of laziness that I end up automating things (-- Ironically, it was through shear laziness that I hadn't automated this process sooner!) 

I'm using [IFTTT](https://ifttt.com) to watch a bunch of RSS feeds (VR blogs, tags on Medium, etc.) and create new issues on a Github repository when a new article is posted. To begin with I simply had an IFTTT recipe that looked like this:

{% include posts/figure.html src="2017-08/chrome_2017-08-02_16-32-52.png" %}{:.center}

After the first couple of days, I realised I needed a bit more control over what made it through to my reading list, so I switched to using IFTTT's platform widgets to add a bit more control.

{% include posts/figure.html src="2017-08/chrome_2017-07-31_20-35-26.png" %}{:.center}

Here's an example of the filtering code I'm using:

```javascript
let blockedAuthors = [...]

blockedAuthors.forEach((author) => {
  if (Feed.newFeedItem.EntryAuthor.match(author)) {
    // If the author is in my blockedAuthors list, skip them
    Github.createNewIssueForRepository.skip(`spam: ${author}`)
  }
})
```

I can specify an array of authors to block, and then if anything by these authors comes up in the feeds it's simply skipped and doesn't make it to the reading list on Github.

One of the main problems I'm left with is duplicate posts making it through to my list of issues. This is because people tag single pieces of content with multiple tags that I'm following. I could probably do something within my IFTTT applet to get around this, but I haven't yet.

This workflow pushes a surprising 40+ pieces of content each day. The workflow of consuming this is as follows:

1. Open the issue in a new tab
2. Switch tab to the first open issue
3. Click the URL
4. Read the content
5. Go back to the issue
6. Close the issue
7. Close the tab
8. Go to `1.`

After doing this for the first couple of weeks I thought that there must be a better way -- well, actually after taking a week's holiday and coming back to a backlog of over 500 issues, I decided there _had_ to be something I could do to reduce the friction of this process.

{% include posts/figure.html src="2017-08/chrome_2017-07-31_20-45-51.png" %}{:.center}

I'm a huge fan of Userscripts. Either as a simple browser extension, or as a simple piece of additional Javascript that's injected in to a page, Userscripts allow you to add more functionality to any website.

To use Userscripts you can install [Greasemonkey](https://addons.mozilla.org/en-gb/firefox/addon/greasemonkey/) (for Firefox) or [Tampermonkey](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo?hl=en) (for Chrome).

I'm already using a script to [add custom navigation to Github](https://greasyfork.org/scripts/20830-github-custom-navigation), so I figured I could do with a navigation item to automatically open all of the issues I can see in a list in new tabs.

```javascript
// ==UserScript==
// @name         Open all the issues
// @namespace    https://blog.omgmog.net/
// @version      0.1
// @description  Opens all of the issues on the current page in new windows
// @author       Max Glenister
// @match        https://github.com/*/*/issues
// ==/UserScript==

(function() {
  'use strict';
  let linkAnchor = '#open10';
  function onLinkClick(e) {
    e.preventDefault();
    let links = document.querySelectorAll('.issues-listing .js-issue-row .js-navigation-open');
    for (let i=0; i<links.length;i++) {
      window.open(links[i].href, i);
    }
  }
  document.querySelector(`[href="${linkAnchor}"]`).onclick = onLinkClick;
})();
```

It's a simple script, but it reduces my workflow:

1. Click the "Open all issues" icon (to open up to 25 issues at once!)
2. Switch tab to the first open issue
3. Click the URL 
4. Read the content
5. Go back to the issue
6. Close the issue
7. Close the tab

{% include posts/figure.html src="2017-08/chrome_2017-08-02_16-15-12.png" %}{:.center}

There might be _as many steps_ there, but it's a much easier process. I can depend on keyboard shortcuts a lot more (such as `cmd`+`w` to close the tab), and there is less clicking required to open issues in bulk. Perfect.

Consuming so much content is time consuming, so I usually go through this process on a slow afternoon, or over lunch, or before starting my work for the day. Anything that I think is interesting gets shared, and anything that is super useful for the UX of VR gets tagged and I later add it to the [UX of VR website](https://www.uxofvr.com).

One of the most surprising things about this workflow is the huge amount of content that gets published on the subject of "Virtual Reality". It's astounding really. The content _does_ vary, from editorial pieces, to personal experiences and reviews, from business analysis of current trends through to press releases.
