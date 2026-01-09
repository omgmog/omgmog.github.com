---
title: Moving to GitHub Actions (and adding .txt posts)
comments_issue: 126
tags: [jekyll, guide]
syndication: 
  - https://social.omgmog.net/2026/postmoving-to-github-actions-and-adding-txt-postsas-a-result-of-reading-blog202512a-small-collection-of-text-only-websites-by
  - https://indieweb.social/@omgmog/115865892816110097
---

This year I moved the blog from GitHub Pages' built-in Jekyll to a GitHub Actions workflow, then added .txt URL support for posts. Inspired by [Terence Eden's blog post](https://shkspr.mobi/blog/2025/12/a-small-collection-of-text-only-websites/) about text-only websites.

<!-- more -->

## Why move to GitHub Actions?

GitHub Pages runs Jekyll in `safe: true` mode, which disables custom plugins. It limited me to their whitelist of approved plugins, such as [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap) and [jekyll-feed](https://github.com/jekyll/jekyll-feed).

That was fine for years, but it meant I couldn't build anything more interesting without resorting to workarounds. Moving to GitHub Actions removed that restriction entirely. With Actions, I control the build environment and can run any Jekyll plugin.

One thing broke in the migration: GitHub Pages automatically included the [jekyll-github-metadata](https://github.com/jekyll/github-metadata) plugin, which populated `site.github.*` variables like repository URLs and build revisions. My templates relied on these, so I wrote a [replacement plugin](https://github.com/omgmog/omgmog.github.com/blob/main/_plugins/github_metadata.rb) that extracts the same info from Git and GitHub Actions environment variables.

The workflow itself is _nothing fancy_ - it checks out the code, sets up Ruby, builds Jekyll, and deploys:

```yaml
- name: Build with Jekyll
  run: bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
  env:
    JEKYLL_ENV: production
```

This workflow runs on every push to main then deploys the build via GitHub's standard Pages actions, so we have the same simple workflow as with Jekyll on GitHub Pages.

## The .txt format idea

With custom plugins enabled, I could finally build that .txt feature. I soon realised it would require an ungodly amount of hoop jumping to make it work without plugins:

- Creating stub files for each .txt version would mean maintaining duplicates or setting up some fragile build script and committing generated content to the blog source repo
- Duplicating post content entirely would become a maintenance nightmare
- Post-processing the built site would be fragile and wouldn't integrate with Jekyll's metadata system

Another [custom plugin](https://github.com/omgmog/omgmog.github.com/blob/main/_plugins/txt_format_generator.rb) sorted this out. It generates the .txt files during Jekyll's build process, keeps them in sync automatically, and adds the right metadata for linking between formats.

The first part was creating the .txt URLs themselves. I used Jekyll's [PageWithoutAFile](https://github.com/jekyll/jekyll/blob/master/lib/jekyll/page_without_a_file.rb) class to create .txt versions _without actual files on disk_. Each post gets a .txt URL at `/post/slug.txt`.

Here's how the virtual page creation works:

```ruby
class TxtFormatPage < PageWithoutAFile
  def initialize(site, post)
    @site = site
    @base = site.source

    collection_path = post.collection.label == "posts" ? "post" : post.collection.label
    slug = post.data['slug']

    # Creates /post/slug.txt
    @dir = collection_path
    @name = "#{slug}.txt"

    self.process(@name)
    self.data = {
      'layout' => 'plain',
      'permalink' => "/#{@dir}/#{@name}",
      'post' => post
    }

    # Generate Liquid content that references the original post
    self.content = <<~LIQUID
    {% raw %}{% include txt-format.html %}{% endraw %}
    LIQUID
  end
end
```

Those virtual pages needed content, which meant converting HTML posts to plain text. I used the [html_to_plain_text](https://github.com/soundasleep/html_to_plain_text) gem for the main conversion, but it needed post-processing to get the output looking how I wanted. The [template](https://github.com/omgmog/omgmog.github.com/blob/main/_includes/txt-format.html) pipes the content through custom Liquid filters:

```liquid
{% raw %}{{ target.content | images_to_urls | unwrap_links | html_to_plain_text_convert | wrap_lines | collapse_blank_lines }}{% endraw %}
```

Here's what the filters do:

**images_to_urls** - Converts image tags to `[IMAGE: url]` references:

```ruby
def images_to_urls(input)
  site_url = @context.registers[:site].config['url']

  input.gsub(/<img[^>]+src=["']([^"']+)["'][^>]*>/i) do
    url = $1
    url = "#{site_url}#{url}" if url.start_with?('/')
    "\n[IMAGE: #{url}]\n"
  end
end
```

**unwrap_links** - Converts links to "text (url)" format, only showing the URL if it differs from the link text:

```ruby
def unwrap_links(input)
  site_url = @context.registers[:site].config['url']

  input.gsub(/<a[^>]+href=["']([^"']+)["'][^>]*>(.*?)<\/a>/im) do
    url = $1
    text = $2.strip
    url = "#{site_url}#{url}" if url.start_with?('/')

    # Only show URL if different from text
    if text.downcase == url.downcase || text == url
      text
    else
      "#{text} (#{url})"
    end
  end
end
```

**wrap_lines** - Wraps text to 80 characters while preserving code blocks, lists, blockquotes, and long URLs.

**collapse_blank_lines** - Removes excessive whitespace by collapsing three or more consecutive newlines down to two.

The last piece was hooking up the metadata. The generator adds an `alternates` array to each post's data, making it available to templates.

```ruby
def add_alternate(doc, txt_page)
  doc.data["alternates"] ||= []
  doc.data["alternates"].reject! { |a| a["type"] == "text/plain" }

  doc.data["alternates"] << {
    "type"  => "text/plain",
    "href"  => txt_page.url,
    "title" => "plain text"
  }
end
```

The [txt-format.html](https://github.com/omgmog/omgmog.github.com/blob/main/_includes/txt-format.html) template wraps the converted content with a header, footer, and a link back to the original HTML post.

## Results

It works. This post is available as [HTML](https://blog.omgmog.net/post/moving-to-github-actions-and-adding-txt-posts/) and [.txt](https://blog.omgmog.net/post/moving-to-github-actions-and-adding-txt-posts.txt). The text version strips away HTML and wraps everything to 80 characters while keeping code blocks intact.

The real win was moving to GitHub Actions. I've got a _proper_ plugin system now - can write custom generators, filters, and tags without workarounds. The infrastructure's there if I want to extend Jekyll further down the line. As for the .txt URLs, I can't imagine many people will use them. The site's already pretty light. But the option's there.
