---
comments_issue: 78
title: Making Postgres work nicely on OS X Mountain Lion
---
Postgres on OS X has been a pain in the ass for as long as I have had to use it.

To start with, the version that comes with OS X is old, so I've always had to replace it with a better version.

<!-- more -->

Usually this entails completely eradicating the existing version system-wide, and then installing a newer version using [homebrew](http://brew.sh/). It's not enough to just install postgres using homebrew though, you have to add `launchctl` scripts, recite some ancient enchantments, and sacrifice your first born to get anything to work or to start when the system boots.

For a while, this method was fine, I had all of my postgres databases working fine across all of my virtualenv's, I was happy. Then I made the decision to update things using brew. Big mistake, brew (smartly) installs each version of a program in its own version specific folder. Unfortunately, this means any symbolic links I have to the brewed postgres binaries would be rendered broken if I upgrade postgres, and remove the old version.

After struggling with this farcical exercise for the best part of a year, and vocalising my problems at various hack days, on IRC, etc. people suggested [Postgres.app](http://postgresapp.com/).

![The elephant in the room!]({{ site.url }}/images/Image%202013.10.01%2014_32_09.jpeg)

Postgres.app is magical, it's a completely isolated/packaged version of postgres, contained in an app. If you want to upgrade it, no problem, you just replace the app, all paths stay the same.

There was a bit of voodoo needed to make it work well though, such as symlinking the `psql` binary contained within Postgres.app to my `/usr/bin` directory.

Eventually I came across another problem, `psql` couldn't run. No indication of how or why it wouldn't work, nothing in the logs (they're disabled by default for the postgres in Postgres.app).

It turned out the problem is related to how much memory `psql` requests to run, and how much OS X actually allocates. In versions of postgres that are `<9.3` this is quite high, but I've read that in `9.3` and up they've changed the memory requirement.

If you're using an older version of postgres, and you're having trouble with `psql` not starting you can do one of two things:

Temporarily adjust the memory available for postgres

```
$ sudo sysctl -w kern.sysv.shmall=65536
$ sudo sysctl -w kern.sysv.shmmax=16777216
```

or, permenantly adjust the memory available for postgres, by editing `/etc/sysctl.conf` and adding the following lines:

```
kern.sysv.shmall=65536
kern.sysv.shmmax=16777216
```

That seemed to fix everything for me, and now `psql` works with no issue.
