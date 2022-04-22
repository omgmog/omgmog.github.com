---
comments_issue: 53
title: Jekyll for dummies
---

2014 has been [heralded](http://www.typeandgrids.com/blog/goodbye-wordpress-2014-will-be-the-year-of-flat-file-cmses) as "the year of flat-file websites". This blog in fact uses [Jekyll](http://jekyllrb.com) to generate the very blog post you are reading.

{% include posts/figure.html src="homeheroslide2.png" %}{:.massive.center}

I've been using Jekyll in some form since [early 2012](https://github.com/omgmog/omgmog.github.com/commit/5d83bfbdf28895fd604ae811699cc3175cd7e1ad), and for me it works perfectly as a means to publish content.

<!-- more -->

It may not work for everybody as it requires getting your hands dirty in the terminal, but it has it's benefits:

- No hosting requirements besides being able to serve HTML and static files
- No cumbersome templates or plugins
- Security &mdash; no "Admin dashboard" to be logged in to, or to be hacked
- Seperated content from design
- Content can be version controlled as it's just text!
- Content written as markdown, so it's readable even with just the un-parsed files.
- Can be hosted for free on [GitHub Pages](http://pages.github.com)

As with any technology, if you're not familiar with using it there may be a bit of a learning curve.

My goal with this article is to lessen that curve to make using Jekyll as simple as possible.

### Enter Git

If up until now you've only worked on websites by editing your files locally and then uploading them by FTP to your server, you may have encountered some of the following problems:

- overwriting a file and being unable to recover from an earlier version of the file
- working on a file on the FTP server, only to have a friend/colleague also working on the file, and your changes being lost
- being able to see the difference between an older version of a file and the current version
- having no audit trail of the changes made to a file

From Wikipedia: [http://en.wikipedia.org/wiki/Git_(software)](http://en.wikipedia.org/wiki/Git_%28software%29)

> Git is a distributed revision control and source code management system with an emphasis on speed.

The key things to pick up from that are that it's "distributed" and "revision control", this means that you can have multiple people working remotely on the same files, and then when they have finished making their changes and they push them to GitHub, they will be mergeable with conflicts being easily resolveable.

Additionally, if you decide that a change that was made is no good, you can revert the file to an earlier version.

Sounds pretty good? Good.

I'm not going to go through the instructions for setting up Git here, because they're different for each Operating System and no doubt they've been discussed in great detail elsewhere on the internet.

Here are a couple of guides for setting up Git that I think are particularly good:

- [https://www.atlassian.com/git/tutorial/git-basics](https://www.atlassian.com/git/tutorial/git-basics)
- [http://rogerdudler.github.io/git-guide/](http://rogerdudler.github.io/git-guide/)
- [http://www.codecademy.com/blog/74-getting-started-with-git](http://www.codecademy.com/blog/74-getting-started-with-git)
- [http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1](http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1)
- [http://sixrevisions.com/web-development/easy-git-tutorial/](http://sixrevisions.com/web-development/easy-git-tutorial/)

#### GitHub pages

GitHub, besides being an awesome choice for hosting your Git repositories, has a nifty "Pages" featured that they offer for free. With GitHub Pages, you can host your own site using either `yourname.github.io` or a custom domain, and it even supports Jekyll out of the box.

> Hosted directly from your GitHub repository. Just edit, push, and your changes are live.

You can get started with creating GitHub Pages over at [http://pages.github.com/](http://pages.github.com/).

### Jekyll

{% include posts/figure.html src="jekyll.png" %}{:.massive.center}

Back to Jekyll. Jekyll is not a CMS, it's a "static site generator" -- that means it takes content and templates and generates a static site.

Just because I've said it's not a CMS doesn't mean it can't be CMS-like &mdash; Jekyll comes with the ability to create pages and blog posts out of the box.

Authoring new posts is very easy. If you've got any experience with HTML then you're already at an advantage as Jekyll supports HTML.

If you're not that's fine too, as Jekyll supports markdown, which is essentially plain text.

Before I dive in to that, let's cover a few Jekyll basics.

#### Installing Jekyll

Jekyll is a "ruby gem". You can read more about [ruby gems](http://rubygems.org/) on the official website.

**The instructions from here out assume you're using a Mac with a relatively recent version of OS X. If not, I'm sure you can find supplementary instructions by Googling.**

First things first, we need to make sure we've got the latest version of Ruby installed:

```bash
# Install RVM to manage ruby versions
curl -sSL https://get.rvm.io | bash -s stable
```

After you've installed RVM you may need to do the following to make sure it's loaded and available when you start your terminal:

```bash
# Open ~/.bash_profile in your editor of choice and paste the following:
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
```

Restart your terminal, then you can use RVM to install the latest stable Ruby

```bash
rvm install 1.9.2
rvm --default use 1.9.2
# This should output that you're on 1.9.2:
ruby -v
```

Now, we need to update Ruby Gems:

```bash
sudo gem update --system
```

And then finally, we can install Jekyll:

```bash
gem install jekyll
```

#### Basic project structure

Jekyll comes with a method to setup the basic structure of a Jekyll site, you can do this using the following:

```bash
jekyll new my-awesome-site
cd my-awesome-site
```

I've also created an example of a basic structure that you can see here on GitHub: [https://github.com/omgmog/basic-jekyll-structure](https://github.com/omgmog/basic-jekyll-structure)

You will see that there are a number of directories and files in this new directory, and there are a couple of additional directories that Jekyll supports that aren't here by default. I'll explain what each thing is:

##### _config.yml

This is the Jekyll configuration. You can read about the options that can be used in this file here: [Configuration](http://jekyllrb.com/docs/configuration/).

##### _layouts/

This is where your page templates reside. Layouts are HTML files with some "liquid" code in them to allow them to work as templates. You can read about using templates here: [Templates](http://jekyllrb.com/docs/templates/).

You can have a general layout for all pages, and then layouts for different kinds of pages, for example you could have a different page layout for blog posts.

##### _posts/

This is where your blog posts reside. These are usually `.md` or `.markdown` files. Each file is named with a datestamp and the title of the post. These will be used to determine the URL slug for the post, for example `2014-03-12-jekyll-for-dummies.md` would be a post with the url "/jekyll-for-dummies/" that was created on 12th March 2014.

If you're not familiar with Markdown, you can get a basic primer here: [Markdown basics](https://daringfireball.net/projects/markdown/basics).

At the top of a post file we have a "frontmatter block", this is some formatted metadata about the post, such as the title, layout, tags, etc. You can read more about the frontmatter here: [Post frontmatter](http://jekyllrb.com/docs/frontmatter/).

##### _plugins/

This isn't created by default, but if you know a bit of ruby and are adventurous enough you can create additional functionality for Jekyll using plugins. For example, I use a plugin to add pre-processing of SASS to my Jekyll-powered sites. [Plugins](http://jekyllrb.com/docs/plugins/).

##### _includes/

Again a directory that isn't created by default, but if you make it and you drop html snippets in here, you can load them in your templates and pages using the `{{ "{% include snippetname.html" }} %}` command.

##### css/

Jekyll creates a css directory, but you could call this whatever you like. I personally use 'assets' and then have 'css', 'img', and 'js' under that. When Jekyll compiles your site, any directory not starting with an underscore will be output to the generated site folder.

##### _site/

This folder is generated by default when you run Jekyll. This is where the compiled version of your site will reside. The contents of this folder will be any directory that doesn't start with an underscore, and then all pages/posts, as determined by their individual `permalink` structure.

### Using Jekyll

While developing your site, you can run Jekyll in 'watch' mode using the following command:

```bash
jekyll serve -w
```

That tells Jekyll to run a local server, and watch for any changes to the files (and regenerate them when a change is detected). This is really good for testing a Jekyll site as you create it.

By default the server will run on port `4000`, and will be accessible at [http://localhost:4000](http://localhost:4000). You can change the port by either specifying it in your `_config.yml`, or running Jekyll with the following command:

```bash
jekyll serve -w --port [yourport]
```

#### Creating a new post

To create a new post, you just need to create a `.md` or `.markdown` file in the `_posts/` directory, and name it with a datestamp followed by the slug for the post:

```bash
touch _posts/2014-03-12-jekyll-for-dummies.md
```

Then when you edit that file, you'll need to make sure it has frontmatter at the top of the file, before you type the content of your post:

```yaml
---
title: Jekyll for dummies
tags: ["wow","such","tags"]
---
```

You could probably automate this process using `rake` or a shellscript to create a file, use the current date, and pre-fill the frontmatter.

#### Importing content from other places

If you plan to move your existing blog from another service such as WordPress to Jekyll, there are some helpful utilities for migrating your data available on the Jekyll website: [Migrating to Jekyll](http://import.jekyllrb.com/docs/home/).

#### Using pre-built themes

If you want to see how other people structure their Jekyll sites, or you're not very creative and want to use an out of the box solution, there are some preconfigured "themes" available for Jekyll at [http://jekyllthemes.org/](http://jekyllthemes.org/). Additionally, others have created packages of preconfigured Jekyll that come with additional bits of functionality, such as [Jekyll Bootstrap](http://jekyllbootstrap.com).

### Publishing Jekyll

Now that you've learned what Jekyll is and how to create things with Jekyll, you will probably be wondering how to publish the things you've made.

You've got a couple of options:

#### Hosting it on GitHub pages

If you followed along earlier to make a GitHub Pages repository, you could now push all of your Jekyll templates and content to this repository, and then GitHub will do the magic of generating your site and serving it on your `yourname.github.io` domain.

There are some things to note:

- GitHub Pages runs Jekyll in 'safe mode', this means that no custom plugins will be executed.
- To make changes to your site once it's live, you will need to push your changes to GitHub, so it's probably best to make sure all of your changes work locally first (using `jekyll serve -w`), and then push them to GitHub.
- When you push changes to the repository on GitHub, it will automatically compile your site for you.
- You can use a custom domain with your GitHub pages, by creating a `CNAME` file, as detailed on the [GitHub help page](https://help.github.com/articles/setting-up-a-custom-domain-with-pages).

#### Hosting it elsewhere

Hosting elsewhere is simple. Just upload the contents of the generated `_site/` directory to your FTP server. If you plan to host the pages under a subdirectory on the server, you may need to configure the `baseurl` in your `_config.yml` before generating.
