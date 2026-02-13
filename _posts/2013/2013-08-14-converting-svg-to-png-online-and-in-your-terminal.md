---
title: Converting SVG to PNG online and in your terminal
comments_issue: 96
tags: [guide]
archived_comments:
- author: "Richardrtg"
  date: January 22, 2014
  content: |
    Also ksvgtopng in Ubuntu package kde-runtime
- author: "Scotty"
  date: November 13, 2014
  content: |
    thank you. Totally awesome.....the grump icon that is :-)
- author: "norm_c"
  date: December 09, 2014
  content: |
    Don't follow the instructions for the librsvg install - I did it without thinking about the commands and what happened was it upgraded a bunch of my tools! Now I have to go through a few hours of testing and upgrading other tools just to get my development environment back up. And to top it off, brew was not able to install the lbrsvg tool due to dependencies that it could not install.Yup, it's my fault I should not have blindly followed the above directions, hopefully this post will keep someone else from making the same mistake.
- author: "Max Glenister"
  date: December 09, 2014
  content: |
    I suppose you should say "Don't blindly follow the instructions" then -- for most people updating and upgrading brew is a good first step, and if it's not they would know otherwise.
---
This post is mostly for my own benefit on the rare occasion that I have to convert SVG files to PNG.

I always spend a large amount of time looking for an online SVG to PNG converter or a terminal one-liner to do this.

<!-- more -->

{% include posts/figure.html src="by%20default%202013-08-14%20at%2015.40.29.png" %}{:.massive.center}

### SVG icon resources:

- The Noun Project - [http://thenounproject.com/](http://thenounproject.com/)
- Iconmonstr (PNG available too!) - [http://iconmonstr.com/](http://iconmonstr.com/)
- Game icons - [http://game-icons.net/](http://game-icons.net/)

### Online services to convert SVG to PNG that aren't totally rubbish:

- Surprisingly not another Windows shareware site - [http://image.online-convert.com/convert-to-png](http://image.online-convert.com/convert-to-png)
- Very simple, lets you specify output dimensions - [http://www.fileformat.info/convert/image/svg2raster.htm](http://www.fileformat.info/convert/image/svg2raster.htm)


### Convert SVG to PNG using your terminal (Mac, Linux):
- Using librsvg (and rsvg-convert tool) - [http://webadventures.at/2012/04/29/convert-svg-png/](http://webadventures.at/2012/04/29/convert-svg-png/)

First install `librsvg` using `brew`:

```bash
$ brew update && brew upgrade
$ brew install librsvg
$ ln -s /usr/local/bin/rsvg-convert /usr/local/bin/rsvg
```

Then, you can either using rsvg directly, or make a function like the following:

```bash
# svg2png [file] [width] [height]
function svg2png {
    file=$1
    file_name="${file%.*}"
    file_ext="${file##*.}"
    shift
    width=${1:-"128"}
    height=${2:-"128"}

    if [ "${file_ext}" != "svg" ]; then
        printf "\n${file} is not an svg!\n"
    else
        rsvg -w $width -h $height "${file}" -o "${file_name}.png"
    fi
}
```
- Using CairoSVG and Python - [http://cairosvg.org/](http://cairosvg.org/)
- Using svg2png and PhantomJS/Node.js - [https://npmjs.org/package/svg2png](https://npmjs.org/package/svg2png)


If you found this useful let me know, I for one am glad that I've got this information in one place now.
