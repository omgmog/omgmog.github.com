---
layout: page
title: Home
---
{% include JB/setup %}
<div class="row">
  <span class="span4">
    {% include about_snippet %}
  </span>
  <span class="span10">
    <div class="latest_post">
      {% for post in site.posts limit:1 %}
        {% capture post_Ym %}{{ post.date | date:"%Y%m" }}{% endcapture %}
        {% capture now_Ym %}{{ site.time | date:"%Y%m" }}{% endcapture %}
        <h4>{{ post.title }}{% if post_Ym == now_Ym %} <span class="label success">New</span>{% endif %}</h4>
        {% if post.cover %}
          <div class="post_cover">
            <img src="{{ post.cover }}" alt="{{ post.title }}" width="{% if post.cover_width %}{{ post.cover_width }}{% else %}520px{% endif %}"/>
          </div>
        {% endif %}
        <div class="post_content">
        <p class="post_meta">{{ post.date | date_to_string }} (<a href="{{ BASE_PATH }}{{ post.url }}">Permalink</a>)</p>
        {{ post.content }}
        </div>
      {% endfor %}
    </div>
    <hr />
    <h4>Recently...</h4>
    <ul class="recent_posts">
      {% for post in site.posts limit:4 offset:1 %}
        {% capture post_Ym %}{{ post.date | date:"%Y%m" }}{% endcapture %}
        {% capture now_Ym %}{{ site.time | date:"%Y%m" }}{% endcapture %}
        <li class="{% cycle nil,'margin_left' %}">
          <span>{{ post.date | date_to_string }}</span><br /><a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}{% if post_Ym == now_Ym %} <span class="label success">New</span>{% endif %}</a>
        </li>
      {% endfor %}
    </ul>
  </span>
</div>