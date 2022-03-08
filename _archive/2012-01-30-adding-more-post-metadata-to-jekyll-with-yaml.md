---
comments_issue: 79
title: Adding more post metadata to Jekyll with YAML
---
<strong>NB: This flurry of content might be shortlived, but for now I'm excited to be posting again so shush!</strong>

Jekyll, as it turns out, is a really nice <s>blogging platform</s> static site generator. One of the nice things about it is the flexibility. In my current Jekyll set up I've added metadata to the [YAML](http://www.yaml.org/) for posts, so that I can optionally define a post cover (or image, if you'd prefer) and a width for the cover.

<!-- more -->

This can be done easily enough by simply adding new lines to the YAML block at the top of your markdown. The default YAML block is as follows:

```yaml
---

title:
categories:
tags:
---
```

To add your own, you just need to create a <code>key: value</code> line in the block as follows:

```yaml
---

title:
categories:
tags:
cover: http://path/to/image.png
cover_width: 520px
---
```

These are all accessible within the page templates, as for example `{{ "{{ page.title " }}}}` or `{{ "{{ page.tags " }}}}`, as detailed on the [Jekyll Bootstrap template API page](http://jekyllbootstrap.com/api/template-data-api.html).

To access these new values we just need to use `{{ "{{ page.cover " }}}}` or `{{ "{{ page.cover_width " }}}}` within our template.

Defining these each time we create a post can be a bit of a waste of time though, as it means we need to add these lines to the YAML block -- why not just add them to the `Rakefile` that generates a new post? To do this, we need to edit the `Rakefile`:

- Open the `Rakefile` in your text editor
- Look for the line starting with `puts "Creating new post: #{filename}"` (this should be line \#23)
- Below this, you should see the default YAML block, this is where you add your lines.

You can see my modified YAML block from  the `Rakefile` below (note: I don't use the categories or tags in the YAML block, so I have removed these lines):

```ruby
{% raw %}puts "Creating new post: #{filename}"
open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/-/,' ')}\""
    post.puts "cover: "
    post.puts "cover_width: "
    post.puts "---"
    post.puts "{% include JB/setup %}"
end{% endraw %}
```

Now, next time you run `rake post title="Some new post"` your new post markdown file will contain your custom lines in the YAML block, ready to be used in your post templates.
