---
layout: post
title: "Getting to grips with git log"
tags: ["geekery", "github", "mac", "shell", "software"]
---
`git` is a powerful tool. After using it for the past couple of years I'm still finding new/powerful things that can be done with it.

<!-- more -->

One nice thing is the `git log` command, and the options you can pass to it. Some examples from the docs:
<cite><a href="http://www.kernel.org/pub/software/scm/git/docs/git-log.html">http://www.kernel.org/pub/software/scm/git/docs/git-log.html</a></cite>

`git log --no-merges` - Show the whole commit history, but skip any merges

`git log --since="2 weeks ago" -- gitk` - Show the changes during the last two weeks to the file gitk. The "--" is necessary to avoid confusion with the branch named gitk

`git log --branches --not --remotes=origin` - Shows all commits that are in any of local branches but not in any of remote-tracking branches for origin (what you have that origin doesn’t).

I haven't yet had much use for a lot of the options shown here, but I do have a particular use case: preparing for my Daily Scrum at work. Without giving a history of Agile, a Daily Scrum is a meeting amongst a development team where each team member tells the team what s/he did on the previous work day, and what s/he plans to do today.

If you're using a ticketing system such as JIRA it's quite easy to get a list of the tickets you've been working on or completed previously, but what about those little tweaks that didn't fit in a specific ticket? I find that the git commit log, when used with [sane/thoughtful commit messages](http://lea.verou.me/2012/04/git-commit-m-everything/) is a good way to get a list of the things that you've done in a given period of time.

So I made an alias/function for my `.bashrc`.

<pre><code data-language="shell"># Usage:
# workdone [time period] [committer email]

workdone(){
       default="1 day ago"
       email="[your email here]"
       git log --committer=${2:-$email} --pretty=format:"%Cgreen%ar (%h)%n%Creset> %s %b%n" --since="${1:-$default}" --no-merges
}</code></pre>

You can add this to your `.bashrc` to begin using it, and perhaps change out the `[your email here]` to your own email address.

To use it you simply `cd` to the directory of your `git` repository, and then run the following:

<pre><code data-language="shell">workdone</code></pre>

or

<pre><code data-language="shell">workdone "1 week ago"</code></pre>

or

<pre><code data-language="shell">workdone "1 week ago" "somebody@somewhere.com"</code></pre>

If you don't specify a time period (in human readable form) it will default to "1 day ago", and likewise if no email is specified at the command line, it will use the email that you've specified in the function.

![](http://f.cl.ly/items/3r2d3R13003p3q1n1j2O/by%20default%202012-07-03%20at%2016.35.07.png)
