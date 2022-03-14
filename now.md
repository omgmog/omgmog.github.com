---
title: Now (ish)
permalink: /now
show_webring_inline: true
last_modified_at: 2022-03-14T13:26:16
---

{% if page.last_modified_at %}
  <div class="notice updated">This page was last updated on {{ page.last_modified_at | date_to_long_string }}.</div>
{% endif %}

{% include figure.html src="now/desk.jpg" %}{:.massive}

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

{% for project in site.data.now.projects %}
#### [{{ project.title }}]({{ project.link }})
{{ project.description | markdownify }}
{% if project.img %}
{:.img-grid}
{% for img in project.img %}![]({{ img }}){% endfor %}
{% endif %}
{% if project.embed %}{{ project.embed }}{% endif %}
{% endfor %}

### Social media

#### Twitter 
I'm still [on Twitter](https://twitter.com/omgmog), though I'm not using it actively.

#### Github
<div class="github-card" data-github="omgmog" data-width="400" data-height="150" data-theme="default"></div><script src="//cdn.jsdelivr.net/github-cards/latest/widget.js"></script>

#### Discord
I'm on <a href="https://discordapp.com/users/omgmog#6206">Discord</a> occasionally. I've joined a handful of niche technology communities on there, but I don't participate much.

#### Facebook
I have a Facebook account again, but it's used exclusively for contacting businesses that think only having a Facebook page is enough, buying things on Marketplace, oh and for my Oculus Quest account.

#### IndieWeb Webring
{% include webring.html %}