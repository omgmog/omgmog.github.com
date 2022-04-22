---
comments_issue: 24
title: Video integration with Jekyll
---
Adding some functionality to Jekyll to allow integration of YouTube videos is a pretty easy task.

First we need a couple of things:

1. A nice video hosted on YouTube
2. The embed code for the video
3. A Jekyll theme that supports video embedding

<!-- more -->

The first two things are easy enough to produce. The third thing is a bit more complicated, but hopefully after reading this post you'll have integrated YouTube videos in your Jekyll blog in no time.

## Working with the YouTube embed code

The embed code YouTube gives you contains most of the bits we need, here is an example from the video above:


```html
<iframe
    width="560"
    height="315"
    src="https://www.youtube.com/embed/fyY9tb8Rvlk"
    frameborder="0"
    allowfullscreen></iframe>
```


We need to break this in to two parts to use it with Jekyll, and set up some new [YAML front matter](/post/adding-more-post-metadata-to-jekyll-with-yaml/) to make the inclusion of videos simple.

## Setting up the YAML

When you create a new post in Jekyll, you will have the usual YAML block at the top of your file, such as the following:

```yaml
---

title: "Some awesome post"
---
```

To begin, we need to add a new line before the last `---` to define a YouTube embed url, which we take from the YouTube embed code. I'm using the `src` from the embed code above in the example below:

```yaml
---

title: "Some awesome post"
iframe_url: https://www.youtube.com/embed/fyY9tb8Rvlk
---
```

## Tweaking the embed code

Now, within our page template we will have access to the `page.iframe_url` property, so we can set up some template logic to render the YouTube video. We will be taking the embed code as above, and changing a few things:

```liquid
{% raw %}{% if page.iframe_url %}
    <div class="less-fancy-video-header">
      <iframe
        class="yt-embed"
        src="{{ page.iframe_url }}?&rel=0&showinfo=0&autohide=1&hd=1&wmode=transparent"
        frameborder="0"
        allowfullscreen="true"
        ></iframe>
    </div>
{% endif %}{% endraw %}
```

First we have a conditional block around this whole snippet, to check that we've specified a `page.iframe_url` in our YAML front matter. Then we've got pretty much the regular YouTube embed code, but I've got some extra markup around this, and some small differences to the iframe attributes.

I've included a bunch of additional `url` parameters in the `src` attribute, to hide various bits of the embedded video, but this is all purely optional. The most important parameter here is probably the `wmode` parameter, if you set this to `transparent` you can aleviate any issues with embedded YouTube video appearing over absolutely positioned elements on your page.

And that's it. You can put this embed code wherever you'd like in your page template. In [my page template](https://github.com/omgmog/omgmog.github.com/blob/main/_includes/themes/omgmog/post.html) it's at the top of the post, and then I've got regular post stuff below the embedded video -- so I can feature the video along with a nice description or full post.
