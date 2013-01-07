---
layout: post
title: "Installing MySQL on OS X Mountain Lion"
tags: ["geekery", "incoming", "mac", "projects", "shell", "software"]
---
{% include JB/setup %}

I was having some issues getting MySQL installed on OS X 10.8 Mountain Lion, and then I came across [a useful article](http://madebyhoundstooth.com/blog/install-mysql-on-mountain-lion-with-homebrew/) describing how to do it.

Here's the important information from the article to install MySQL on OS X 10.8 Mountain Lion using Homebrew:

1. [Install Homebrew](http://mxcl.github.com/homebrew/#selectable)
2. Install MySQL using Homebrew

```$ brew install mysql```

3. Add MySQL to your LaunchAgents, so it can launch on startup

```$ mkdir -p ~/Library/LaunchAgents```<br />
```$ cp /usr/local/Cellar/mysql/5.5.27/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/```<br />
```$ launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist```

4. Unset `TMPDIR` (as this isn't set to /tmp for non-root users) and install the MySQL system tables

```$ unset TMPDIR```<br />
```$ mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp```

5. Set the `root` password for MySQL

```$ /usr/local/Cellar/mysql/5.5.27/bin/mysqladmin -u root password 'YOUR_NEW_PASSWORD'```

6. And lastly, start MySQL

```$ mysql.server start```

