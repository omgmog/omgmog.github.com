---
title: Now
permalink: /now/
last_modified_at: 2026-04-22T14:58:31
description: What I'm currently up to — projects I'm working on, music I'm listening to, and the gear I'm using day to day.
---

{% if page.last_modified_at %}
{:.updated}
> This page was last updated on {{ page.last_modified_at | date_to_long_string }}.
{% endif %}

This is what I'm currently up to and what I'm using to do it. ([What's a now page?](https://nownownow.com))

{% if site.data.now.lastfm %}
  {% assign track = site.data.now.lastfm %}
<p class="now-playing">🎵 {% if track.now_playing %}Now playing{% else %}Last listened to{% endif %} <a href="{{ track.url }}">{{ track.track }} — {{ track.artist }}</a>{% unless track.now_playing %} on {{ track.played_at | date_to_string }}{% endunless %}</p>
{% endif %}

{% include global/wide-h3.html text="Projects" %}

{% assign projects = site.data.projects | where:"now","true" %}
{% if projects.size > 0 %}
{% for project in projects %}
#### [{{ project.title }}]({{ project.link }})
{{ project.description | markdownify }}
{% if project.img %}<div class="img-grid count-{{project.img | size }}">{% for img in project.img %}{% assign _img = img | absolute_url %}{% include posts/figure.html src=_img class="center" %}{% endfor %}</div>{% endif %}
{% if project.embed %}{{ project.embed }}{% endif %}
{% endfor %}
{% else %}
Nothing notable on the go right now.
{% endif %}

{% include global/wide-h3.html text="Work" %}

I'm currently working as a _Senior Full-stack Developer_ at [Consultant Connect](http://consultantconnect.org.uk/), working with Django, Angular, Sass and Dart/Flutter. My focus is on interface design and front-end development. You can find out more on [my portfolio](https://omgmog.net).

{% include global/wide-h3.html text="Social media" %}

#### Mastodon
{% include global/mastodon.html %}
I post on [social.omgmog.net](https://social.omgmog.net) and syndicate to the [{{mastodon_instance}}]({{mastodon_host}}) Mastodon instance. <a rel="nofollow me" class="u-url" href="{{mastodon_link}}">{{mastodon_handle}}</a>. 

#### Github
<div class="github-card" data-user="omgmog" data-width="400" data-height="150" data-theme="default"></div>

#### Discord
I'm on {% include global/uurl.html what="Discord" %} occasionally. I've joined a handful of niche technology communities on there, but I don't participate much.

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
