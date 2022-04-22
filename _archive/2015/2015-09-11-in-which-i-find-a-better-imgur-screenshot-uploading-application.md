---
comments_issue: 61
title: In which I find a better Imgur screenshot uploading application
---

... Well not much of a battle really, rather just some comments on my needs of an Imgur uploader, what I've been using historically, and what I'm now going to be using.

<!-- more -->

Screenshots are a powerful tool. I take many screenshots every day, to quickly communicate something I'm working on, or show off something I've found, or even just to share funny pictures of cats.

{% include posts/figure.html src="cloudapp.png" %}{:.massive.center}

I used to pay for and use [Cloudapp](https://www.getcloudapp.com/), and it was great. You could use a custom domain, you could browse all of your uploaded images, life was good. Then they changed their pricing model, this was not good.

{% include posts/figure.html src="dropbox-public.png" %}{:.massive.center}

After that, I toyed with the idea of using my [Public folder on Dropbox](https://www.dropbox.com/en/help/16) to host images, but then felt burdened by: a) not very nice urls, b) all of these transient images stuck on my Dropbox.

For the past 3 years I've been using [Slingshot](http://lifehacker.com/5820649/slingshot-makes-taking-screenshots-and-sharing-them-one-key-command-away) to upload my screenshots to Imgur, and it has worked perfectly.

That is of course, until OS X Yosemite came along with it's cool black menu bar, and I found myself with a black system icon on a black bar.

{% include posts/figure.html src="Screen-Shot-2015-09-11-at-13.55.00.png" %}{:.massive.center}

As Mavericks brought with it [signed applications](https://developer.apple.com/library/mac/technotes/tn2206/_index.html), I couldn't simply change the icon resource myself (even though I [created some white icons](https://github.com/omgmog/slingshot-white-icons)), so I reached out to the developer, but he had since stopped developing Slingshot, and so wouldn't be bringing a white icon variant to Slingshot for Yosemite.

Thankfully, I've had [Bartender](http://www.macbartender.com/) to help since then, allowing me to hide the icon while allowing Slingshot to retain entirely functional (if just a bit ugly).

{% include posts/figure.html src="Screen Shot 2015-09-11 at 13.56.00.png" %}{:.massive.center}

Today I came across [mac2imgur](https://github.com/mileswd/mac2imgur), it's functionally identical to Slingshot (in that it watches for screenshots and uploads them, before then copying the URL to your clipboard), free, open source, and it even features a nice white icon for the black Yosemite menu bar.

{% include posts/figure.html src="Is this meta or what.gif" %}{:.massive.center}

So I'm done with Slingshot -- viva mac2imgur!
