---
comments_issue: 21
title: Using Greasemonkey scripts with Google Chrome
---

This isn't new news, but it's something I've found quite useful.

You can use userscripts created for Firefox/Greasemonkey in Google Chrome. Many of the scripts that you can find over on [userscripts.org](http://userscripts.org/) can be used effortlessly by Google Chrome, and once installed can be disabled/uninstalled from the Extensions tab.

<!-- more -->

The bit that I've found useful is that you can install any userscript in Google Chrome simply by naming giving it the correct information, and naming it in the right way.

The instructions are as follows:

Your script needs the userscript meta information at the top of the file

```javascript
// ==UserScript==
// @name Some Awesome Script
// @namespace Supporting website/authors website
// @description Description of the scripts functions
// @include Url of the website to apply to, wildcard
// @match The same as @include really
// @require Additional script/library from site or path
// ==/UserScript==
```

You need to name the file something like `some-awesome-script_1-0.user.js`

<s>Drag the script into your Chrome window, and you will be prompted to install the script.</s>

Chrome hasn't supported this method of installation for a while now. To install userscripts in Chrome now you will have to use [Tampermonkey](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo?hl=en)


Information sources:

- [http://www.chromium.org/developers/design-documents/user-scripts](http://www.chromium.org/developers/design-documents/user-scripts)

- [http://www.freeopenbook.com/javascript24/ch18lev1sec3.html](http://www.freeopenbook.com/javascript24/ch18lev1sec3.html)
