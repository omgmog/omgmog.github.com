---
comments_issue: 70
title: Adding support for &lt;!-- more --> tag to Jekyll without plugins
---
Here's a quick tip for an approach I've started using to split post content at a given point for displaying in an archive page, without using a plugin.

<!-- more -->

Until recently the approach I took to creating a snippet of a post for my [archive](/archive.html) page just trimming the `post.content` to 300 characters in the following way:

```liquid
{% raw %}{{ post.content | strip_html | truncate:300 }}
{% if post.content | size > 300 %}
    <strong>Read more</strong>
{% endif %}{% endraw %}
```

This worked well at first, but when I wrote posts that had very little text before a block of code at the start of the post, the post snippets didn't look very good:

{% include posts/figure.html src="by%20default%202013-08-23%20at%2015.33.41.png" %}{:.massive}

There are plugins to allow you to specify where to cut off the content for an excerpt, such as [this plugin](https://gist.github.com/stympy/986665).

But that won't work as Jekyll runs with `safe: true` on GitHub Pages.

So a solution... Well, Jekyll supports the liquid filters `split` and `first`, so we can do the following:

```liquid
{% raw %}{{ post.content | split:"<!-- more -->" | first | strip_html | truncate:300 }}
{% if post.content | size > 300 %}
    <strong>Read more</strong>
{% endif %}{% endraw %}
```

And then if we include a `<!-- more -->` in our post at the point that we want to split, we'll get the post to cut off the content at that point.

{% include posts/figure.html src="by%20default%202013-08-23%20at%2015.45.23.png" %}{:.massive.center}

So how does it work?

#### The `split` filter

The first step is to split the content at the `<!-- more -->` marker using the `split` filter. When we use `split` filter, it turns out `post.content` in to an array with two (or more) parts.

```liquid
{% raw %}{% post.content | split:"<!-- more -->" %}{% endraw %}
```

So we go from:

```liquid
{% raw %}post.content =>

"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur libero nibh, semper quis libero sed, molestie molestie nulla.

<!-- more -->

In in augue enim. Aenean fringilla accumsan augue, at convallis quam consequat nec."{% endraw %}
```

To this (an array with two items):

```liquid
{% raw %}post.content =>

["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur libero nibh, semper quis libero sed, molestie molestie nulla.",
"In in augue enim. Aenean fringilla accumsan augue, at convallis quam consequat nec.]{% endraw %}
```

Then the second step is to use the `first` filter to just select the part of `post.content` that came before the `<!-- more -->` marker:

```liquid
{% raw %}{% post.content | split:"<!-- more -->" | first %}{% endraw %}
```

Which gives us:

```liquid
{% raw %}post.content =>

["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur libero nibh, semper quis libero sed, molestie molestie nulla."]{% endraw %}
```

I also take the steps to `strip_html` and `trim` the text to 300 characters.

Update:
You can use [Jekyll's built in "excerpt" feature](http://jekyllrb.com/docs/posts/#post-excerpts) these days, by doing the following:

1. Define your `excerpt_separator` in your `_config.yml`:
    ```excerpt_separator: "<!-- more -->"```
2. Update the examples I provided before, to use `post.excerpt`:
    ```{% raw %}{% post.excerpt %}{% endraw %}```

