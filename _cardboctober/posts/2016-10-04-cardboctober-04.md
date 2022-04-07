---
title: "04: Skyboxes and generating meshes"
has_hack: true
---

## Skyboxes

There are a couple of ways you can create a skybox in Three.js

- Using a skydome (a textured sphere)
- Using a skybox (a textured cube)

I'm using the textured cube approach. For this approach, our skybox texture has to be broken up into six textures.

<!-- more -->

{% include posts/figure.html src="2016-10/04/skybox-images.png" %}{:.massive}

We then apply each of these to a face of the skybox:

```javascript
var materials = [
    createSkyMaterial('px.jpg'), // East
    createSkyMaterial('nx.jpg'), // West
    createSkyMaterial('py.jpg'), // Up
    createSkyMaterial('ny.jpg'), // Down
    createSkyMaterial('pz.jpg'), // North
    createSkyMaterial('nz.jpg')  // South
];

var mesh = new T.Mesh(
    new T.BoxGeometry( 512, 512, 512, 1, 1, 1 ),
    new T.MeshFaceMaterial( materials )
);

function createSkyMaterial( path ) {
    var texture = textureLoader.load(path);
    var material = new T.MeshBasicMaterial( {
        map: texture,
        overdraw: 0.5
    });

    return material;
}
```

{% include posts/figure.html src="2016-10/04/skybox-layout.png" %}{:.massive}

As we're going to be inside the skybox, we turn the skybox inside out by negatively scaling it on one of its axis:

```javascript
mesh.scale.set(-1,1,1);
scene.add( mesh );
```

{% include posts/figure.html src="2016-10/04/giphy-skybox.gif" %}{:.massive}

And then boom, we've got a skybox.

## Generating meshes

As a build-up to something I might be doing later this month, I decided to build some [Tetrominos](https://en.wikipedia.org/wiki/Tetromino).

First I define them as multi-dimensional arrays:

```javascript
var shapes = {
    L: {
        color: 15769600,
        layout: [ [ 0, 0, 0 ], [ 1, 0, 0 ], [ 1, 0, 0 ], [ 1, 1, 0 ] ]
    },
    J: {
        color: 240,
        layout: [ [ 0, 0, 0 ], [ 0, 1, 0 ], [ 0, 1, 0 ], [ 1, 1, 0 ] ]
    },
    S: {
        color: 61440,
        layout: [ [ 0, 0, 0 ], [ 0, 0, 0 ], [ 0, 1, 1 ], [ 1, 1, 0 ] ]
    },
    Z: {
        color: 15728640,
        layout: [ [ 0, 0, 0 ], [ 0, 0, 0 ], [ 1, 1, 0 ], [ 0, 1, 1 ] ]
    },
    O: {
        color: 15790080,
        layout: [ [ 0, 0 ], [ 0, 0 ], [ 1, 1 ], [ 1, 1 ] ]
    },
    T: {
        color: 10486e3,
        layout: [ [ 0, 0, 0 ], [ 0, 0, 0 ], [ 1, 1, 1 ], [ 0, 1, 0 ] ]
    },
    I: {
        color: 61680,
        layout: [ [ 1 ], [ 1 ], [ 1 ], [ 1 ] ]
    }
};
```

And then I parse the arrays and build some `Object3d`'s to hold the various arrangements of `BoxGeometry` meshes. For this I've created a function that looks up a shape and allows you to generate the mesh at a specific scale.

```javascript
var renderShape = function (type, scale) {
    var scale = scale || 2;
    var shape = shapes[type] || shapes[Object.keys(shapes)[0]];

    var shapeMesh = new T.Object3D();

    var layout = shape.layout;

    for (var r = 0; r<layout.length; r++) {
        for (var c = 0; c<layout[r].length; c++) {
          if (layout[r][c]>0) {
            var block = core.build(
                'BoxGeometry', [scale, scale, scale],
                'MeshLambertMaterial', [{
                    color: shape.color,
                    shading: T.FlatShading,
                    map: bumpTexture
                }]
            );
            block.position.x = c * scale;
            block.position.y = r * -(scale);
            shapeMesh.add(block);
          }
        }
    }
    shapeMesh.position.y = (5*scale) - (layout.length * scale);
    shapeMesh.position.x = (layout[0].length / 2) * -1;

    return shapeMesh;
}
```

After you've got your shape meshes generating, you can then do anything you like with them. For todays hack I arranged them in a circle around the camera.

{% include posts/figure.html src="2016-10/04/giphy.gif" %}{:.massive}
