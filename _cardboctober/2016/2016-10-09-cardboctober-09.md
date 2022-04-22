---
title: "09: Speech recognition"
has_hack: true
---

Today's hack is using the `speechRecognition` API. How can this be useful in Google Cardboard VR? It can add another level of input to our limited arsenal. So let's take a closer look at that.

<!-- more -->

## Command based input

When working with Google Cardboard VR using WebVR you're traditionally limited to a couple of input methods:

- looking (or "gazing") at something
- tapping the screen (or using a capacitive button)

Besides these methods you could use a Gamepad with the Gamepad API (I'll take about that later this week!) -- but that would require the user to pair a gamepad, and map buttons, and all sorts of nonsense.

Which brings us to a third method of input: Speech

The `speechRecognition` API has limited support right now (as you can [see on MDN](https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition#Browser_compatibility)), and needs to be used with the `webkit` prefix in Chrome, but that aside it works nicely in Chrome on desktop and Android.

The `speechRecognition` API will automatically create a transcript for the speech it hears when called, and can even return interim results, or a number of alternative interpretations of what was said. That in hand, we can take the most highly ranked transcript and act on it.

## Using the `speechRecognition` API

You'll need to create a function that initiates the `SpeechRecognition.start()` method, and then create functions for each of the `onstart`, `onend` and `onresult` event handlers:

```javascript
var startListening = function () {
  var recognition = new webkitSpeechRecognition();
  recognition.lang = 'en-US';
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;
  recognition.start();

  recognition.onstart = function () {
    // Do something when listening starts
    console.log('Start listening');
  };
  recognition.onend = function () {
    // Do something when listening ends
    console.log('Finished listening');
  };
  recognition.onresult = function () {
    // Do something with the transcript of the speech
    console.log('You said:', event.results[0][0].transcript);
  };
};
```

With this we can call `startListening()` and we'll get a transcript of whatever is said in the console. So how can we use this with our VR application?

## Doing something with the transcript

We can take the speech transcript from `startListening()` and simply create a function containing a massive `switch` statement to handle various commands:

```javascript
var handleTranscript = function(transcript) {
  switch (transcript) {
    case 'hello computer':
      console.log('Hello Max');
      break;

    case 'tell me the time':
      var now = Date.now();
      console.log(now.getHours() + ':' + now.getMinutes());
      break;

    default:
      console.log("Sorry I don't understand " + transcript);
      break;
  }
};
```

Now inside the `onresult` event handler we can call `handleTranscript()` and do something with the transcript.

## Putting this to use in VR

It's not much of a jump to make use of `speechRecognition` in VR -- we just need to _do things_ inside those `switch case` blocks.

Here's an example where I move an `object` based on a `speechRecognition` transcript:

```javascript
var handleTranscript = function(transcript) {
  switch (transcript) {
    case 'go forward':
      object.position.z -= 10;
      break;
    case 'go backward':
      object.position.z += 10;
      break;
    case 'go left':
      object.position.x -= 10;
      break;
    case 'go right':
      object.position.x += 10;
      break;
  }
};
```

Very simple. So that's where we're at with todays hack. It'll only work in Chrome, and it might crash your browser as it's an experimental API, but it's pretty cool.

{% include posts/figure.html src="2016-10/09/giphy.gif" %}{:.massive}

Now ofcourse there is a bit more to this than just implementing `speechRecognition` and some functions to handle the transcript created by the `onresult` event handler. You'll need to come up with a way to inform the user of the available speech commands, indicate the current state (listening or not), and provide feedback for unrecognised commands.
