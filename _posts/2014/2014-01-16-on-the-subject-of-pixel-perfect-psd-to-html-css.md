---
comments_issue: 35
title: On the subject of "Pixel-perfect PSD to HTML/CSS"
tags: [article]
---
I read an [article](http://blog.teamtreehouse.com/pixel-perfect-front-end-development-matters) on the subject of implementing a PSD design of a website perfectly in HTML/CSS, and without wanting to spend my time writing a lengthy response in the comment form of a blog for it to disappear in to the depths of a blog that I don't visit very regularly, I figured I'd write my thoughts up as a blog post.

<!-- more -->

The gist of the article goes like this:

> I hired a freelance developer at a low rate and expected them to implement my PSD exactly as I made it look in Photoshop, but they couldn't handle that. I'm so outraged with the lack of attention to detail of front-end developers.

{% include posts/figure.html src="cott1.jpg" %}{:.massive.center}


### The blame isn't always in the hands of the front-end developer

There are so many things that could have factored in to this bad experience, starting with the PSD itself:

- Was the PSD structured/organised well?
- Did the PSD contain guides/measurements for all components of the design?
- Was the PSD heavily dependent on Photoshop's blending modes?
- If the PSD was for multiple pages, did the designer consider modular/DRY methodologies when deciding how lists and things should be represented in the design?
- Were font sizes specified using `pt` or `px` units?

There are always differences in the environment used by the designer, and the developer:

- Were the designer/developer using Mac or Windows?
- What were their colour settings for the document set to?
- What kind of screen was the PSD created on?

There are always going to be technological reasons that a HTML/CSS implementation of a PSD might look a bit different to the original PSD:

- Fonts render differently in Photoshop vs the browser, fonts render differently between different operating systems and browsers.
- We don't have those fancy blending effects in CSS ([yet](http://demosthenes.info/blog/707/PhotoShop-In-The-Browser-Understanding-CSS-Blend-Modes)).
- Though we have `border-radius`, `box-shadow`, `font-family` and loads of other `CSS3` features, support for these is not consistent across all browsers.
- We use new techniques to build websites these days, first and foremost we don't use tables and image slices.

You can't honestly expect one static design to look pixel perfect on all devices or in all browsers. Have you heard of responsive design? Do you know what kind of screens the people viewing the page you've designed will be using? Do you have any idea if the fancy blending effects you're applying liberally to your layers are reproducible with CSS effects alone (or if they're not, are your layers organised in a sane way so that they can be sliced?).

### How can developers work better with the designers?

1. Be upfront about the feasibility of implementing components of the design accurately, and use your domain knowledge to inform the designer.
2. If you notice any inconsistently styled components, clarify with the designer that the inconsistencies are intentional and not just an oversight.
3. If you're using a version control system (such as GitHub), make sure that you're committing pieces that are complete, or make sure that the person reviewing your implementation of the design is aware of the state of the implementation to save them carrying out feedback too early.
4. Use a [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) methodology such as [SMACSS](http://smacss.com/)
5. Use a CSS preprocessor such as [SASS](http://sass-lang.com/)

### How can designers make the job of implementing a design easier/better?

1. The [Photoshop Etiquette](http://photoshopetiquette.com/) &mdash; read it, learn it, abide by it.
2. Use [PSD Grade](http://psdgrade.com/) to check the quality of your PSD against some common quality pitfalls.
3. Familiarise yourself with the technology you're designing for. If you intend for the design to be responsive, consider how it will look at various breakpoints. See: [50 Useful Responsive Web Design Tools For Designers](http://www.hongkiat.com/blog/rwd-tools/)
4. If you're designing for a content management system, know the possible types/sizes of data that could be in any part of the design &mdash; such as lengths of text, different configurations of pages, image sizes, etc.
5. Have a realistic expectation of how the page will look. Your fonts aren't going to look like they do in Photoshop when implemented, "18pt" in Photoshop is not the same as "18pt" in the browser. See: [Photoshop/Browser Font Rendering](http://pajama-sloth.tumblr.com/post/20808946617/photoshop-vs-browser-font-rendering)
6. Provide a layer with measurements for all aspects of the design, it will take a lot longer to implement if we're having to measure the distance between pixels when implementing the design.
7. If you've used any imagery in your design, provide the original assets along with the PSDs of your design.

