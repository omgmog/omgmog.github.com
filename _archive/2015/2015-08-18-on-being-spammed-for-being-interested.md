---
comments_issue: 83
title: On being spammed for being interested
---

The amount of personal data that we give away these days is insane. It's true of a huge number of online services that "free isn't free", and that your personal data is the virtual currency by which you're able to use so many great services for "free".

<!-- more -->

Git as a protocol requires that you associate a name and email address with your commits, so that your commits can be easily distinguished from the next person <sup>[[1](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)]</sup>.

> The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you start creating:

```bash
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```

I star a lot of things on GitHub -- it's a nice feature, being able to save things for later, or show your support for a project by giving them a star. Ultimately the popularity of a project on GitHub is determined by it's userbase, and for that, it's stars.

{% include posts/figure.html src="octocat_sad.gif" %}{:.massive.center}

Lately I've been directly receiving emails relating to a repository I had starred on GitHub. Though I'm all for new/related things being brought to my attention, I find impersonal direct contact like this to be very invasive.

Here are two example emails I recieved, both directly linked to a single project repository I had starred:

{% include posts/figure.html src="Screen Shot 2015-08-18 at 13.44.01.png" %}{:.massive.center}

It's worth noting the structure and language of the emails. A bit chatty, hey they used the phrase "hacking on", but hey these are two unrelated people, presumably from two unrelated projects, talking about two competing pieces of software. What gives?

Well I can only assume this email isn't very personal, and is in fact very much automated. So how might they have achieved this?

Well I mentioned the `/users/:username` API endpoint on GitHub earlier. Besides that, the GitHub API has a bunch of other endpoints, such as `/repos/:username/:reponame/stargazers` (or in English, a list of all the people who have starred a repository.)

Even the most unsavvy techie could find a repository for a project that has a lot of stargazers that they want to approach, and then it's simple to get a list of all of the stargazers. Let's take a repository of mine, [Install all Firefox](https://github.com/omgmog/install-all-firefox), which has a humble 215 stars:

```bash
$ curl -s https://api.github.com/repos/omgmog/install-all-firefox/stargazers | grep login | awk '{gsub("\"","",$2); gsub("\,","",$2);print $2}' > stargazers.txt
```

This gives us a nice textfile with the usernames of all of the people who have starred this repository.

Next, we can loop through this text file and glean more profile information about each user:

```bash
$ while read line; do curl -s "https://api.github.com/users/${line}" | grep email | awk '{gsub("\"","",$2); gsub("\,","",$2);print $2}'; done < stargazers.txt
```

A bunch of the users have their wit about themselves, and have their emails anonymised, so for them we just get `null`, but for everybody else we get their real email address that they've associated with their account.

From there you can do what you like, but if you're particularly unimaginative you can send chatty emails inviting them to talk about the features of your similar project to the one they had starred in the first place, causing a momentary rage when they find your email in their inbox.

So what next? Well I will be switching email anonymisation to "on" on my GitHub profile from now on, and I'll just have to concede that my email address is out there in other places, and on all of my commits.

GitHub provide a simple walkthrough of how to hide your email address here: [https://help.github.com/articles/keeping-your-email-address-private/](https://help.github.com/articles/keeping-your-email-address-private/)
