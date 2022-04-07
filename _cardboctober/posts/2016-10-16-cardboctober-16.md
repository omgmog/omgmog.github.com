---
title: "16: Getting in and out of Fullscreen"
---

Today we’re looking at the task of getting in and out of Fullscreen. Fullscreen helps maintain an immersive experience.

When using JavaScript as we’re confined to the capabilities of the web browser. <!-- more --> This isn’t so bad for most things, but cross-browser differences can be a big problem. We’ve got the FullScreen API which allows us to programmatically make the browser window full screen and hide the browser UI. From [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Fullscreen_API):

> The Fullscreen API provides an easy way for web content to be presented using the user's entire screen. The API lets you easily direct the browser to make an element and its children, if any, occupy the fullscreen, eliminating all browser user interface and other applications from the screen for the duration.

At the time of writing this (October 2016) the support for FullScreen is very patchy across the board and needs vendor prefixed variants for each part of the FullScreen API:

{% include posts/figure.html src="2016-10/16/support.png" %}{:.massive}

FullScreen must be triggered by the user, it can’t be triggered automatically.

I began Cardboctober simply targeting Chrome with my FullScreen implementation, with a fallback to the W3C specification. By the second week I threw out my implementation and went for a [Fullscreen API polyfill](https://github.com/neovov/Fullscreen-API-Polyfill).

Even with the polyfill in place on the JavaScript side of things, you still need to use vendor-prefixed CSS selectors for styling things in and out of fullscreen mode (such as hiding a “go fullscreen” button).

{% include posts/figure.html src="2016-10/16/fsdevice.png" %}{:.massive}

In my [core.js library](https://github.com/cardboctober/max/blob/master/js/core.js) I’ve now got a function called `createFullScreenControl` that injects a “go fullscreen” button. This functional only creates the button if the page it’s called from is not embedded in an iframe, is on a mobile device and if the browser supports fullscreen.

```javascript
var createFullScreenControl = function() {
  // If we're inside an iframe, there is probably
  // already a control on the parent so get out of dodge
  if (window.top !== window.self) {
    return; }
  if (!document.fullscreenEnabled) {
    return; }
  if (core.isPocketDevice()) {
    // Create a button
    var button = document.createElement('button');
    button.classList.add('fs-toggle');
    button.innerText = 'Enter fullscreen';
    // Append to body
    document.body.appendChild(button);
    // Bind it to enter fullscreen
    button.addEventListener('click', function(e) {
      document.body.requestFullscreen();
    }, false);
    // Oh also create some styles
    var css = '.fs-toggle { background: #000; border: 2px solid #0f0; padding: .5em 1em; font-size: 28px; color: #0f0; box-shadow: 0 0 80px 20px #000; box-sizing: border-box; position: absolute; z-index: 10001; margin: auto; left: 0; top: 0; bottom: 0; right: 0; width: 300px; height: 100px; }';
    css += ':fullscreen .fs-toggle { display: none; }';
    css += ':-webkit-full-screen .fs-toggle { display: none; }';
    css += ':-moz-full-screen .fs-toggle { display: none; }';
    var styleInject = document.createElement('style');
    styleInject.innerText = css;
    document.head.appendChild(styleInject);
  }
};
```

It’s a good idea to start your regular render loop after you’ve entered fullscreen as the button will block interaction for the most part.

### Update:

I realised 2 weeks later that I didn't really mention getting out of fullscreen. On your Android device you'll be able to hit the 'back' button, which is a good enough solution without us having to create a new device!

