---
title: Now
permalink: /now/
last_modified_at: 2023-02-28T14:52:11
---

Welcome to my "Now" page! 'What is a "Now" page?' you ask? Here's how [nownownow.com](https://nownownow.com) describes it:

> [&hellip;] a website with a link that says “now” goes to a page that tells you what this person is focused on at this point in their life. For short, we call it a “now page”.

So basically yeah, this is what I'm currently up to and what I'm using to do it. If the timestamp below says it's been a while since this page was last updated, maybe [give me a poke](https://social.omgmog.net) or something?

{% if page.last_modified_at %}
{:.updated}
> This page was last updated on {{ page.last_modified_at | date_to_long_string }}.
{% endif %}

{% include global/wide-h3.html text="Technology" %}

{% include posts/figure.html src="now/desk.jpg" %}{:.massive}

Currently using the following:

<ul>
{% for item in site.data.now.hardware %}
  <li><b>{{ item.title }}</b>: {% if item.value %}{{ item.value | markdownify | replace:"<p>",""| replace:"</p>","" }}{% endif %}
  {% if item.values %}
  <ul>
  {% for v in item.values %}
  <li>{{ v | markdownify | replace:"<p>",""| replace:"</p>","" }}</li>
  {% endfor %}
  </ul>
  {% endif %}
  </li>
{% endfor %}
</ul>

{% include global/wide-h3.html text="Work" %}

Working at Aris Technologies as _Lead UX & UI Front-end Developer_. I mostly spend my time implementing responsive game UIs using web technologies.

{% include global/wide-h3.html text="Projects" %}

{% assign projects = site.data.projects | where:"now","true" %}
{% for project in projects %}
#### [{{ project.title }}]({{ project.link }})
{{ project.description | markdownify }}
{% if project.img %}<div class="img-grid count-{{project.img | size }}">{% for img in project.img %}{% assign _img = img | absolute_url %}{% include posts/figure.html src=_img class="center" %}{% endfor %}</div>{% endif %}
{% if project.embed %}{{ project.embed }}{% endif %}
{% endfor %}

{% include global/wide-h3.html text="Social media" %}

#### Mastodon
{% include global/mastodon.html %}
I post on [social.omgmog.net](https://social.omgmog.net) and syndicate to the [{{mastodon_instance}}]({{mastodon_host}}) Mastodon instance. <a rel="nofollow me" class="u-url" href="{{mastodon_link}}">{{mastodon_handle}}</a>. 

#### Github
<div class="github-card" data-user="omgmog" data-width="400" data-height="150" data-theme="default"></div>

#### Discord
I'm on {% include global/uurl.html what="Discord" %} occasionally. I've joined a handful of niche technology communities on there, but I don't participate much.

#### Facebook
I have a Facebook account, but it's used exclusively for buying things on Marketplace, and for my Oculus Quest.
