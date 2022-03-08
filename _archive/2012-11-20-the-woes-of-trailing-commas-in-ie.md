---
comments_issue: 20
title: The woes of trailing commas in IE
---
If you leave a trailing comma in your JavaScript code, you're a terrible person. It's right up there with [omitting semicolons](https://github.com/twitter/bootstrap/issues/3057) as far as I'm concerned.

<!-- more -->

While fixing some issues on a site in IE7 recently, I was greeted by the familiarly unhelpful error message from Internet Explorer 7 that prompted me to write this.

```javascript
Error: Expected identifier, string or number
```

You can see an example below:

![A really helpful error message in IE]({{ site.url }}/images/by-default-2012-11-20-at-16.27.28.png)

What does that tell us? Bugger all in fact, unless you've tackled this problem before. It's really unhelpful, but it's caused by having a trailing comma inside an array/object/method, like the following:

```javascript
forms.set_errors(
    $form,
    response.form_errors || [],
    response.field_errors,
);
```

That right there, that's not cool. It'll make Internet Explorer explode.

If you had any consideration you would write something more like:

```javascript
forms.set_errors(
    $form,
    response.form_errors || [],
    response.field_errors
);
```

tasty.

You can prevent this problem occuring by using a [linter](http://www.jslint.com/), or you can retroactively go and find the problem-causing lines in your JavaScript using a `RegEx` pattern such as the following:

```javascript
,[\s\n]*[^\[\{\w\n\s/\*\"\'\$\#\.\`\:\|\!]
```

Though this is valid according to ECMAScript 5, it's another one of those bodged features in Internet Explorer that happens to behave unlike every other browser, so I think it's best to go for the solution that works for everybody.

That's about all I've got to say, I just wanted to rant about this and how terrible IE7 is.

