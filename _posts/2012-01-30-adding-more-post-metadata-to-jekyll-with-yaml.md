---
layout: post
title: "Adding more post metadata to Jekyll with YAML"
cover: http://f.cl.ly/items/3g1D2w020K111M1L0413/by%20default%202012-01-30%20at%2011.38.28.png
cover_width: 
---
{% include JB/setup %}
<strong>NB: This flurry of content might be shortlived, but for now I'm excited to be posting again so shush!</strong>

Jekyll, as it turns out, is a really nice <s>blogging platform</s> parsing engine. One of the nice things about it is the flexibility. In my current Jekyll set up I've added metadata to the [YAML](http://www.yaml.org/) for posts, so that I can optionally define a post cover (or image, if you'd prefer) and a width for the cover.

This can be done easily enough by simply adding new lines to the YAML block at the top of your markdown. The default YAML block is as follows:

<blockquote class="code">
<p>---</p>
<p>layout: post</p>
<p>title: </p>
<p>categories: </p>
<p>tags: </p>
<p>---</p>
</blockquote>

To add your own, you just need to create a <code>key: value</code> line in the block as follows:

<blockquote class="code">
<p>---</p>
<p>layout: post</p>
<p>title: </p>
<p>categories: </p>
<p>tags: </p>
<p><strong>cover: http://path/to/image.png</strong></p>
<p><strong>cover_width: 520px</strong></p>
<p>---</p>
</blockquote>

These are all accessible within the page templates, as for example <code>&#123;&#123; page.title }}</code> or <code>&#123;&#123; page.tags }}</code>, as detailed on the [Jekyll Bootstrap template API page](http://jekyllbootstrap.com/api/template-data-api.html).

To access these new values we just need to use <code>&#123;&#123; page.cover }}</code> or <code>&#123;&#123; page.cover_width }}</code> within our template.

Defining these each time we create a post can be a bit of a waste of time though, as it means we need to add these lines to the YAML block -- why not just add them to the <code>Rakefile</code> that generates a new post? To do this, we need to edit the <code>Rakefile</code>:
- Open the <code>Rakefile</code> in your text editor
- Look for the line starting with <code>puts "Creating new post: #{filename}"</code> (this should be line \#23)
- Below this, you should see the default YAML block, this is where you add your lines.

You can see my modified YAML block from  the <code>Rakefile</code> below (note: I don't use the categories or tags in the YAML block, so I have removed these lines):

<blockquote class="code">
<p>  puts "Creating new post: #&#123;filename}"</p>
<p>  open(filename, 'w') do |post|</p>
<p>    post.puts "---"</p>
<p>    post.puts "layout: post"</p>
<p>    post.puts "title: \"#{title.gsub(/-/,' ')}\""</p>
<p><strong>    post.puts "cover: "</strong></p>
<p><strong>    post.puts "cover_width: "</strong></p>
<p>    post.puts "---"</p>
<p>    post.puts "&#123;% include JB/setup %}"</p>
<p>  end</p>
</blockquote>

Now, next time you run <code>rake post title="Some new post"</code> your new post markdown file will contain your custom lines in the YAML block, ready to be used in your post templates.