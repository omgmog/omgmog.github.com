---
title: "14: Debugging your Cardboard with Chrome"
redirect_from:
  - /post/cardboctober-14/
---

Today I'm going to be talking about how I test and debug while working on this Cardboctober hacks. If you make it to the end I'll have a recap of Week 2 of Cardboctober.

<!-- more -->

## My core.js and boilerplate

Typically I build a Three.js scene using a boilerplate/skeleton that I've made. It gives me the boring stuff such as the basic HTML structure of the page, loads all of the JavaScript dependencies that I'm using, and includes my `core.js`.

{% include figure.html src="2016-10/14/core.jpg" %}{:.massive.center}

I've talked a bit about my `core.js` in previous Cardboctober posts. This is just a small set of functions I've created to achieve common tasks such as:

- Setting up the Three.js renderer and scene
- Wrapping the construction of Mesh's to make it less work
- Setting up the control method based on where you're viewing the demo (PC or Mobile)
- Creating a device to enter fullscreen

I created the majority of `core.js` a year ago for my earlier foray in to Google Cardboard development with JavaScript: [blog.omgmog.net/jscard.xyz](https://blog.omgmog.net/jscard.xyz). It has moved on quite a bit since then, on Cardboctober [day 10](https://github.com/cardboctober/max/commit/eddb03a8a0304a8ce43847567e343b5964b0a545) I spent a lot of time refactoring the `core.js` and moving more of the Three.js boilerplate code over to it, to simplify/clarify the `demo.js` for each day.

Moving all of this repeated functionality out to a core set of functions ensures that I have a consistent starting point each day and any problems I'm experiencing can be narrowed down to just the code for the day's `demo.js`.

## Chrome Dev Tools

I'm using Google Chrome for everything -- it's Developer Tools are great, and the ability to remote debug Chrome on Android over USB is very useful.

Before I take my code over to a real device though, I tend to use Chrome's device emulation and sensor emulation to set things up.

{% include figure.html src="2016-10/14/devices.png" %}{:.massive.center}

This can be accessed by opening Developer Tools (`cmd`+`alt`+`J` on Mac) and then clicking the little device icon (`cmd`+`shift`+`M` on Mac).

To access the sensor/orientation emulation, open the Drawer in Dev Tools (Press `Esc` if it's not already visible) and then from the menu, select Sensors.

{% include figure.html src="2016-10/14/sensors.png" %}{:.massive.center}

When I'm happy with how it's looking in Chrome on my Mac, or if I get bored and want to try it _for reals_ I'll move over to my Nexus 5x. I do a lot of debugging and play testing using my phone and various types of Google Cardboard. If I'm messing with something particularly fiddly or hard to debug, I'll connect my phone to my Mac by USB and remote debug it.

To access the remote debugging, open Developer Tools and then click the little three-dots menu (aside: what are we calling that these days? kebab menu?), go to "More tools" and then "Inspect devices..."

{% include figure.html src="2016-10/14/remote-debug.png" %}{:.massive.center}

From here you can access a regular JavaScript console for Chrome running on your phone, and even see what is being rendered.

## Other browsers and platforms

I've not been too focused on supporting anything other than Chrome for the Cardboctober hacks, and that's fine. The idea of these hacks is that they're quick and dirty -- and what's dirtier than that? If they work in Safari on an iPhone that's a bonus.

## Recap of Cardboctober Week 2

The second week of Cardboctober has been a long one. I think the initial honeymoon period has passed, so now the novelty of doing something daily has turned in to a bit of a chore. But that's fine.

I've had a plan for what to do weekly/daily and I was following it for most of this week, until I discovered that one of the things I wanted to use in a hack (`gamepad` API) didn't work well/consistently and wouldn't be accessible to everyone trying the hacks that use it. So I decided to ditch that from the plan and spend two days making zombie-themed games with no real learning direction.

This week also saw some more interest on social media.

Here are the things we've made this week:

### Day 08
- [Playing Sounds](https://cardboctober.github.io/max/08/) (Max)
- [Triangle](https://cardboctober.github.io/ben/08/) (Ben)
- [Smoke sphere](https://cardboctober.github.io/pete/08/) (Pete)

### Day 09
- [Speech Recognition](https://cardboctober.github.io/max/09/) (Max)
- [Floor](https://cardboctober.github.io/ben/09/) (Ben)
- [Jetpack](https://cardboctober.github.io/pete/09/) (Pete)

### Day 10
- [HTML5 Video](https://cardboctober.github.io/max/10/) (Max)
- [Circles](https://cardboctober.github.io/ben/10/) (Ben)
- [Island](https://cardboctober.github.io/pete/10/) (Pete)

### Day 11
- [Webaudio Beat Sequencer](https://cardboctober.github.io/max/11/) (Max)
- [Bubbles](https://cardboctober.github.io/ben/11/) (Ben)
- [Blink](https://cardboctober.github.io/pete/11/) (Pete)

### Day 12
- [AAAAH! Zombies](https://cardboctober.github.io/max/12/) (Max)
- [Attendee graph](https://cardboctober.github.io/ben/12/) (Ben)
- [720](https://cardboctober.github.io/pete/12/) (Pete)

### Day 13
- [AAAAH! More Zombies](https://cardboctober.github.io/max/13/) (Max)
- [Cat](https://cardboctober.github.io/pete/13/) (Pete)

### Day 14
- This post (Max)
- [Seascape](https://cardboctober.github.io/pete/14/) (Pete)

So that's it for Week 2. Next week I'm going to be working on posts about UX and design patterns rather than creating substantial hacks as I'll be away on holiday.
