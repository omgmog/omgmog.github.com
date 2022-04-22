---
title: "Why your reasons for no-longer using a CSS pre-processor are wrong, and you're wrong, and you should feel bad."
comments_issue: 91
---

I read an article recently that explained why a web design agency had stopped using CSS pre-processing as part of their development process, as a means to "optimise [their] internal workflow".

CSS pre-processors aren't for everyone, but what I found particularly grating about this article was the mis-information, and the bad reasoning for ceasing to use a CSS pre-processor such as Sass.

<!-- more -->

You can [read the full article here](http://dwaiter.com/blog/7/why-we-no-longer-use-sass-or-less/), but the gist of their article is outlined with the headings below, along with a refutation to each point of their conjecture.

{% include posts/figure.html src="531T40T.png" %}{:.massive.center}


### "Pre-processing takes time."

In the article, they explain that using a pre-processor added time to development, concluding that they had ended up going back to using CSS coupled with the [LiveReload](http://livereload.com/) browser extension. Wow. On so many levels, wow.

First of all, these two things are not mutually exclusive, I often use both together, and I'm not sure how using a pre-processor can be any slower.

One of the main nice features of Sass is that you can start a Sass watcher that watches for changes in a directory - when a change is detected it will re-process your SCSS files to CSS.

This is explained in detail in the [Using Sass](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#using_sass) part of the Sass documentation, but it's a simple command and if you're using any other build processes it can be automatically started from them:

```bash
$ sass --watch input-directory:output-directory --style compressed
```

That's super simple, and will mean that the second you save any changes to your SCSS file their respective CSS file will be generated wherever you want it to be.

If you're not comfortable in the terminal, there are a whole bunch of GUI alternatives available, many of which are listed on the [Sass website](http://sass-lang.com/install).

So at this point, authoring SCSS is as straight forward as authoring CSS is. You can still use LiveReload with this as the generated CSS will be different each time you change your SCSS, and so LiveReload will detect a change. Unless you're using a computer with a 'Turbo' button on the front of the tower, there should be no problem with speed.

![Will this button speed up your development process?]({{ site.url }}/images/cPPUP8v.png)


### "Nested Code"

Nested code? What about nested code? There are quite a few pitfalls people fall in to while authoring SCSS, and these are:

- Re-creating the HTML structure using SCSS nesting
- Not having modular/re-usable styles
- Being overly specific with selectors
- Not knowing how to use all of the features of Sass
- Using more than 2 or 3 levels of nesting

If you're re-creating the HTML structure in your SCSS stop right there. You're creating too much dependency between the markup and the styles. Keep it simple.

If you're defining absolutely every component of your design as a new style you've got a bigger issue and I suggest you read about [BEM or OOCSS](http://www.smashingmagazine.com/2011/12/12/an-introduction-to-object-oriented-css-oocss/).

If you're having to use really specific selectors, or over-ride styles using the `!important` rule, this is endemic of not having a well-planned front-end.

Sass contains lots of cool features to minimise duplication, and complexity. I suggest you read about [@extend](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#extend) and [%placeholders](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#placeholder_selectors_).

If you're using a selector like `body div.something-cool a`, stop that.

{% assign iframe_url="https://www.youtube.com/embed/M8reIa71Bpw" %}
{% include posts/figure.html type="iframe" %}

Each nesting level should use one selector. If you've got something like the following monstrosity (taken from the article that spurred this post), stop that too!:

```scss
// ...
.presumably-a-link {
    &.active {
        .text .extras {
            opacity: 1;
        }
        .text p.description {
            opacity: 0;
            @include transition(opacity 0.2s);
        }
    }
    .text p.description {
        font-size: 16px;
        font-weight: 300;
        text-align: center;
        color: #999;
        line-height: 18px;
        padding: 40px 0;
        border-top: 8px solid $red;
    }
}
```

Seriously, that example gives me nightmares and makes me weep a little.

Here's how I would approach something like this, with very little selector complexity:

```scss
// ...
.presumably-a-link {
    .extras {
        opacity: 0;
    }
    .description {
        opacity: 1;
        @include transition(opacity .2s linear);
        // other styles
    }

    &.active {
        .extras {
            opacity: 1;
        }
        .description {
            opacity: 0;
        }
    }
}
```

### "Vendor Prefixes"

Using vendor-prefixed properties is bound to happen. People have been using `border-radius` since way before modern browser supported it as a non-prefixed property. The reason we use them? Consistency and having to support a lot of legacy crap while covering our websites with bells and whistles.

It's not ideal, but neither is manually typing out 3 or 4 vendor prefixed properties and their values each time we want to add a box shadow.

So Sass solves a nice problem there with the ability to declare mixins. Take the following example and gauge yourself how maintainable it might be. First in CSS:

```css
.my-awesome-box {
    -moz-border-radius: 10px;
    -ms-border-radius: 10px;
    -webkit-border-radius: 10px;
    border-radius: 10px;
    -moz-box-shadow: 0 0 20px rgba(0,0,0,.4);
    -ms-box-shadow: 0 0 20px rgba(0,0,0,.4);
    -webkit-box-shadow: 0 0 20px rgba(0,0,0,.4);
    box-shadow: 0 0 20px rgba(0,0,0,.4);
    -moz-box-sizing: border-box;
    -ms-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;

    padding: 20px;
    width: 400px;
    height: 300px;
}
```

Imagine these kind of properties used all over the website in a 16KLoC codebase. Imagine all of a sudden we decide that we need to add support for Opera's `-o-` prefix. Or imagine we want to change the `border-radius` to something less round.

They're quite tame examples as the different vendor-prefixed versions of each property use the same syntax, but with something such as background gradients it's a whole other world of pain. Look at this example generated by [Colorzilla](http://www.colorzilla.com/gradient-editor/):

```css
background: #1e5799; /* Old browsers */
background: -moz-linear-gradient(top,  #1e5799 0%, #2989d8 50%, #207cca 51%, #7db9e8 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#1e5799), color-stop(50%,#2989d8), color-stop(51%,#207cca), color-stop(100%,#7db9e8)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%); /* IE10+ */
background: linear-gradient(to bottom,  #1e5799 0%,#2989d8 50%,#207cca 51%,#7db9e8 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#1e5799', endColorstr='#7db9e8',GradientType=0 ); /* IE6-9 */
```

Yeah I wouldn't want to maintain even 2 variations on that style across my site, so how about my first example again, but this time using Sass?:

First some mixins, these will be declared once but can be used as often as you like for free!

```scss
@mixin border-radius($radius: 10px) {
    -moz-border-radius: $radius;
    -ms-border-radius: $radius;
    -webkit-border-radius: $radius;
    border-radius: $radius;
}
@mixin box-shadow($shadow: none) {
    -moz-box-shadow: $shadow;
    -ms-box-shadow: $shadow;
    -webkit-box-shadow: $shadow;
    box-shadow: $shadow;
}
@mixin box-sizing($method: border-box) {
    -moz-box-sizing: $method;
    -ms-box-sizing: $method;
    -webkit-box-sizing: $method;
    box-sizing: $method;
}
```

And now we'll use the mixins to apply the vendor-prefixed styles to our class.

```scss
.my-awesome-box {
    @include border-radius;
    @include box-shadow(0 0 20px rgba(0,0,0,.4));
    @include box-sizing;

    padding: 20px;
    width: 400px;
    height: 300px;
}
```

The good thing about using a mixin for this purpose is that you can make the style declarations immediately understandable, so if you come back to this code a year down the line, or it changes hands, the next person to touch the code won't have to go and dig through the spec for the vendor-prefixed properties.

Additionally, if you decide down the line that you are able to drop vendor-prefixes for some browsers, you can make the change in just one location and you'll know that you've not missed any occurrences, and that it will work exactly as you expected it to.

I have a peeve about the examples provided in the original article, and that's that they incorrectly specified their vendor-prefixed properties after the w3-spec property.

If the author had a clue about how the styles are parsed and applied they would realise that this is the wrong way around, and the order should always be vendor-prefixed styles before w3-spec. The browser parses stylesheets linearly, so first it should find the vendor-prefixed properties, and then if it can use it, it will find and use the w3-spec property.

In regard to the current stats on [CanIUse](http://caniuse.com), there are plenty of computers out there that aren't using the latest versions of browsers, and plenty of smartphones and tablets too. Deciding whether or not you need to use vendor-prefixed styles should be decided on a per-site basis, based on your analytics or surveying your users, and should be something that is monitored/changed over time.


### "Variables"

The article suggested that, as they only use Sass variables for colors, they were useless compared to the power of find/replace in their IDE. If you're just using variables for colors then, yet again, you're not fully utilising Sass.

Here are some examples of how you could use Sass variables:

```scss
// Colors
$color_accent_base: #3498DB;
$color_accent_darker_10: darken($color_accent_base, 10%);
$color_accent_lighter_10: lighten($color_accent_base, 10%);


// Arithmetic
$width_base: 960px;
$number_columns: 12;
$width_column_single: $width_base / $number_columns;

$width_columns_1: $width_column_single;
$width_columns_2: $width_column_single * 2;
$width_columns_3: $width_column_single * 3;
$width_columns_4: $width_column_single * 4;
// ... etc.
```

As you can see, unlike in the original article I'm not using variable names such as `$blue` either. If that color choice changes down the line, the variable name `$blue` is no-longer relevant or correct. This is a fundamental rule of creating CSS styles, you shouldn't (and I hope wouldn't) use a class name of `.blue-button`, rather you should be using something like `.button-primary`.


### Closing thoughts

It really bothers me when I come across articles like the one that spurred me to write this. As developers in a development community we have a social responsibility to ensure that the information we are providing to our peers is both informative and **correct**.

CSS pre-processors may not be for everybody - and certainly if you don't have much of a clue about CSS or good practices in the first place, they're definitely not for you. But don't think that because you had a bad time with them that they must be bad.

If you found yourself struggling to use an electric saw because the blade spun too quickly and it created too much dust, you wouldn't go on to tell people that hand-saws are the best tool for the job and you're renouncing power tools for all jobs.
