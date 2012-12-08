---
layout: post
title: "On migrating from Tumblr to Jekyll Bootstrap"
tags: ["jekyll", "tumblr", "geekery", "software", "projects", "blog", "github"]
---
{% include JB/setup %}
I've been toying with the idea of moving away from [Tumblr](http://www.tumblr.com) for a long time now, having had my own share of problems with [Tumblr](http://www.tumblr.com) downtime.

I had made some steps into switching from [Tumblr](http://www.tumblr.com) to Octopress, but the steps to deploy [Octopress](http://octopress.org) meant that I had to compile all of my pages each time I made a change, and then deploy them using <code>rsync</code>.

I'm now using [Jekyll Bootstrap](http://jekyllbootstrap.com/), hosted by [GitHub](http://www.github.com). The steps to deploy are much easier, I just create a new markdown file for a post or page, write content using my text editor, and then deploy to [GitHub](http://www.github.com) using <code>git</code>.

Switching to [Jekyll Bootstrap](http://jekyllbootstrap.com/) and maintaining all of my old [Tumblr](http://www.tumblr.com) posts and urls has been a smooth process, I'll detail this below:

* Setting up a local repository for GitHub pages with Jekyll Bootstrap

	This was really simple, the [Jekyll Bootstrap website](http://jekyllbootstrap.com/index.html#start-now) has some simple steps to get you started.

* Importing my old Tumblr posts

	This required a little bit of work, as I had to update my local copy of <code>gem</code>, but after I had installed all of the necessary gem bundles, importing from Tumblr was as simple as running a one-line command:
 	<blockquote class="code">
		<p>
			$ ruby -rubygems -e 'require "jekyll/migrators/tumblr"; Jekyll::Tumblr.process("http://www.your_blog_url.com", true)'
		</p>
 	</blockquote>
 	Migrating from other platforms is detailed on the [Jekyll migrations page](https://github.com/mojombo/jekyll/wiki/blog-migrations) over at GitHub.

* Tidying up the imported pages a bit

 	One of the downsides of using a platform that uses a WYSIWYG editor is that the posts end up with a lot of crap markup. So before deploying your imported pages, it's a good idea to go through the imported pages and [tidy up the markup](https://github.com/omgmog/omgmog.github.com/commit/8c6eac2586d6989301162a05a3b19f4daea52d50).

* Setting up my subdomain to work with GitHub pages

	Using a custom subdomain with GitHub pages couldn't be easier. You simply create a file named <code>CNAME</code> with the subdomain you want to use contained in it, and put it in the [root of your GitHub repository](https://github.com/omgmog/omgmog.github.com/blob/master/CNAME).

	After you've set up the <code>CNAME</code> file on your repository, you'll also need to create the subdomain with your domain registrar, and point it to the [GitHub Pages IP address](http://pages.github.com/#custom_domains).

* Pushing your new blog to GitHub

	This is the easiest part of the whole process, pushing to GitHub. Assuming <code>git</code> is already set up on your system, you just use the following commands:
	<blockquote class="code">
		<p>
			git add &lt;the new files you've created (use 'git status' to see)&gt;
		</p>
		<p>
			git commit -am "A message describing the changes you made"
		</p>
		<p>
			git push
		</p>
	</blockquote>

After all of that, all that remains is adjust the permalink taxonomy, and creating a custom blog index (such as the one I've made) to display the latest posts.

So far I'm really happy with Jekyll, and for now I'm quite happy with using the Twitter Bootstrap style -- in time I'm sure I'll be tweaking and changing the style a bit to align it with [my main website](http://www.omgmog.net) a bit better.

###### Update:

So a day or two after putting the new blog live, I realised that Google had indexed my old tumblr posts with the following permalink structure:

<blockquote class="code">
<p>
http://blog.omgmog.net/post/XXXXX/post-title-as-slug
</p>
</blockquote>

but I'm using the shorter version, still valid from the old blog:

<blockquote class="code">
<p>
http://blog.omgmog.net/post/XXXXX
</p>
</blockquote>

Which will actually be <code>http://blog.omgmog.net/post/post-title-as-slug</code> for new posts created with Jekyll.

A couple of my posts were high-traffic posts according to Google Analytics, so I had to sort out some sort of redirect for these posts so that the old indexed urls would still function, and visitors would find their way to the new posts. I found a Jekyll plugin called [Jekyll Alias Generator](https://github.com/tsmango/jekyll_alias_generator) which works by just adding a new <code>alias: /path/for/alias</code> to the YAML block on posts. The problem with this though is that GitHub hosted pages don't allow you to use plugins with Jekyll, so I couldn't cleanly deploy this by just adding <code>alias</code> to my YAML block and never thinking about it again.

The solution I found for this was to run the local Jekyll server with the <code>rake preview</code> command, so that it would generate the alias pages for each post and put them in the <code>_site</code> directory. I then copied the aliases for the posts I wanted to maintain to a new <code>post</code> folder in the root of my Jekyll repository (mirroring the post structure that I'm using), and then deployed these static HTML-based redirects to GitHub.

I'm not completely happy with this solution as it means I've now got a handful of static html files on GitHub that serve no purpose other than to redirect to new pages, but it works.

I'd like if GitHub would allow plugins in some form in the future, or give us some sort of solution for setting up pattern-based redirects, similar to how you would do with a <code>.htaccess</code> file on an Apache webserver.