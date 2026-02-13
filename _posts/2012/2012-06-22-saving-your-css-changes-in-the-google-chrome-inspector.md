---
comments_issue: 28
title: Saving your CSS changes in the Google Chrome inspector
tags: [chrome, css, guide]
archived: true
archived_comments:
- author: "Jim Hohl"
  date: November 05, 2012
  content: |
    Cool suggestion but I didn't see any children on my css file: http://prntscr.com/izf8u - all those files called "css" are Google Fonts included for testing and the other style.css seems to be coming from the inspector.
- author: "Max Glenister"
  date: December 11, 2012
  content: |
    It looks as if this has now been moved to the 'Sources' section of the Developer Tools, with a much more intuitive way to access local modifications - http://uk.omg.li/LVeE
- author: "Uri"
  date: February 15, 2013
  content: |
    Hey Max,Your right they did move it to the 'Sources' section but how do you save the revisions. I was only able to save using the contextual menu when clicking on the actual css file using save as... but when I open up the css it stills only shows original css and not any of the changes?
- author: "Andreas Linnert"
  date: May 07, 2013
  content: |
    I'm having the same problem here. The only way I found is to copy/paste every changed file... And currently I'm using Chrome 26
- author: "Max Glenister"
  date: May 31, 2013
  content: |
    Apologies for the delay replying, Disqus doesn't seem to notify me of the discussions...After you've made changes to your page styles, if you locate the stylesheet you've changed in the 'sources' tab, and right click on the filename or in the source code, you can hit 'save as'.This worked for me, and reflects the changed styles. Hope that helps!
- author: "Max Glenister"
  date: May 31, 2013
  content: |
    Hi Andreas, see my reply to Uri above -- apologies for the delay!
- author: "Nirav Mehta"
  date: March 04, 2014
  content: |
    The way I got this to work is to click on the CSS file name (appears above the name of class / element you are changing in the Styles tab inspector). This opens up the "changed" CSS. You can save it from here now.HTH.
- author: "Samuel Stroh"
  date: April 06, 2014
  content: |
    I just have to thank yo men, thankx a llot, that's why i love Internet, there's allways an answere to what im looking for and free :D
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

Make your changes

{% include posts/figure.html src="by%20default%202014-03-14%20at%2016.06.11.png" %}{:.massive.center}

Click the 'Sources' tab in the inspector

Find the CSS file that you made changes to (notice it now has an asterisk next to it)

{% include posts/figure.html src="by%20default%202014-03-14%20at%2016.07.10.png" %}{:.massive.center}

Right click in the file, and choose "Local modifications..."
  You can now see a list of the changes you've made

{% include posts/figure.html src="by%20default%202014-03-14%20at%2016.08.06.png" %}{:.massive.center}

Right click in the file again, and choose "Save as..."

{% include posts/figure.html src="by%20default%202014-03-14%20at%2016.08.42.png" %}{:.massive.center}
