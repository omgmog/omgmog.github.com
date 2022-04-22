---
title: Installing MySQL on OS X Mountain Lion
comments_issue: 99
---
I was having some issues getting MySQL installed on OS X 10.8 Mountain Lion, and then I came across [a useful article](http://madebyhoundstooth.com/blog/install-mysql-on-mountain-lion-with-homebrew/) describing how to do it.

<!-- more -->

Here's the important information from the article to install MySQL on OS X 10.8 Mountain Lion using Homebrew:

[Install Homebrew](http://mxcl.github.com/homebrew/#selectable)

```bash
$ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
```

Install MySQL using Homebrew

```bash
$ brew install mysql
```

Add MySQL to your LaunchAgents, so it can launch on startup

```bash
$ mkdir -p ~/Library/LaunchAgents
$ cp /usr/local/Cellar/mysql/5.5.27/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/
$ launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```

Unset `TMPDIR` (as this isn't set to /tmp for non-root users) and install the
MySQL system tables

```bash
$ unset TMPDIR
$ mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
```

Set the `root` password for MySQL

```bash
$ /usr/local/Cellar/mysql/5.5.27/bin/mysqladmin -u root password 'YOUR_NEW_PASSWORD'
```

And lastly, start MySQL

```bash
$ mysql.server start
```

