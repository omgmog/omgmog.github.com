---
title: Jekyll Antipatterns
comments_issue: 27
---

{% include posts/figure.html src="jekyllantipatterns.jpg" %}{:.massive.center}

If you've used any framework or language for long enough, you might find that you've got parts of your code that are not using the language in it's current state to it's full potential.<!-- more -->

Since I first started to use Jekyll on Github Pages in 2012, an increased release cycle and the adoption of more current versions of Jekyll on Github Pages has meant that the quirky work-arounds (or antipatterns) that were necessary back in 2012 are no-longer necessary, and the same results can be achieved using built-in neater solutions.

Here are a couple of them.

## Using `{% raw %}{% if %}{% endraw %}` to filter the results of a loop

At first this might not seem like a bad approach, but as your Jekyll blog grows, and the number of files under `_posts` grows, looping over the queryset will become more and more inefficient.

Thankfully, Jekyll added the `where` filter in [version 2.0.0](https://github.com/jekyll/jekyll/releases/tag/v2.0.0), so  you can filter your queryset before looping over it.

Antipattern:

```liquid
{% raw %}{% for post in site.posts %}
    {% if post.featured == "true" %}
        {{ post.title }}
    {% endif %}
{% endfor %}{% endraw %}
```

Proper method:

```liquid
{% raw %}{% assign featured_posts = (site.posts|where:"featured","true") %}
{% for post in featured_posts %}
    {{ post.title }}
{% endfor %}{% endraw %}
```

## Limiting the number of filtered results presented

It's tempting to write a for loop in Jekyll as you would in any other language: incrementing a counter until a limit is reached, and then exiting the loop.

If you find yourself doing this, take a moment and consider if you really need to be manually implementing such a common idiom, and then realise that Jekyll can do the hard work for you with it's `limit:n` filter.

Antipattern:

```liquid
{% raw %}{% assign count = 0 %}
{% assign max = 5 %}
{% for post in site.posts %}
    {% if post.featured == "true" and count < max %}
        {{ post.title }}
        {% capture count %}{{ count | plus:1 }}{% endcapture %}
    {% endif %}
{% endfor %}{% endraw %}
```

Proper method:

```liquid
{% raw %}{% assign featured_posts = (site.posts|where:"featured","true") %}
{% for post in featured_posts limit:5 %}
    {{ post.title }}
{% endfor %}{% endraw %}
```

## Using if/else construct to negate a test

When working with if/else logic, it's easy to fall for the trap of testing for the opposite boolean to what you actually need, and so having an empty "true" block sitting in your templates.

Perhaps not obviously, Jekyll has the `{% raw %}{% unless %}{% endraw %}` tag. This tag is pretty much a "if not" test, so you can simplify your templates and get rid of empty blocks.

Antipattern:

```liquid
{% raw %}{% if page.sidebar contains "hide_about" %}
    {# Nothing #}
{% else %}
    {# About block #}
{% endif %}{% endraw %}
```

Proper method:

```liquid
{% raw %}{% unless page.sidebar contains "hide_about" %}
    {# About block #}
{% endunless %}{% endraw %}
```

## Using an old version of Jekyll/Ruby

This is less of an antipattern about templating in Jekyll and more of a general notice. I had found lately that on my MacBook Jekyll was taking over 20 seconds to generate pages whenever I made a change. I tried a lot of things to optimise/simplify my Jekyll codebase (which is what led to this post).

I noticed that on a my new iMac at work generation time was only about 2-3 seconds, so I took a look at what was different on my MacBook.

Now, this MacBook is fairly new, I've only had it for about 5 months, but before that I'd had my previous MacBook for over 4 years. I have a [shell script](https://gist.github.com/omgmog/7145489) to set things up when I start using a new Mac, such as installing Ruby, setting preferences, etc.

So on my MacBook I did a couple of tests to see what I'm using:

```bash
➜ ruby -v
ruby 1.9.3p551 (2014-11-13 revision 48407) [x86_64-darwin14.1.1]
➜ gem -v
2.4.6
➜ jekyll -v
jekyll 2.5.3
```

One thing my shell script does is it installs a specific version of Ruby (1.9.3). Not because I have any real reason to use a specific version, just because when I created my script that was the latest version. At the time of writing this, the current stable version is Ruby 2.2.2.

Presumably the latest versions of `gem` and `jekyll` that will run with Ruby 1.9.3 are the versions I have installed there, so I upgraded Ruby using `rvm`, and then upgraded `gem` and reinstalled `jekyll`:

```bash
➜ rvm install 2.2.2
➜ rvm use 2.2.2
➜ gem update
➜ gem install jekyll
```

A quick test shows that I'm now running some newer versions of these programs:

```bash
➜ ruby -v
ruby 2.2.2p95 (2015-04-13 revision 50295) [x86_64-darwin14]
➜ gem -v
2.4.8
➜ jekyll -v
jekyll 2.5.3
```

Now when I'm running Jekyll and it generates pages, it only takes 2-3 seconds as on my iMac, rather than 20 seconds.










