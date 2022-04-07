---
title: "17: Displaying Pertinent Information"
---

Some Cardboard experiences might require pertinent information to always be visible to the user. As we’re working with a stereoscopic and not particularly high resolution screen this raises a couple of challenges.

<!-- more -->

In my Cardboctober hack for Speech Recognition I had an indicator for the current microphone state at the bottom of the screen. This was important to show whether the microphone was off or on.

{% include posts/figure.html src="2016-10/17/1.png" %}{:.massive}

In the Speech Recognition hack I’ve created the indicator using a Mesh that’s added as a child of the camera object. This ensures that it’s drawn stereoscopically as with the rest of the scene. It looks something like this:

{% include posts/figure.html src="2016-10/17/2.png" %}{:.massive}

The benefit of creating the HUD as part of the scene rather than as a 2D overlay is that you don’t have to duplicate it for each side of the stereoscopic view.

The downside of doing it this way is that it’s a bit fiddly to sort out position/scale of your HUD elements, as it’s all relative to the camera in the scene, rather than to the viewport size. There’s also an issue of intersecting other objects in the scene when using the OrbitControls camera in Three.js because the camera is orbiting around a central point.

Another option would be attaching the hud to something else in the scene. If the user had a weapon for example, you could attach a counter for the remaining ammunition to the weapon.

Besides the HUD, there are also some challenges with displaying information within the game world. For example text on buttons needs to be clear, and the buttons need to be large enough that the raycasting reticle from both eyes can hit it without hitting other buttons that are too close.

{% include posts/figure.html src="2016-10/17/3.png" %}{:.massive}

In my Webaudio Beat Sequencer hack I’m displaying a lot of buttons (176 of them!) in a curved grid. The grid is curved to ensure that the size and distance from the camera remains consistent no matter which button you’re looking at.

This [article on unity3d](https://unity3d.com/learn/tutorials/topics/virtual-reality/user-interfaces-vr) talks about creating VR HUDs in Unity, but the general ideas can be applied to Google Cardboard.

This [article on Gamasutra](http://www.gamasutra.com/view/feature/4286/game_ui_discoveries_what_players_.php?print=1) talks about some approaches to game HUDs in games, and the various ways the games deal with integrating them into the aesthetic of the games.
