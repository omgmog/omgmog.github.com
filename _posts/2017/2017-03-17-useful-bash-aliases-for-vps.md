---
title: Useful bash aliases for VPS
tags: [bash, server, sysadmin]
archived: true
---

Some useful `bash` aliases that I use on my VPS':

```shell
www=/srv/www
conf=/etc/apache2/sites-enabled
alias ra='/etc/init.d/apache2 restart'
alias ownit='chown -R www-data:www-data .'
```

Create an Apache conf and directory for a new domain:

```shell
function makeconf {
primary=${1}
conffile="${conf}/${primary}.conf"
site_path="/srv/www/${primary}"
mkdir -p ${site_path}
echo "<VirtualHost *:80>" >> "${conffile}"
echo "  ServerName ${primary}" >> "${conffile}"
echo "  ServerAlias www.${primary}" >> "${conffile}"
shift
for i; do
cat >> "${conffile}" <<EOL
        ServerAlias ${i}
        ServerAlias www.${i}
EOL
done
echo "  DocumentRoot ${site_path}" >> "${conffile}"
echo "</VirtualHost>" >> "${conffile}"
}
```

Grab the latest Wordpress tar and extract it to the current directory:

```shell
function wordpressitup {
  wget --no-check-certificate https://wordpress.org/latest.tar.gz
  tar xfz latest.tar.gz
  cd wordpress
  cp -R * ..
  cd ..
  rm -r wordpress
  echo "Wordpress installed"
}
```

Some shortcuts to go to common directories:

```shell
function dwww {
  cd /srv/www
}
function dcache {
  cd /var/cache/mod_pagespeed/v2
}
function dconf {
  cd /etc/apache2/sites-enabled/
}
```

See which directories and files are using up all of the space:

```shell
function fsizes {
  du -h --max-depth=1 | sort -hr
  df -BG
}
```
