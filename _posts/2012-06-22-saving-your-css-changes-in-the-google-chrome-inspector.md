---
layout: post
title: "Saving your CSS changes in the Google Chrome inspector"
tags: ["browser", "tip", "tutorial", "software", "development"]
updated: 2013-03-13
---
In the process of rapid prototyping and trying out new CSS styles I often find myself making changes to styles within the inspector in Google Chrome. This works quite well, but I've always had a process like the following:

<!-- more -->

- Try some CSS changes in the inspector
- Copy the new CSS styles (or even type them!) in to my local stylesheet
- Refresh the page, or open the page in a new tab and compare the CSS styles
- Repeat until correct

Today I realised that the inspector in Google Chrome saves states of your CSS edits as you make them, so you can revert to an earlier state, and even export the modified stylesheet from a given state.

It turns out this has been available in Webkit for nearly 18 months! You can read some more information about it over on [Surfin' Safari](http://www.webkit.org/blog/1463/web-inspector-styles-enhanced/) or check out my primer below.

## A quick primer on how to export CSS changes from the inspector

- Make your changes

  ![](http://f.cl.ly/items/0D2C471X3B0r1B0B3S34/by%20default%202014-03-14%20at%2016.06.11.png)

- Click the 'Sources' tab in the inspector
- Find the CSS file that you made changes to (notice it now has an asterisk next to it)

  ![](http://f.cl.ly/items/372i1L1H073N0q193K2Y/by%20default%202014-03-14%20at%2016.07.10.png)

- Right click in the file, and choose "Local modifications..."
  You can now see a list of the changes you've made

  ![](http://f.cl.ly/items/0A082F2x2A3a0M2c172o/by%20default%202014-03-14%20at%2016.08.06.png)

- Right click in the file again, and choose "Save as..."

  ![](http://f.cl.ly/items/0Y1h0O0X0f1i3s291H0V/by%20default%202014-03-14%20at%2016.08.42.png)
