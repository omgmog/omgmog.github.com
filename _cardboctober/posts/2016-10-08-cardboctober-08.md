---
title: "08: Playing sounds"
has_hack: true
---

Kicking off Cardboctober week 2 (in which I'll be talking about using various Web APIs) today we're looking at audio. Or more specifically how to get audio in to your VR things.

<!-- more -->

{% include posts/figure.html src="2016-10/08/giphy.gif" %}{:.massive}

First we build a basic scene containing some "buttons" and "speakers". These are quite simple meshes, made with combinations of `BoxGeometry` and `CylinderGeometry`.

We create a mesh for a button and a speaker, and then clone them for each instance that you want to add to the scene.

You can find the relevant bit of code creating a speaker mesh here: [08/demo.js#L87-L149](https://github.com/cardboctober/max/blob/master/08/demo.js#L87-L149)

And for the button mesh here: [08/demo.js#L152-L172](https://github.com/cardboctober/max/blob/master/08/demo.js#L152-L172)

With these meshes created, create an array of objects that declare the various speaker/button combos that you want to add to the scene:

```javascript
var speakers = [];

speakers.push({
    "speaker": speaker.clone(),
    "speaker_pos": new T.Vector3(-40, 4, -20),
    "button": button.clone(),
    "button_pos": new T.Vector3(-16, -10, -10)
});

speakers.push({
    "speaker": speaker.clone(),
    "speaker_pos": new T.Vector3(-20, 4, -35),
    "button": button.clone(),
    "button_pos": new T.Vector3(-8, -10, -10)
});

// And so on for each speaker/button combo

```

After the speakers are declared, loop through the `speakers` array and create/position each speaker and button:

```javascript
speakers.forEach(function (s, i) {
    var spos = s.speaker_pos;
    var bpos = s.button_pos;

    s.speaker.position.x = spos.x;
    s.speaker.position.y = spos.y;
    s.speaker.position.z = spos.z;

    // Turn speaker to look at the camera
    s.speaker.lookAt(new T.Vector3(
      camera.position.x,
      2,
      camera.position.z
    ));


    if ('speaker_scale' in s) {
        var scale = s.speaker_scale;
        s.speaker.scale.set(scale[0], scale[1], scale[2]);
    }

    s.button.position.x = bpos.x;
    s.button.position.y = bpos.y;
    s.button.position.z = bpos.z;

    scene.add(s.speaker);
    scene.add(s.button);
});
```

To draw the wires connecting each button to it's speaker, we use the `THREE.Line` built-in which accepts an array of coordinate pairs that define where to draw the lines. This is done inside the `speakers` loop as above.

```javascript
// Draw lines from speakers to buttons
var material = new T.LineBasicMaterial({
    color: 0xaaaaaa,
    linewidth: 10
});

var geometry = new T.Geometry();
geometry.vertices.push(
    new T.Vector3( spos.x, spos.y, spos.z ),
    new T.Vector3( spos.x, -10, spos.z ),
    new T.Vector3( bpos.x, -20, bpos.z ),
    new T.Vector3( bpos.x, bpos.y, bpos.z )
);

var line = new T.Line( geometry, material );
scene.add( line );
```

By this point the scene is coming together, there are 5 speaker/button pairs with connecting wires, but they don't do anything yet. For this we're back to using `vreticle.js` as in [previous](/post/cardboctober-03) [posts](/post/cardboctober-06).

Inside the `speakers` loop again, add an `ongazelong` event function, and use `howler.js` to play a sound:

```javascript
// ...
s.button.children[1].ongazelong = function () {
  var sound = new Howl({
    src: 'jump.mp3'
  });
  sound.play();
};

//...
```

You'll notice I'm referring to `s.button.children[1]`, this is because `s.button` is actually targetting the parent `THREE.Object3D` rather than the `THREE.CylinderGeometry` button mesh itself.

{% include posts/figure.html src="2016-10/08/buttonstructure.png" %}{:.massive}

Alright, now we've got sound playing each time you `ongazelong` at a button. But it's not great! Howler comes with built-in support for spatial audio. We can tell it to spatially position the sound so that it sounds like it's coming from a speaker:

```javascript
s.button.children[1].ongazelong = function () {
  var sound = new Howl({
    src: 'jump.mp3'
  });

  // Use the x/y/z position of the speaker
  sound.pos(spos.x, spos.y, spos.z);

  sound.play();
};
```

Now, there are a few more nuances for making the button/sound interaction perfect, but it's a bit convoluted. You can take a look at [08/demo.js](https://github.com/cardboctober/max/blob/master/08/demo.js) to see the full example.
