---
layout: post
title: "jQuery UK 2013 - A tale of beer, colourful cakes and no wifi"
description: ""
categories: []
---

_Now updated with videos!_

Yesterday I attended the second jQuery conference in the UK (the first being last year, which I blogged about [here](/post/jquery-uk-conference-2012/)).

I failed to get any nice pictures at the event myself, so this blog post uses a collection of crowd-sourced pictures from attendees that shared them via Twitter, Instagram and Flickr.

<!-- more -->

## The venue
This year the conference took place at the [King's Centre in Osney Mead](http://www.kingscentre.co.uk/) - a larger venue to cater for there being twice as many attendees as last year.

The new venue was just a hop and skip away from the Oxford rail station and the Siad business school (the venue from the previous jQuery conference).

Getting to the venue was easy, as (besides the fact that I've lived in Oxford my whole life) the route from the rail station to the venue was dotted with white rabbit feet painted on the ground.

## The theme
Last year the conference was Oxford themed, with a Radiohead inspired drawing featuring as the main artwork and t-shirt design.

<img src="http://uk.omg.li/OS4T/jquk2012.jpg" alt="jquk 2012" />

This year the theme was Alice's Adventures in Wonderland.

<figure>
<img src="http://uk.omg.li/ORgb/jabberwocky.jpg" alt="Beware the Jabberwocky!" />
<figcaption>
&copy; <a href="http://twitter.com/bseymour" target="_blank">Ben Seymour</a>: <a href="http://www.flickr.com/photos/boseymour/8663063817/" target="_blank">Original</a>
</figcaption>
</figure>

The route to the venue had the occasional white rabbit feet, and the venue had a massive Jabberwocky front and centre.

<figure>
<img src="http://uk.omg.li/OSC7/whiterabbit.jpg" alt="Follow the white rabbit" />
<figcaption>
&copy; <a href="https://twitter.com/elliott_stocks" target="_blank">Elliott Stocks</a>:
<a href="https://twitter.com/elliott_stocks/status/325150484967075840" target="_blank">Original</a>
</figcaption>
</figure>

<figure>
<img src="http://uk.omg.li/ORvM/megawocky.jpg" alt="Beware!" />
<figcaption>
&copy; <a href="https://twitter.com/4foot30" target="_blank">Gareth Jones</a>:
<a href="https://twitter.com/4foot30/status/325872540184625153/" target="_blank">Original</a>
</figcaption>
</figure>

The t-shirt for this years conference has the same Jabberwocky on the front.

<figure>
<img src="http://uk.omg.li/ORVk/t-shirt.jpg" alt="`Twas brillig, and the slithy toves Did gyre and gimble in the wabe: All mimsy were the borogoves, And the mome raths outgrabe." />
<figcaption>
&copy; <a href="https://twitter.com/MarianaMota" target="_blank">Mariana Mota</a>:
<a href="http://instagram.com/p/YSGRYPDROi/" target="_blank">Original</a>
</figcaption>
</figure>

The artwork was created by <a href="http://www.sophieklevenow.com/" target="_blank">Sophie Klevenow</a> who also did the artwork last year.

## Arrival
I arrived at the venue a little earlier than planned, but the White October staff were on hand to point me in the right direction to collect my pass and delegate bag, and then to collect my t-shirt. The passes this year resemble a deck of cards.

<figure>
    <img src="http://uk.omg.li/ORBR/pass.jpg" alt="A deck of cards for a pass" />
</figure>

The delegate bag wasn't spectacular this year, it contained the following:
- a "jQuery conference" sticker
- a "Football Radar" pen
- a football stress ball
- various leaflets/flyers (about jbeery, the lightning talks, etc.)

I was a bit disappointed to find that there were no free mugs this year, given how much demand there was for the Coffeescript mugs of last years conference (even after the conference).

There were a bunch of sponsor stands around the main hall, and they all had stickers, t-shirts, leaflets and things to give out.

At 9:30 we all headed through to the main room to start the conference. The room was massive, but suitably sized for the number of attendants.

Unfortunately I only managed to grab a seat towards the back of the room, and for the most part my view of the two projectors was either obscured by a pillar, or too far away to be able to read easily. Other than that the sound was very good.

## Morning - part 1
### <a href="https://twitter.com/johnwards" target="_blank">John Wards </a> - Hello!

John Wards from White October introduced the conference.

Besides welcoming everybody, he was apologetic about the lack of wifi at the venue, and he explained how he had tried (but failed) to sort out a connection.

We've been assured that next year there will be wifi!

### <a href="https://twitter.com/BrendanEich" target="_blank">Brenden Eich </a> - JavaScript the future

<img class="speaker" src="http://uk.omg.li/OSQ2/brendan.jpg" />

<div class="video-wrapper hd">
    <iframe src="http://player.vimeo.com/video/66711027?color=333333" width="500" height="281" frameborder="0"> </iframe>
</div>

Brenden talked about up and coming features of ECMAScript 6 and 7, and how a lot of commonly used JavaScript code patterns are going to be making their way into the spec as features of JavaScript.

He talked about some exciting things that JavaScript is being used for, such as the creation of AAA games.

He showed a live demo of the Unreal Engine 3 that was recently ported to JavaScript using Web GL and [asm.js](http://asmjs.org/).

He talked about not wanting to go in the direction of Java with bytecode, as it's slow and the JavaScript parser is more efficient. The main goal is for "One JavaScript for humans and computers".

Also: Firefox OS phones will be out soon!

### <a href="https://twitter.com/rworth" target="_blank">Richard D. Worth </a> - jQuery 1.9 and 2.0 - Present and Future

<img class="speaker" src="http://uk.omg.li/OR7p/richard.jpg" />

Richard talked about the core features of jQuery, the reasons that they don't bloat the core codebase with feature requests (read: they've got a plugin system dontcha' know?), and the plans for jQuery 2.0 which was just released.

He provided some interesting statistics:
- Around 50% of all sites use jQuery.
- 91\.2% of all sites that use JavaScript use jQuery.

The conclusion of those statistics was that 9/10 front-end developers use jQuery.. which isn't bad given the selection of JavaScript libraries out there that do a similar job.

He gave some features of jQuery 2.0, and some promises:

#### Features
- Jquery 2.0 will drop support for IE 6, 7, 8.
- The codebase will be 12% smaller because of that
- It's perfect for working with new/modern environments, such as mobile.
- It's modular. You can enable/disable core features easily to make your jQuery library even smaller.

#### Promises
- The 1.x branch of jQuery will continue to be supported
- jQuery 2.0 and 1.10 onwards will support the same API, so you could conditionally load 1.x for older IEs, and 2.x for everyone else and have no issues.

Besides all of that, he invited (implored, encouraged) everybody to take part in the jQuery community more, by becoming embassadors to the jQuery foundation/etc.

- [Click here to view the slides](http://www.slideshare.net/rworth/j-query2-19610459)

## Break - retro games!
During the first break, the retro games consoles from <a href="http://www.replayevents.com/index.shtml" target="_blank">REPLAY</a> were turned on. There was a circle of chairs set up with 4 TVs and 4 consoles in the middle, and there was an additional 5th TV with an n64 close by.

<figure>
<img src="http://uk.omg.li/ORkT/games.jpg" alt="Geeks and games" />
<figcaption>
&copy; <a href="http://twitter.com/imunro" target="_blank">Ian Munro</a>:
<a href="https://twitter.com/imunro/status/325234919066464256" target="_blank">Original</a>
</figcaption>
</figure>

People were playing Mario Kart 64, Goldeneye 64, Bomberman (SNES), Smash Bros (GC) and many other games. I had a few rounds of Goldeneye and decided ultimately that I've not improved at the game in the past 15 years.

## Morning - part 2
### <a href="https://twitter.com/rem" target="_blank">Remy Sharp </a> - So you know jQuery. Now what?

<img class="speaker" src="http://uk.omg.li/ORV0/remy.jpg" />

<div class="video-wrapper hd">
    <iframe src="http://player.vimeo.com/video/68009123?color=333333" width="500" height="281" frameborder="0"> </iframe>
</div>

Remy Sharp gave an interesting/controversial talk about only using jQuery when it's totally necessary, and sticking to pure JavaScript if you can.

He demonstrated some great examples of how to achieve some of the core functionality of jQuery with simple JavaScript snippets.

That sounds quite obvious, but there was a noticable eureka across the crowd when he pointed out that for a quick JavaScript prototype you don't need to throw the whole jQuery library in to select DOM elements when you can just use `querySelectorAll()`, and even map it to `$` to soften the blow.

- [Blog post which is basically the same as his talk](http://remysharp.com/2013/04/19/i-know-jquery-now-what/)
- [Click here to view the slides](https://speakerdeck.com/rem/i-know-jquery-now-what)

### <a href="https://twitter.com/ajpiano" target="_blank">Adam J. Sontag </a> - jQuery is a Swiss Army knife (and that's OK!)

<img class="speaker" src="http://uk.omg.li/ORlK/adam.jpg" />

Placing Adam Sontag immediately after Remy was quite interesting, as his talk held a complete opposite perspective.

He talked about the good reasons to use jQuery, such as obscuring away complicated cross-platform quirks in JavaScript.

He talked about jQuery just being a tool (or a multitool, pen-knife, etc.). You could use it to help with parts of building your website, but it can't do everything.

He also covered the dangers of using jQuery, or rather using it incorrectly, and provided some nice tips on how to use jQuery correctly with examples.

- [Click here to view the slides](http://ajpiano.com/jquery-is-a-swiss-army-knife/)

### <a href="https://twitter.com/dougneiner" target="_blank">Doug Neiner </a> - Taking Control with Machina.js

<img class="speaker" src="http://uk.omg.li/OSIO/doug.jpg" />

<div class="video-wrapper hd">
    <iframe src="http://player.vimeo.com/video/67473899?color=333333" width="500" height="281" frameborder="0"> </iframe>
</div>

Doug's talk mostly focussed around plugging <a href="https://github.com/ifandelse/machina.js" target="_blank">machina.js</a>, but I was too hungry to take extensive notes on the talk.

The gist of it is that machina.js is a Finite State Machine - "What's a Finite State Machine?" you ask? Ah well.. according to <a href="http://freshbrewedcode.com/jimcowart/2012/03/12/machina-js-finite-state-machines-in-javascript/" target="_blank">Jim Cowart</a>:

> A finite state machine is an architectural model which can exist in only one of a finite number of states at a given time – and thus it responds differently to the same input depending on the state in which it is currently in.

Doug had a nice demo with a light that changed colour to indicate the state of the network connection.

- [Click here to view the slides](http://code.dougneiner.com/presentations/machina/)

## Lunch
This month White October are celebrating their 10th birthday. To celebrate they had a big green cake with blinking LEDs and icing circuitry. They also had a whole load of tasty cupcakes.

<figure>
<img src="http://uk.omg.li/OSMC/wocake.jpg" alt="The cake is not a lie!" />
<figcaption>
&copy; <a href="http://twitter.com/whiteoctober" target="_blank">White October</a>:
<a href="https://twitter.com/WhiteOctober/status/325187539998748673" target="_blank">Original</a>
</figcaption>
</figure>

As the conference had an Alice's Adventures in Wonderland theme, it would have been nice if there were "Eat me" labels on the cupcakes!

### Lightning talks

During the lunch break there were lightning talks going on in the main conference hall. I was occupied with Mario Kart 64 so didn't catch any of them, but the line up was as follows:

- Thomas Parisot - The Promise of jQuery Deferred

  * **slides**: [http://www.slideshare.net/oncletom/the-promise-of-j-query-deferred](http://www.slideshare.net/oncletom/the-promise-of-j-query-deferred)
  * **twitter**: [@oncletom](https://twitter.com/oncletom)
  * **website**: [http://cyneticmonkey.com/](http://cyneticmonkey.com/)

- Ben Foxall - Sharing data between browser windows

  * **slides**: [http://benjaminbenben.com/win-win.pdf](http://benjaminbenben.com/win-win.pdf)
  * **twitter**: [@benjaminbenben](https://twitter.com/benjaminbenben)
  * **website**: [http://benjaminbenben.com/](http://benjaminbenben.com/)

- Ashley Nolan - Responsive design interaction patterns

  * **twitter**: [@dragongraphics](https://twitter.com/dragongraphics)
  * **website**: [http://www.dragongraphics.co.uk/](http://www.dragongraphics.co.uk/)

- Ray Bellis - Wrapping up IndexedDB in a promise based interface as a jQuery plugin

  * **twitter**: [@raybellis](https://twitter.com/raybellis)

- James Turner - How to build enterprise-scale web apps


## Afternoon - part 1
### <a href="https://twitter.com/garannm" target="_blank">Garann Means </a> - How to use events to glue full-stack frameworks together

<img class="speaker" src="http://uk.omg.li/ORhl/garann.jpg" />

Garann talked about using events and jQuery to glue your templates and front-end stuff to your models/controllers.

- [Click here to view the slides](http://garann.com/slides/fullstack-events/#/)

### <a href="https://twitter.com/igrigorik" target="_blank">Ilya Grigorik </a> - Wait, Chrome DevTools can do THAT?

<img class="speaker" src="http://uk.omg.li/OSS2/ilya.jpg" />

<div class="video-wrapper hd">
    <iframe src="http://player.vimeo.com/video/67330007?color=333333" width="500" height="281" frameborder="0"> </iframe>
</div>

Ilya's talk was much like Paul Irish's last year, in that it was more about Chrome than about jQuery, but that doesn't mean it wasn't good. He covered the following things:

- Remote debugging capabilities (debug your mobile apps on your desktop)
- Powerful JavaScript debugger and profiler
- CPU, memory, CSS layout and GPU profilers
- Built-in network monitoring tools: monitor at socket level
- SourceMaps, pretty print, revision control and autosave
- Data export and import: HAR, timeline, snapshots
- Custom extensions, customisable stylesheets, and much more...

He demonstrated how far the remote debugging for Chrome on Android has come along, and some neat ways to use the developer tools.

- [Click here to view the slides](https://docs.google.com/presentation/d/1DNljLkRpe9LIDfcqcpHzdLvEOyuVH4d1y9dtAJBr1I8/preview#slide=id.p19)

## Break - mad as a hatter

<figure>
<img src="http://uk.omg.li/ORtP/teaparty.jpg" alt="Delicious jam tarts!" />
<figcaption>
&copy; <a href="http://twitter.com/bseymour" target="_blank">Ben Seymour</a>:
<a href="http://www.flickr.com/photos/boseymour/8663064455/in/set-72157633280442945/" target="_blank">Original</a>
</figcaption>
</figure>

## Afternoon - part 2
### <a href="https://twitter.com/johnbender" target="_blank">John Bender</a> - Faster DOM manipulation with category theory and wield

<img class="speaker" src="http://uk.omg.li/OQsa/john.jpg" />

John's talk was focussed on optimising your use of jQuery by using category theory to group methods.

It started with a category theory primer to get everybody up to scratch, and then he had some examples of how this can apply to jQuery.

Lastly he went on to talk about Weild, `a tiny object wrapper around the DOM`. You can read more about Weild over at its [GitHub project page](https://github.com/johnbender/wield)

- [Read his related blog post here](http://johnbender.us/2012/02/09/faster-javascript-through-category-theory/)
- [Click here to view the slides](http://johnbender.us/presentation-faster-js/#/)

### <a href="https://twitter.com/Joe8Bit" target="_blank">Joe Pettersson</a> - Complex clientside apps and legacy browsers (a story of frustration...)

<img class="speaker" src="http://uk.omg.li/ORzu/joe.jpg" />

Joe's talk was about testing across multiple browsers, and how to make the task of doing so a lot less painful. He covered manual testing using virtual machines and some CI testing using using software such as [JENKINS](http://jenkins-ci.org/) and [Selenium](http://docs.seleniumhq.org/).

The only bad thing I've got to say about Joe's talk is that he had a heavy emphasis on testing versions of Internet Explorer, but nothing around testing legacy versions of Firefox or particular quirky WebKit versions.

- [Click here to view the slides](https://speakerdeck.com/joepettersson/building-for-legacy-browsers-jquery-uk-2013)

### <a href="https://twitter.com/JsonScott" target="_blank">Jason Scott</a> - Build an experience... not another framework

<img class="speaker" src="http://uk.omg.li/OS1o/jason.jpg" />

<div class="video-wrapper hd">
    <iframe src="http://player.vimeo.com/video/67473673?color=333333" width="500" height="281" frameborder="0"> </iframe>
</div>

Jason, as jQuery Mobile team member and developer at BlackBerry was here to talk about how he put together a [BlackBerry UI theme for jQuery Mobile](https://github.com/jasondscott/jQueryMobile-BB10-Theme), and the UX considerations that make pages using the theme feel like native apps.

- [Click here to view the slides](https://docs.google.com/presentation/d/19xrnU6cpyvOus0CYUnb7W7uxz_hl6Dqw-6BOxsVMn2s/edit#slide=id.p20)

## jBeery
John Wards wanted to host a beer festival this year, so he did.

There were 7 beers to have, each from either the [Compass brewery](http://compassbrewery.com/) or [Oxfordshire Ales brewery](http://www.oxfordshireales.com/).
- **Compass**: Isis Pale (sponsored by BlackBerry)
- **Oxfordshire Ales**: Blenheim (sponsored by Booking.com)
- **Oxfordshire Ales**: Triple 'B' (sponsored by Cloudant)
- **Oxfordshire Ales**: Pride of Oxford (sponsored by Ignite UI)
- **Oxfordshire Ales**: Churchill HPA (sponsored by Kendo UI)
- **Oxfordshire Ales**: Marshmellow (sponsored by White October)
- **Compass**: The King's Shipment (sponsored by White October)

<figure>
<img src="http://uk.omg.li/OSUP/jbeery.jpg" alt="Drink me!" />
<figcaption>
&copy; <a href="http://twitter.com/beckyjtweets" target="_blank">Becky Jennings</a>:
<a href="http://instagram.com/p/YSgYIew29f/" target="_blank">Original</a>
</figcaption>
</figure>

## Interesting links/things/take-aways from the conference
- [Machina.js]()
- Themes for the Chrome Devtools - [devthemez.com](http://devthemez.com)
- Using audits in the Chrome DevTools - [Video here](http://www.youtube.com/watch?v=Qsv6NjnWFLI)
- Pagespeed Insights by Google - [Download the extension here](https://chrome.google.com/webstore/detail/pagespeed-insights-by-goo/gplegfbjlmmehdoakndmohflojccocli?hl=en)
- The Breakpoint Show - [See episode one here](http://addyosmani.com/blog/the-breakpoint-episode1/)
- Wield - [See the repository here](https://github.com/johnbender/wield)
- Selenium for automatic browser testing - [Selenium website](http://docs.seleniumhq.org/)
- BlackBerry/Apache Ripple - [View the project page here](http://ripple.incubator.apache.org/)
