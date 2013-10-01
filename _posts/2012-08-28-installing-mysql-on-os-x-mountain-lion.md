---
layout: post
title: "Installing MySQL on OS X Mountain Lion"
tags: ["geekery", "incoming", "mac", "projects", "shell", "software"]
---
I was having some issues getting MySQL installed on OS X 10.8 Mountain Lion, and then I came across [a useful article](http://madebyhoundstooth.com/blog/install-mysql-on-mountain-lion-with-homebrew/) describing how to do it.

<!-- more -->

Here's the important information from the article to install MySQL on OS X 10.8 Mountain Lion using Homebrew:

[Install Homebrew](http://mxcl.github.com/homebrew/#selectable)

{% highlight bash linenos %}
$ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
{% endhighlight %}

Install MySQL using Homebrew

{% highlight bash linenos %}
$ brew install mysql
{% endhighlight %}

Add MySQL to your LaunchAgents, so it can launch on startup

{% highlight bash linenos %}
$ mkdir -p ~/Library/LaunchAgents
$ cp /usr/local/Cellar/mysql/5.5.27/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/
$ launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
{% endhighlight %}

Unset `TMPDIR` (as this isn't set to /tmp for non-root users) and install the
MySQL system tables
{% highlight bash linenos %}
$ unset TMPDIR
$ mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
{% endhighlight %}

Set the `root` password for MySQL

{% highlight bash linenos %}
$ /usr/local/Cellar/mysql/5.5.27/bin/mysqladmin -u root password 'YOUR_NEW_PASSWORD'
{% endhighlight %}

And lastly, start MySQL

{% highlight bash linenos %}
$ mysql.server start
{% endhighlight %}

