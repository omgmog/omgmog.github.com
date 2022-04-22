---
title: Creating an icon font
comments_issue: 43
tags: [guide]
---

I've recently been doing a lot of working designing an icon font that works well at small sizes for my day job. Here's an overview of the process I'm using to go from a doodle on paper, to a functional icon font that can be used in most web browsers.

<!-- more -->

{% include posts/figure.html src="Screen-Shot-2015-07-30-at-14.27.05.png" %}{:.massive.center}

## Process

1. List needed icons
2. List synonyms of each needed icon
3. Draw simplest/recognisable visual representation of that icon
4. Draw the icon in Sketch
5. Export SVG
6. Generate the icon font
7. Use the icon font


## List needed icons

If you're creating a complete set of icons from scratch, a good starting point is knowing which icons you need to create. For this process I go through the wireframes/IA plans of the site I'm creating the icons for and start to make a list of anything that will have an icon associated with it.

For example you might have the following:

1. Home
2. Profile
3. Log in
4. Log out
5. Settings
6. Contact

## List synonyms of each needed icon

Sometimes the words that we use to label things isn't great. When thinking about how you would represent something as an icon, it's very easy to find yourself at a loss because you can't think of an icon to represent the words. Take this for example:

> Manage settings & account

There are a couple of things going on there that you could focus on:

- "Manage" -- which might be represented as a cog or a spanner
- "Settings" -- again probably a cog, or a checklist, or a switch
- "Account" -- a silhouette of a user.

Being able to distill this to it's core functionality and from there find synonyms for the core word is a very important step. In this case, we can assume this is a "Settings" function at it's core, and so a cog would work pretty nicely for this. But let's list more synonyms:

- Settings
- Preferences
- Options
- Manage

From here you could then look at existing icons for inspiration, by going to [The Noun Project](https://thenounproject.com/) or [Icon Monstr](http://iconmonstr.com/) and searching with your synonyms list.

## Draw simplest/recognisable visual representation of that icon

Distilling the core functionality of an action in to an icon isn't easy. As you might have seen in the previous step, there are plenty of ways to represent even something as straight-forward as "Settings".

The process I use is to draw a recognisable form of the image I'm going to use for my icon, and then try to take as much detail away as possible. If you're drawing this icon at a large size, you need to consider how the small details will work (or not!) when the icon is shown at the smallest size possible.

## Draw the icon in Sketch

I'm using [Sketch](http://bohemiancoding.com/sketch/) to draw my icons, but you could use other software (e.g [Illustrator](http://www.adobe.com/products/illustrator.html), or [Inkscape](https://inkscape.org/en/)). The important thing is that you're creating vector paths, not raster/bitmap.

With Sketch I create a document containing a number of "Artboards" for each icon, this allows me to organise the various paths that make up each icon, and makes the process of exporting all of the icons at once very straight forward.

{% include posts/figure.html src="Screen Shot 2015-07-30 at 13.20.48.png" %}{:.massive.center}

I'm not going to explain how to draw your icons, but you can find a pretty good tutorials for using Sketch here: [http://www.sketchappsources.com/tutorials-tips.html](http://www.sketchappsources.com/tutorials-tips.html)

It's worth noting that, for the sake of an icon font you will need to draw everything in monochrome. So no crazy path styles, or border effects.

## Export SVG

With each of your icons drawn in sketch, you have a couple of options for easily exporting them:

1. Use slices to create slice regions for each icon in your .sketch file, and then export all of these as SVG
2. Use artboards and export all of these as SVG

Here's a pretty good overview of how to use Sketch's "Export" feature: [http://webdesign.tutsplus.com/tutorials/understanding-sketchs-export-options--cms-22207](http://webdesign.tutsplus.com/tutorials/understanding-sketchs-export-options--cms-22207)

## Generate the icon font

Now that you've got a folder full of SVGs of all of your icons, you can generate an icon font. For this I use [Icomoon](https://icomoon.io/app/).

Icomoon allows you to upload your SVG files and then assign them to unicode characters. It will then generate ttf/woff/svg/eot fonts and some accompanying CSS to get you started with using them in your website.

{% include posts/figure.html src="Screen Shot 2015-07-30 at 14.21.12.png" %}{:.massive.center}

There are other tools out there for generating icon fonts, such as [Fontastic](http://fontastic.me/), [Glyphter](https://glyphter.com/) and [Fontello](http://fontello.com/), and they all pretty much have the same functionality.

If you're interested in the "Bullet Journal Icons" I've shown in this post, check them out on Github: [Bullet Journalling Icons](https://github.com/omgmog/bullet-journal-icons).
