---
comments_issue: 63
title: Meta post about making this blog responsive and not using px
---
If you're a returning visitor to _blomg_ you might notice some changes to the design.

<!-- more -->

The juicy technical details are:
- It contains __no jQuery__
- It doesn't use `px` for any of the units of size
- It only has JavaScript to highlight code snippets, and Google Analytics
- It's based around your browser font size starting at `16px` (and then it's 1.125* that to make an `18px` base font size)
- It's hopefully very light, so great for mobile
- It's responsive

I've had some great opportunities to play with stripping away useless fluff, using some fancy `css3` (such as `:target`!), and planning the page structure so that the layout translates well to mobile responsively.

{% include posts/figure.html src="responsive.png" %}{:.massive.center}

Try resizing your browser, I've added `breakpoints` at `1200px`, `1024px`, and `800px`.

I've factored out some bits of code into Jekyll template includes, to reduce code duplication in my templates.

I've also spent some time going through all of the old posts on here, many of which were still using some messy `HTML` from way back when the blog was hosted on Tumblr, and bringing them up to scratch to use `Markdown`, and deleting some that were no longer useful.

I'm sure there will be some issues here and there, so if you spot anything odd, and you care enough, feel free to [let me know](https://github.com/omgmog/omgmog.github.com/issues)!
