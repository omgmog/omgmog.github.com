---
comments_issue: 17
title: 'SusHack #1: Building the foundations of the Oxford Flood Network Stack'
tags: [hackday]
---

This past weekend I held my first hack day. This is a recollection of why/how SusHack came to be, and how the day went.

<!-- more -->

### Preface

After the [Refresh Oxford](http://www.refreshoxford.co.uk/) hack day back in June I had a bee in my bonnet about doing something similar. I work 9-5:30 for [2degrees](http://2degreesnetwork.com) ("the sustainable business community") as a front-end developer, and so floated the idea with my colleague [Gil](http://lumbercoder.com/) who is also interested in hack days.

### Conception

{% include posts/figure.html src="Image%202013.11.05%2022_06_48.png" %}{:.massive.center}

As we're working in the area of sustainable business, it made sense to have a sustainability themed hack day, so "SusHack" was born towards the end of August. I spoke to the folks who organised Refresh to get some tips on organising the hack day, and then figured out what I needed. In short:

- Location
- Food/drink
- A theme (already have the sustainability edge)
- Some kind of incentive/prizes for people to work towards

2degrees sponsored SusHack by providing the location (the 2degrees offices on a Saturday), and covering the cost of food/drink for the day. We talked to our local Starbucks about getting a good deal on coffee, and they generously provided free coffee for everyone. We talked to GitHub about what they could provide as prizes, and they provided t-shirts/stickers and were very helpful about Git.

### The SusHack website

We built the website over the course of a couple of evenings (and some approved office time). It started out as a fork of the [Refresh Oxford Django application](https://github.com/refreshoxford/refreshoxford.co.uk/), but in the end it didn't fit our purpose, so we stripped it all the way back to a basic Django application and went from there. A little bit of magic to deploy it to a VPS from GitHub and we had a fully functioning website with a sign up form.

The complete SusHack site is available on GitHub so if you want to start your own hack day website you can fork it from here: [https://github.com/sushack/sushack_homepage](https://github.com/sushack/sushack_homepage)

### Getting some buzz for SusHack

Twitter was very valuable in promoting SusHack, and the community of Oxford Geeks, Clean Web UK, and sustainability/hack day enthusiasts did a great job of spreading the word about SusHack to their followers.

We used [Mailchimp](http://eepurl.com/Emv4j) to send out an email to everyone who had signed up with important information about the day. A simple campaign in Mailchimp can be set up in about 10 minutes, and the impact is a lot greater than sending a text-only email from a personal email account.

### The day arrives

SusHack came around a lot faster than I had anticipated. We were still securing things like coffee arrangements and the plan for the day up until 6pm on the Friday before. We arrived at 8:30am to set things up, and the first attendees starting showing up from about 9:15am.

### Getting into teams

To start with we recorded all of the submitted project ideas on a flipchart, and then let people add anything else that they wanted to work on. The folks from [Love Hz](http://love-hz.com/) added the Oxford Flood Network stuff, and they had a bunch of cool sensors and Raspberry Pi's to play with, so everybody ended up wanting to work with that stuff.

There were 14 attendees (11 of which were taking part in the hacking, 3 were helping with the running of the day and playing Minecraft!), and a lot of components to making the Oxford Flood Network stuff work, so we split in to teams based on parts of the stack:

- Sensor firmware to talk to the Raspberry Pi over `GPIO/LLAP`
- Pi firmware to communicate with the sensor service over `MQTT`
- Sensor service to store the sensor data and make it available to the "front-end" application with `CouchDB/JSON`
- Front-end application to handle processing of the sensor data, and present it using `Flask` along with a `Leaflet.js` powered Google Map in the browser.

We worked from about 11:00am until 7:00pm (with breaks for burritos and pizza) and by that point had the full stack up and running, and were able to demonstrate in real time that the sensor readings affected the front-end web application.

You can find the source code for the various components of the sensor stack at the following repositories on GitHub:

- Sensor to Pi: [https://github.com/sushack/sensor-firmware](https://github.com/sushack/sensor-firmware)
- Pi to database: [https://github.com/sushack/pi_sensor_mqtt](https://github.com/sushack/pi_sensor_mqtt)
- Database to API: [https://github.com/sushack/mqtt2couch](https://github.com/sushack/mqtt2couch)
- API to web application: [https://github.com/sushack/oxfloodnetweb](https://github.com/sushack/oxfloodnetweb)

### Closing thoughts, and next time...

The first SusHack was a great success. We didn't work on a bunch of small projects as I originally thought we would, but instead a group of people got together and, in the true spirit of sustainability, collaborated to make the idea of the Oxford Flood Network one step closer to being a reality.

It's amazing to think how much was achieved in one day. We were able to produce a working prototype of a full-stack application that combines sensors, low-level firmware, Raspberry Pi firmware, MQTT, CouchDB, Python and Javascript to present the readings of water levels in a useful way. As is to be expected from a single day's work, the code we produced is very pre-alpha and will likely stop working if the any part of the stack isn't in place as it was on the day, but it's a great start for something amazing.

I'm planning to start organising the next SusHack in the new year, and hoping to hold it in April, or there abouts.



