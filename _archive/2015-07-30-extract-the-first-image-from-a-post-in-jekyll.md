---
title: Extract the first image from a post in Jekyll
comments_issue: 81
---

I decided that I want to show an image next to posts in my "article list" type pages in Jekyll.

It would be tedious to go through each post and add a piece of Yaml frontmatter to indicate a "post image" (even though I [had this at one point in the past](/post/adding-more-post-metadata-to-jekyll-with-yaml/)!), so how could I automate this?

<!-- more -->

{% include posts/figure.html src="tooth-pull.png" %}{:.massive.center}

All of my posts exist as Markdown in the codebase, but Jekyll parses this to HTML when generating the `{% raw %}{{ post }}{% endraw %}` object. This chunk of HTML can in turn be parsed/split to find the first occurance of an image, and grab it:

```html
{% raw %}{% assign images = post.content | split:"<img " %}
{% for image in images %}
  {% if image contains 'src=' %}
    {% assign imageMarkup = image | split:">" | first %}
    <img {{ imageMarkup }}>
    {% break %}
  {% endif %}
{% endfor %}{% endraw %}
```

Once the logic for extracting the first image is sorted out, you simply need to throw that in to a file (I'm using `_post_image.html`) and then include it where you would like the image to appear.
