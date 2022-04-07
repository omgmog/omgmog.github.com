---
title: 'Vivaldi: Another contender to the array of Webkit-derived browsers'
comments_issue: 87
---

Earlier this week a new browser called "Vivaldi" sprung up across many of my early-morning technology news feeds.

I managed to put off trying it out for a couple of days, due to my being too busy, and agreeing with many of the pessimistic comments that were strewn across the release announcement posts.

<!-- more -->

{% include posts/figure.html src="GjwGUS9.png" %}{:.massive.center}

The announcement was met with some derision...

- "Who are these "Vivaldi" people and why would 'Our friends' need a new browser?"
- "Oh this is just another webkit wrapper"
- "Bundling Mail and all of that in the browser? Hello Netscape 2015!"
- "The website doesn't even have any screenshots, why would I download this?"

If you spend a minute to read the introductory section on the [Vivaldi website](https://vivaldi.com/), you'll discover that it's not a new team as such, but actually an old team longing to bring a product back to it's roots.

The team in question? Some of the folks from Opera. The browser? Their vision for where Opera should be today, including the expected integrated mail and other features that long-time Opera users are used to, but have been missing since [Opera moved to Webkit](https://dev.opera.com/blog/300-million-users-and-move-to-webkit/) (and [since Opera 15, Blink](https://dev.opera.com/blog/a-first-peek-at-opera-15-for-computers/)) back in 2013.

Vivaldi is using [Blink](http://www.chromium.org/blink) at it's core, but in your face you'll find a simple bold interface. It's powered by [node.js](http://nodejs.org/) and [React](http://facebook.github.io/react/), and doesn't appear to be using much in the way of native UI components.

This lack of native UI is particularly disjointing, as it means the browser window doesn't look like other applications on OS X, and doesn't "feel" right.

{% include posts/figure.html src="TLmxOXh.png" %}{:.massive.center}

Visiting a couple of different sites in Vivaldi, you'll notice that the interface is more of a chameleon than anything, taking on the prominent colour from the favicon of the page you're viewing to style the toolbar and active tab.

{% include posts/figure.html src="lfINVku.png" %}{:.massive.center}

It would be interesting if this could support the [`<meta name="theme-color" />` tag](https://github.com/whatwg/meta-theme-color) in the future, to allow developers to set a specific colour for the interface.

As a front-end developer, it's a pain to have another variation of a browser in the mix, because if it gets any serious uptake it'll mean an additional browser to test things in.

Right now it's using Blink (`537.36`), so it should be identical in rendering to Chrome, and I hope it doesn't deviate too far from Chrome in the future!

{% include posts/figure.html src="w0wHaSo.png" %}{:.massive.center}

This is just a "Technology preview", and as such it lacks a lot of features, but it's nice to see that this is being worked on!
