---
title: "18: Moving around in VR"
redirect_from:
  - /post/cardboctober-18/
---

Unless your VR experience is a roller coaster or some other sort of rail-based experience, you shouldn't take movement control away from the user. Lack of movement control can cause VR sickness.

Here are a couple of approaches for user-controlled movement in VR:

<!-- more -->

### Gamepad

An obvious hangover from non-VR first-person games, moving around with a gamepad is an easy way to provide movement in your 3D space. You can still look around using orientation-based movement.

{% include figure.html src="2016-10/18/gamepad.png" %}{:.massive.center}

D-pad to move back/forward/left/right and an additional button to jump or interact.

### Teleportation

A movement device that is becoming more prevalent in VR is teleportation. If you've got some sort of motion-controls (such as the Vive controllers) in typical VR this is quite easy to achieve. In Google Cardboard WebVR experiences you'll need to rely on retical-based movement.

The user is projects a circle or marker to where they want to move to, and then they are teleported there.

In my day 12 hack -- [AAAAH! Zombies](https://cardboctober.github.io/max/12/) -- I used retical-based teleportation. I actually stole this from [Pete's earlier day 11 hack: Blink](https://cardboctober.github.io/pete/11/).

{% include figure.html src="2016-10/18/blink.png" %}{:.massive.center}

### Voice control

I played around with this in [day 09's hack: Speech Recognition](https://cardboctober.github.io/max/09/) to move a ball around, but it could easily be adapted to moving the user around. Simple commands such as "move forward 10" or "move left 5", much like the old Television series "Knightmare" where the team command their blind team-mate around with commands

{% include figure.html src="2016-10/18/knightmare.jpg" %}{:.massive.center}

### Gesture-based

Something I've been thinking about (but have yet to execute) is gesture-based movement. This would be something like listening for a motion pattern (such as nodding your head) and acting based on that.

You could more simply make the user move in the direction they're looking when the screen is touched for a period of time.

Recently I played an Android game ([Gravity Pull](https://play.google.com/store/apps/details?id=com.VRMersive.GravityDrop)) that used a method of movement called "VR-Step". VR-Step uses "Inertial sensing" to allow you to move in the direction you're looking. You can see how it works here:

{% assign iframe_url = "https://www.youtube.com/embed/NYD8ZG3W31k" %}
{% include iframe_embed.html %}


See also:

- [Don't just teleport - How to walk around something that is bigger than your tracked space](https://www.youtube.com/watch?v=At_Zac4Xezw)
- [Travelling Without Moving - Controlling Movement in Virtual Reality](https://www.youtube.com/watch?v=Zsg8L43k7QY)
