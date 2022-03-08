---
title: Using "jekyll-redirect-from" with GitHub Pages
comments_issue: 84
---

Last week GitHub finally [added support for some useful plugins](https://help.github.com/articles/redirects-on-github-pages) to their implementation of Jekyll used for GitHub Pages.

The most notable of these is the support for the `jekyll-redirect-from` plugin.

<!-- more -->

When I first moved from Tumblr over to Jekyll [back in 2012](/post/on-migrating-from-tumblr-to-jekyll-bootstrap/), I wrote about the pains of maintaining old URLs. Tumblr uses a permalink structure of `/post/<post-id>/<slug>/`, with the `<post-id>` being an arbitrary number that means nothing to us in Jekyll.

The solution I had arrived at back then was to generate the directory structure using the [Jekyll Alias Generator](https://github.com/tsmango/jekyll_alias_generator) plugin, and then to add the generated redirect pages to my repository.

Not a very nice solution, as it meant keeping the redirects in the code base as generated HTML files, but it was the only solution.

The `jekyll-redirect-from` plugin does essentially the same thing &mdash; outputting a HTML file in your `_site/` directory for each redirect you specify, but at least now it's supported by GitHub pages, so it will mean not cluttering up my codebase.

To use the plugin you have to do a couple of things

1. Install the gem locally so you can make sure it works on your local Jekyll

```bash
gem install jekyll-redirect-from
```

2. Enable the gem in your `_config.yml` (not using a `_plugin/` like you might expect)

```yaml
gems:
  - jekyll-redirect-from
```

3. Add `redirect_from: [list or single url]` to your post frontmatter

```yaml
redirect_from:
  - "/post/some-old-slug/"
```

And that's it.

I'm still waiting for the day when Jekyll supports proper 301 redirecting, but this will do for now.

Read more about `jekyll-redirect-from`:

- [https://github.com/blog/1797-repository-metadata-and-plugin-support-for-github-pages](https://github.com/blog/1797-repository-metadata-and-plugin-support-for-github-pages)
- [https://help.github.com/articles/redirects-on-github-pages](https://help.github.com/articles/redirects-on-github-pages)
- [https://github.com/jekyll/jekyll-redirect-from](https://github.com/jekyll/jekyll-redirect-from)
