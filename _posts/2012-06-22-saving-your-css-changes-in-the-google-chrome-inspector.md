---
layout: post
title: "Saving your CSS changes in the Google Chrome inspector"
description: ""
large_cover: http://f.cl.ly/items/2V2M0G3y1b2D0G3x2B1S/inspector.png
tags: ["chrome", "css", "software"]
---
{% include JB/setup %}

In the process of rapid prototyping and trying out new CSS styles I often find myself making changes to styles within the inspector in Google Chrome. This works quite well, but I've always had a process like the following

* Try some CSS changes in the inspector
* Copy the new CSS styles (or even type them!) in to my local stylesheet
* Refresh the page, or open the page in a new tab and compare the CSS styles
* Repeat until correct

Today I realised that the inspector in Google Chrome saves states of your CSS edits as you make them, so you can revert to an earlier state, and even export the modified stylesheet from a given state.

It turns out this has been available in Webkit for nearly 18 months! You can read some more information about it over on [Surfin' Safari](http://www.webkit.org/blog/1463/web-inspector-styles-enhanced/) or check out my primer below.

## A quick primer on how to export CSS changes from the inspector

* Make your changes

![](http://f.cl.ly/items/2f0N2Q1L0q3S35040p3q/by%20default%202012-06-22%20at%2010.16.54.png)

* Click the 'Resources' tab

![](http://f.cl.ly/items/120W0h0M1W091d3Y1D3r/by%20default%202012-06-22%20at%2010.17.34.png)

* Find the CSS file that you made changes to (notice it now has some children)

![](http://f.cl.ly/items/41280W2d1p020q1q440g/by%20default%202012-06-22%20at%2010.18.24.png)

* Select the state of the CSS that you want to export (you can scroll through and see the hilighted changes, much like a diff)

![](http://f.cl.ly/items/3j3e2T2n361m0g262p36/by%20default%202012-06-22%20at%2010.19.11.png)

* Export your CSS file

![](http://f.cl.ly/items/2B2I1y3Z2j0o3W0E0W1a/by%20default%202012-06-22%20at%2010.19.42.png)