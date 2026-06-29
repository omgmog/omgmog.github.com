---
title: "Every Kickstarter project I've backed"
comments_issue: 159
tags: [kickstarter, hardware, review]
---

{%- assign count = site.data.crowdfunding | size -%}
{%- assign first = site.data.crowdfunding | first -%}
{%- assign last = site.data.crowdfunding | last -%}
{%- assign gbp = 0 -%}
{%- assign usd = 0 -%}
{%- for item in site.data.crowdfunding -%}
  {%- if item.currency == "GBP" -%}{%- assign gbp = gbp | plus: item.value -%}{%- endif -%}
  {%- if item.currency == "USD" -%}{%- assign usd = usd | plus: item.value -%}{%- endif -%}
{%- endfor -%}

Between {{ first.date }} and {{ last.date }} I backed {{ count }} Kickstarter projects, spending £{{ gbp }} and ${{ usd }} across the lot. Here they all are, in order, with what became of each.

<div class="timeline" markdown="1">
{% for item in site.data.crowdfunding %}
<div class="timeline-item" markdown="1">

**{{ item.date }}**

### [{{ item.name }}]({{ item.url }})

<div class="tags-list"><span class="tag">{% if item.currency == "GBP" %}£{% else %}${% endif %}{{ item.value }}{% if item.note %} {{ item.note }}{% endif %}</span><span class="tag">{{ item.type }}</span><span class="tag">{{ item.platform }}</span></div>

{{ item.body | markdownify }}

</div>
{% endfor %}
</div>

I've not backed anything since the second Bangle.js. Time and money are part of it: I've less of both spare for a bet that might take three years to arrive, if it arrives at all. The rest is the platform. In 2011 Kickstarter felt like funding things that wouldn't otherwise exist. A lot of it now reads as drop-shipped tat with a slick video, or projects carrying enough red flags that another Superbook feels more likely than not. Almost everything above did arrive. Not much of it stuck.