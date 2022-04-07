---
title: "05: Loading external models"
has_hack: true
---

Using a couple of Three.js plugins you can load external models in to your scene. The plugins are:

- [OBJLoader.js](https://threejs.org/examples/js/loaders/OBJLoader.js)
- [MTLLoader.js](https://threejs.org/examples/js/loaders/MTLLoader.js)

OBJLoader lets you load `.obj` format models, and MTLLoader lets you load `.mtl` material definitions to apply textures to the models.

<!-- more -->

You can grab models from anywhere you like, or model them yourself in something like 3DS Max or Blender.

If you can't find the model you like as an `.obj` and `.mtl`, I've found that you can use an online service such as [http://www.greentoken.de/onlineconv/](http://www.greentoken.de/onlineconv/) to convert them.

## Adding models to your scene

First of all you need to load the OBJLoader and MTLLoader plugins

```html
<script src="OBJLoader.js"></script>
<script src="MTLLoader.js"></script>
```

And then for each model you'll need to create an instance of MTLLoader to preload the materials, create an instance of OBJLoader to load the model and then finally add them to your scene.

```javascript
var modelsToLoad = ['Stormtrooper', 'R2D2'];
modelsToLoad.forEach(function (model, i) {
    var mtlLoader = new THREE.MTLLoader();
    var objLoader = new THREE.OBJLoader();

    // Load the material, e.g. 'Stormtrooper.mtl'
    mtlLoader.load(model+'.mtl', function (materials) {
        materials.preload();
        objLoader.setMaterials(materials);

        // Load the object, e.g. 'Stormtrooper.obj'
        objLoader.load(model+'.obj', function (object) {
            // Object can be scaled, positioned, etc. like any mesh
            object.scale.set(.5, .5, .5);
            scene.add(object);
        });
    });
});
```

{% include posts/figure.html src="2016-10/05/giphy.gif" %}{:.massive}

## These aren't the droids you're looking for

Though loaded models are treated just like any other mesh, I've found that raycasting doesn't behave the same. For todays hack I wanted to have some logic for when you stare at a specific model but nothing was happening.

To get around this, I added the model as a child of an `Object3D` and then positioned a regular `BoxGeometry` mesh over that:

```javascript
    // ... mostly as before
    objLoader.load(model+'.obj', function (object) {
        var parent = new THREE.Object3D();
        object.scale.set(.5, .5, .5);
        parent.add(object);

        // Using my core.js helper for building things
        var cube = core.build(
            'BoxGeometry', [18, 30, 18],
            'MeshLambertMaterial', [{
                color: 0xffffff,
                // make it transparent
                transparent: true,
                opacity: 0
            }]
        );
        // you will want to position/scale the cube
        // before making it transparent

        // add the cube
        parent.add(cube);

        // add the Object3D to the scene
        scene.add(parent);
    });
```

{% include posts/figure.html src="2016-10/05/cubes.png" %}{:.massive}

Now I'm able to raycast the transparent cube rather than the model.

I'm using `vreticle.js` again to handle raycasting, and [Howler.js](https://howlerjs.com/) for loading/playing sounds.
