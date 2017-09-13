---
title: 'Getting to know @for, @each and @while in Sass'
comments_issue: 58
---

I use Sass every day, both professionally and in my side projects. One thing that never seems to stick in my mind though is the correct way to use `@for`, `@each` or `@while`.

I'm writing this up here for some cathartic release, and hopefully to be of use to somebody else.

<!-- more -->

## The `@for` directive

In Sass, `@for` will let you iterate over a range of values. If you're familiar with using a`for` loop in JavaScript to loop over an `Array()`, this should be very familiar.

For example, this:

``` scss
@for $num from 1 through 4 {
  .element-#{$num} {
    width: $num * 10%;
  }
}
```

Will generate this:

``` css
.element-1 {
  width: 10%;
}
.element-2 {
  width: 20%;
}
... etc.
```

You'll notice that the value for `$num` can be used within the loop too, so in my example I'm using it to calculate the value for `width` each time.

You could also use `@for` to loop through a data object, such as a list/array, and pull values out by index:

``` scss
$list: red, green, blue, orange, brown;
$length: length($list);
@for $num from 1 through $length {
  .element-#{$num} {
    background-color: nth($list, $num);
  }
}

```

Will generate this:

``` css
.element-1 {
  background-color: red;
}
.element-2 {
  background-color: green;
}

... etc.
```

It's worth noting here that in Sass, lists are 1-based, rather than 0-based, so we start from 1.

Besides the `through` syntax, you can also use the `to` syntax `@for $num in <x> to <y>`. The difference between `through` and `to` is that `through` will include the last index, and `to` will exclude the last index.

### Through

``` scss
@for $num from 1 through 4 {
  .element-#{$num} {}
}
```

``` css
.element-1 {}
.element-2 {}
.element-3 {}
.element-4 {}
```

### To

``` scss
@for $num from 1 to 4 {
  .element-#{$num} {}
}
```

``` css
.element-1 {}
.element-2 {}
.element-3 {}
```

Further reading: [length()](http://sass-lang.com/documentation/Sass/Script/Functions.html#length-instance_method), [nth()](http://sass-lang.com/documentation/Sass/Script/Functions.html#nth-instance_method), [@for](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#_10).


## The `@each` directive

In Sass, `@each` will allow you to iterate over each item in a list. This is similar to `foreach` in JavaScript:

``` scss
$list: spoon, fork, knife, cup;
@each $item in $list {
  .#{$item} {

  }
}
```

Will generate this:

``` css
.spoon {}
.fork {}
.knife {}
.cup {}
```

When you've got multidimensional lists you can assign more than one variable:

``` scss
$list: (red, 2, spoon), (blue, 4, fork), (green, 6, knife), (yellow, 8, cup);
@each $color, $number, $item in $list {
  .#{$item} {
    background-color: $color;
    width: $number * 10%;
  }
}
```

To generate:

``` css
.spoon {
  background-color: red;
  width: 20%;
}
.fork {
  background-color: blue;
  width: 40%;
}
... etc.
```

This is really useful for using complex data structures to generate style declarations really quickly. An applied use of `@each` might look something like this:

``` scss
$flags: (england, en), (france, fr), (germany, de), (spain, es);

@each $country,$code in $flags {
  .flag-#{$code} {
    background-image: url(flags/#{$country}.png);
  }
}
```

Which generates classes for semi-transparent PNG background images:

``` css
.flag-en {
  background-image: url(flags/england.png);
}

.flag-fr {
  background-image: url(flags/france.png);
}
... etc.
```

Further reading: [@each](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#_11)


## The `@while` directive

The `@while` directive takes an expression, and continues to loop until that expression is false. This is identical to `while` in JavaScript.

Here's a simple example, comparing `$width` to `$maxWidth`, and running while `$width` is less than or equal to `$maxWidth`.

``` scss
$width: 0;
$maxWidth: 100;

@while $width <= $maxWidth {
  .width-#{$width} {
    width: $width * 1%;
  }
  $width: $width + 10;
}

```

Generates this:

``` css
.width-0 {
  width: 0%;
}

.width-10 {
  width: 10%;
}

.width-20 {
  width: 20%;
}
... etc.
```

Further reading: [@while](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#_12)

