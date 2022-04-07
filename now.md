---
title: Now
permalink: /now
last_modified_at: 2022-04-07T19:02:24
---

Welcome to my "Now" page! 'What is a "Now" page?' you ask? Here's how [nownownow.com](https://nownownow.com) describes it:

> [&hellip;] a website with a link that says “now” goes to a page that tells you what this person is focused on at this point in their life. For short, we call it a “now page”.

So basically yeah, this is what I'm currently up to and what I'm using to do it. If the timestamp below says it's been a while since this page was last updated, maybe [give me a poke on Twitter](https://twitter.com/intent/tweet?text=@omgmog+Hey%20Max!) or something?

{% if page.last_modified_at %}
{:.updated}
> This page was last updated on {{ page.last_modified_at | date_to_long_string }}.
{% endif %}

<h3 class="wide-h3">Technology</h3>

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

<h3 class="wide-h3">Work</h3>

Working at Aris Technologies as _Lead UX & UI Front-end Developer_. I mostly spend my time implementing responsive game UIs using web technologies.

<h3 class="wide-h3">Projects</h3>

{% assign projects = site.data.projects | where:"now","true" %}
{% for project in projects %}
#### [{{ project.title }}]({{ project.link }})
{{ project.description | markdownify }}
{% if project.img %}<div class="img-grid count-{{project.img | size }}">{% for img in project.img %}{% include posts/figure.html src=img class="center" %}{% endfor %}</div>{% endif %}
{% if project.embed %}{{ project.embed }}{% endif %}
{% endfor %}

<h3 class="wide-h3">Social media</h3>

#### Twitter 
I'm still on [Twitter](https://twitter.com/omgmog), though I'm not using it very much.

#### Github
<div class="github-card" data-user="omgmog" data-width="400" data-height="150" data-theme="default"></div>

#### Discord
I'm on [Discord](https://discordapp.com/users/omgmog#6206) occasionally. I've joined a handful of niche technology communities on there, but I don't participate much.

#### Facebook
I have a Facebook account again, but it's used exclusively for contacting businesses that think only having a Facebook page is enough, buying things on Marketplace, oh and for my Oculus Quest account.

#### IndieWeb Webring
{% include global/webring.html %}