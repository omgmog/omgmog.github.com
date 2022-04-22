---
title: "30: Github Contributions"
has_hack: true
---

For today's Cardboctober, having shed the burden of creating Tetris in VR, I decided to hack around with data visualisation.

<!-- more -->

Have you ever noticed the cool "contribution graph" on your Github profile? I've been completely aware of mine for the past month as I ensure that I'm posting daily for Cardboctober.

{% include posts/figure.html src="2016-10/30/contributions.png" %}{:.massive}

You can directly access a users contribution timeline from the following URL, that'll provide you an SVG image in response:

```
https://github.com/users/{user}/contributions
```

So this had my curiosity, if Github have this _API_ that generates an SVG, do they provide a traditional JSON endpoint in their `users` API to do the same thing?

Sadly not. At least, not from just one of the endpoints. You'd have to get a user, go through their activity count up the totals by date, and collate it in to this 2-dimensional representation.

The SVG has all of the data we need really, looking at the source of the SVG we have the following (simplified example):

```xml
<svg>
  <g>
    <g>
      <rect x="13" y="0" data-count="0" data-date="2015-10-25"/>
      <rect x="13" y="12" data-count="0" data-date="2015-10-26"/>
      <rect x="13" y="24" data-count="0" data-date="2015-10-27"/>
      <rect x="13" y="36" data-count="26" data-date="2015-10-28"/>
      <rect x="13" y="48" data-count="15" data-date="2015-10-29"/>
      <rect x="13" y="60" data-count="13" data-date="2015-10-30"/>
      <rect x="13" y="72" data-count="0" data-date="2015-10-31"/>
    </g>
    <g>
      <rect x="12" y="0" data-count="0" data-date="2015-11-01"/>
      <rect x="12" y="12" data-count="15" data-date="2015-11-02"/>
      <rect x="12" y="24" data-count="0" data-date="2015-11-03"/>
      <rect x="12" y="36" data-count="0" data-date="2015-11-04"/>
      <rect x="12" y="48" data-count="0" data-date="2015-11-05"/>
      <rect x="12" y="60" data-count="15" data-date="2015-11-06"/>
      <rect x="12" y="72" data-count="3" data-date="2015-11-07"/>
    </g>
    // and so on...
  </g>
</svg>
```

Which is a structure of the commit activity, per day, per week, for the previous year.

So I decided to try and turn this in to something in VR with Three.js.

### First hurdle

The SVG is served with a strict `Content-Security-Policy` header that limits the places it can be embedded, so we can't just load this in our demo. Thankfully, there are solutions to this problem around, such as using a proxy that strips the CORS header.

I'm using [urlreq](https://github.com/izuzak/urlreq) which is conveniently hosted on `appspot.com` and can be used like this:

```javascript
var original_url = 'https://github.com/users/omgmog/contributions';
var proxy_url = 'https://urlreq.appspot.com/req?method=GET&url=';
var url = proxy_url + original_url;
```

So now we can embed the SVG, or rather we can now access it using AJAX and do something with the SVG data that we get in the response:

```javascript
var request = new XMLHttpRequest();
request.open('GET', url, true);
request.onload = function() {
  // do something
  console.log(this.responseText); // SVG data!
};
request.send();

```

So what can we do? Well SVG is just XML, which is a pain to work with on it's own, so I'm using a function from [David Walsh's blog](https://davidwalsh.name/convert-xml-json) that converts XML to JSON.

With this function, I can create a JSON object that represents the data in the SVG and do anything I want with the data...

```javascript
request.onload = function () {
  // first parse that responseText to XML
  var parser = new DOMParser();
  var xml = parser.parseFromString(this.responseText, "text/xml");

  // Then convert to a JSON object
  var jsonData = xmltoJson(xml);
};
request.send();
```

So to get this in to a VR scene, I'm looping over the weeks (columns) and days (rows) in the JSON data, generating a coloured Mesh for each item, and then rendering them in a ring around the camera position.

```javascript
var renderChart = function (data) { // data is the jsonData
  var cols = data.svg.g.g; // a small amount of traversal
  cols.forEach(function (col, c) {
    var rows = col.rect;

    rows.forEach(function (row, r) {
      if (row['data-count'] > 0) {
        // do something if we've contributed on this day
      }
    });
  });
};
```

So now we've gone from this:

{% include posts/figure.html src="2016-10/30/contributions.png" %}{:.massive}

To this:

{% include posts/figure.html src="2016-10/30/giphy.gif" %}{:.massive}

Very similar layout stuff to other days in Cardboctober, but now with some fancy Github Contributions data as the source.

If you're interested, you can see the full source here: [30/demo.js](https://github.com/cardboctober/max/blob/master/30/demo.js)
