---
title: Extra small extra macro keys v2.0
tags: [3d-printing]
archived: true
---

Well I took another look at the design of my macro keys project sooner than I expected. I started over with the design of the 3D-printed part of this project, and then moved the buttons and guts over from the previous version.<!-- more -->

This design works a lot nicer, and I figured I'd include some sample code for the Arduino Pro Micro here:

```cpp
#include <Keyboard.h>
int buttonOne = 9; // Pin 9
int buttonTwo = 8; // Pin 8

void setup() {
  pinMode(buttonOne, INPUT);
  pinMode(buttonTwo, INPUT);

  digitalWrite(buttonOne, HIGH);
  digitalWrite(buttonTwo, HIGH);
}
void loop() {
  if (digitalRead(buttonOne) == 0) {
    // Pressed button one
    Keyboard.press( KEY_LEFT_CTRL );
    Keyboard.press( 'c' );
    Keyboard.release( 'c' );
    Keyboard.release( KEY_LEFT_CTRL );
    delay(500);
  }
  if (digitalRead(buttonTwo) == 0) {
    // Pressed button two
    Keyboard.println("A single button press has typed this text");
    Keyboard.press( KEY_RETURN );
    Keyboard.release( KEY_RETURN );
    delay(500);
  }
}
```

This makes uses of the `Keyboard.h` Arduino library, which you can find documented very thoroughly here: [Keyboard on the Arduino Docs](https://www.arduino.cc/reference/en/language/functions/usb/keyboard/)

The macro keys are designed to snap on to the top edge of my keyboard, so they sit just above the `fn` keys. You can set them up to press a key combination, or type out a bunch of text with a single button press.

<div class="inline-grid two-columns">
{% include posts/figure.html src="3d-printing/IMG_20180511_160609.jpg" %}
{% include posts/figure.html src="3d-printing/IMG_20180511_160617.jpg" %}
{% include posts/figure.html src="3d-printing/IMG_20180511_161215.jpg" %}
{% include posts/figure.html src="3d-printing/IMG_20180511_162351.jpg" %}
{% include posts/figure.html src="3d-printing/IMG_20180511_161332.jpg" %}
{% include posts/figure.html src="3d-printing/IMG_20180719_162223.jpg" %}
</div>
