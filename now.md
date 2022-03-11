---
title: Now
permalink: /now
last_modified_at: 2022-03-11T13:52:58
---

This is [a thing](https://nownownow.com). Here's a presumably recently updated page about things that are happening at this point in my life.


{% if page.last_modified_at %}
  <div class="notice updated">This page was last updated on {{ page.last_modified_at | date_to_long_string }}.</div>
{% endif %}

{% include figure.html src="now/desk.jpg" %}{:.massive}

{% for update in site.data.now.updates reversed %}
  {% assign date = update[0] %}
  {% assign body = update[1] %}
> ##### {{ date | date_to_long_string }}
> {{ body }}
{% endfor %}

### Hardware

Currently using the following:

{% for item in site.data.now.hardware %}
  - **{{ item.title }}**: {% if item.value %}{{ item.value }}{% endif %}
  {% if item.values %}
  {% for v in item.values %}
    - {{ v }}
  {% endfor %}
  {% endif %}
{% endfor %}

### Work

Working at Aris Technologies as _Lead UX & UI Front-end Developer_. I mostly spend my time implementing game UIs using web technologies.

### Projects

Here are some recent things I've been involved in. You can find more projects on my Github.

<div class="github-card" data-github="omgmog" data-width="400" data-height="150" data-theme="default"></div><script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

{% for project in site.data.now.projects %}
#### [{{ project.title }}]({{ project.link }})
{{ project.description | markdownify }}
{% if project.img %}{% for img in project.img %}![]({{ img }}){% endfor %}{% endif %}
{% if project.embed %}{{ project.embed }}{% endif %}
{% endfor %}

### Social media

I'm still [on Twitter](https://twitter.com/omgmog), though I'm not using it actively.

I'm on <a href="https://discordapp.com/users/omgmog#6206">Discord</a> occasionally. I've joined a handful of niche technology communities on there, but I don't participate much.

I have a Facebook account again, but it's used exclusively for contacting businesses that think only having a Facebook page is enough, buying things on Marketplace, oh and for my Oculus Quest account.
