---
layout: post
title: "Installing MySQL on OS X Mountain Lion"
tags: ["geekery", "incoming", "mac", "projects", "shell", "software"]
---
I was having some issues getting MySQL installed on OS X 10.8 Mountain Lion, and then I came across [a useful article](http://madebyhoundstooth.com/blog/install-mysql-on-mountain-lion-with-homebrew/) describing how to do it.

<!-- more -->

Here's the important information from the article to install MySQL on OS X 10.8 Mountain Lion using Homebrew:

1. [Install Homebrew](http://mxcl.github.com/homebrew/#selectable)
    <pre><code data-language="shell">$ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"</code></pre>

2. Install MySQL using Homebrew
    <pre><code data-language="shell">$ brew install mysql</code></pre>

3. Add MySQL to your LaunchAgents, so it can launch on startup
    <pre><code data-language="shell">$ mkdir -p ~/Library/LaunchAgents
$ cp /usr/local/Cellar/mysql/5.5.27/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/
$ launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist</code></pre>

4. Unset `TMPDIR` (as this isn't set to /tmp for non-root users) and install the MySQL system tables
    <pre><code data-language="shell">$ unset TMPDIR
$ mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp</code></pre>

5. Set the `root` password for MySQL
    <pre><code data-language="shell">$ /usr/local/Cellar/mysql/5.5.27/bin/mysqladmin -u root password 'YOUR_NEW_PASSWORD'</code></pre>

6. And lastly, start MySQL
    <pre><code data-language="shell">$ mysql.server start</code></pre>

