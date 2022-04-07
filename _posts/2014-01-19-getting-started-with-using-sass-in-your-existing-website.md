---
title: Getting started with using Sass in your existing website
comments_issue: 19
tags: [guide]
---
Sass is a CSS-compatible preprocessor for CSS. It allows you to reduce the amount of duplication and complexity in your CSS by using variables, mixins (functions), nesting, and other cool things that should have existed in the CSS spec from the beginning.

<!-- more -->

From the [Sass website](http://sass-lang.com/):

> CSS on its own can be fun, but stylesheets are getting larger, more complex, and harder to maintain. This is where a preprocessor can help. Sass lets you use features that don't exist in CSS yet like variables, nesting, mixins, inheritance and other nifty goodies that make writing CSS fun again.

As I mentioned, Sass brings a bunch of features to the table to make authoring your styles a lot faster. Here are some examples of those features:

### Variables

```scss
$primary_link_color: #6792a6;
$font_stack: Helvetica, Arial, sans-serif;
$font_base_size: 16px;
$column_width: 60px;
$site_width: 12 * $column_width;
```

### Calculations

As you may have noticed above, you can use calculations in variables; You can also use them inline. Calculations can use standard math operators like `+`, `-`, `*`, `/`, and `%`.

```scss
$site_width: 960px;
$column_width: $site_width / 12;

aside {
    width: $column_width * 2;
}
```

Output:

```css
aside {
    width: 160px;
}
```


### Partials

If you want to organise your styles, you can do it by breaking them up in to individual files, such as `_fonts.scss`. Partials should be named starting with an underscore, so that Sass won't pick them up and try and compile them to CSS files.

To use your partial, you can do something like this:

```scss
@import 'fonts';
```

As you can see, I omitted the `.scss` when importing. You can import with and without the `.scss`, it's completely up to you.

### Mixins

Mixins are Sass' functions. This is where the true power of Sass can be demonstrated.

Mixins can have parameters, like functions, and can be used to either handle part of a style declaration, or a complete declaration.

You can provide default values for parameters to make them optional.

Declaring a mixin:

```scss
@mixin some-mixin($parameter_one, $parameter_two: #f0f) {
    color: $parameter_one;
    background-color: $parameter_two;
}
```

Using a mixin:

```scss
body {
    @include some-mixin(#f00);
}
```

Output:

```css
body {
    color: #f00;
    background-color: #f0f;
}
```

Here are some of the Sass mixins that I use:

#### Border-radius

```scss
@mixin border-radius($radius) {
    -moz-border-radius: $radius;
    -webkit-border-radius: $radius;
    -ms-border-radius: $radius;
    border-radius: $radius;
}
```

#### Box-shadow

```scss
@mixin box-shadow($shadow) {
    -moz-box-shadow: $shadow;
    -webkit-box-shadow: $shadow;
    box-shadow: $shadow;
}
```

#### Transitions

```scss
@mixin transition($duration, $property: all, $timing-function: linear) {
    -moz-transition: $property $duration $timing-function;
    -webkit-transition: $property $duration $timing-function;
    -o-transition: $property $duration $timing-function;
    transition: $property $duration $timing-function;
}
```

#### Keyframes

```scss
@mixin keyframes($name) {
    @-webkit-keyframes #{$name} {
        @content;
    }
    @-moz-keyframes #{$name} {
        @content;
    }
    @-o-keyframes #{$name} {
        @content;
    }
    @keyframes #{$name} {
        @content;
    }
}
```

#### Animation

```scss
@mixin animation($name, $duration: 1s, $easing: linear, $direction: forwards) {
    -webkit-animation: $name $duration $easing $direction;
    -moz-animation: $name $duration $easing $direction;
    animation: $name $duration $easing $direction;
}
```

#### Media queries

```scss
@mixin breakpoint($breakpoint) {
    @if $breakpoint == "big-screen" {
        @media all and (min-width: 80em) {
            @content;
        }
    }
    @else if $breakpoint == "not-big-screen" {
        @media all and (max-width: 80em) {
            @content;
        }
    }
    @else if $breakpoint == "medium-screen" {
        @media all and (max-width: 50em) {
            @content;
        }
    }
    @else if $breakpoint == "small-screen" {
        @media all and (max-width: 30em)  {
            @content;
        }
    }
    @else {
        @media all and ($breakpoint) {
            @content;
        }
    }
}
```

### Deploying your Sass

So now that you know what Sass is, and how to use it, let's look at the ways that you can use it with your website.

You've got a couple of options here:

- Compile the Sass locally, and then upload the compiled CSS to your web server.
- Use a server-side Sass processor to compile and serve the Sass as CSS.

So let's look at each of these in a bit more detail.

#### Compile Sass locally and deploy compiled CSS

The Sass website lists a bunch of software for all platforms that you can use to compile your Sass files to CSS locally. You can check that out on the [Sass install page](http://sass-lang.com/install).

#### Compile Sass on the server and serve compiled CSS

If your web host supports PHP (most do) you can use SCSSPHP. SCSSPHP is a PHP script that compiles your SCSS (Sass using CSS-like syntax) files to CSS on the server, and serves the compiled CSS.

This is how to set it up:

Grab the latest SCSSPHP files from the [SCSSPHP GitHub repository](https://github.com/leafo/scssphp).

Upload `scss.inc.php` to your serve somewhere (such as your styles directory).

Create a new file in the same directory called `s.php`, and put the following inside it:

```php
<?php
require "scss.inc.php";
$scss = new scssc();
$scss->setFormatter("scss_formatter_compressed");
$server = new scss_server("stylesheets", null, $scss);
$server->serve();
?>
```

Now, make a directory called `stylesheets` and make it so that the s.php script can write to it. Upload your `.scss` files to the stylesheets directory.

You should now have something like the following:

```
css/
    s.php
    scss.inc.php
    stylesheets/
        style.scss
```

Now, instead of linking to your `.css` files in your `HTML`, you link to the `s.php` script, and specify the `.scss` file to load:

```html
<link rel="stylesheet" href="css/s.php/style.scss" />
```

That's it really, now if you make changes to your `.scss` file, `s.php` will generate `CSS` automatically and cache it.

You could take it one step further and use `.htaccess` to hide the `s.php` part of the url like this:

```conf
Options +FollowSymLinks
RewriteEngine On
RewriteBase /
RewriteRule ^css/(.*)\.css$ /css/s.php/$1.scss [R=301,L]
```

Then you can just link to your `CSS` as usual, like the following example for `style.scss`:

```html
<link rel="stylesheet" href="css/style.css" />
```
