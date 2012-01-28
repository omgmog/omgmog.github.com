---
layout: page
title: Home
---
{% include JB/setup %}
<div class="row">
  <span class="span5">
    <h3>About</h3>
    <p>Welcome to "blomg" or the "omgmog blog" - I'm still deciding what to call this.</p>
    <p>Previously the blog was powered by <a href="http://www.tumblr.com" target="_blank">Tumblr</a>, and even more recently I was part-way through converting it to <a href="http://octopress.org/" target="_blank">Octopress</a>, but now I've moved to using <a href="http://jekyllbootstrap.com/" target="_blank">Jekyll Bootstrap</a> (<a href="http://jekyllrb.com/" target="_blank">Jekyll</a> + <a href="http://twitter.github.com/bootstrap/" target="_blank">Twitter Bootstrap</a>) hosted by <a href="http://pages.github.com" target="_blank">GitHub</a>.</p>
    <h3>Elsewhere</h3>
    <ul>
      <li><a href="http://omgmog.net">My personal site/portfolio</a></li>
      <li><a href="http://twitter.com/omgmog">@omgmog on Twitter</a></li>
      <li><a href="http://github.com/omgmog">@omgmog on GitHub</a></li>
    </ul>
  </span>
  <span class="span9">
    <div class="latest_post">
      {% for post in site.posts limit:1 %}
        <h4>{{ post.title }}</h4>
        {% if post.cover %}
          <img src="{{ post.cover }}" alt="{{ post.title }}" class="post_cover" width="{% if post.cover_width %}{{ post.cover_width }}{% else %}520px{% endif %}"/>
        {% endif %}
        <p class="post_meta">{{ post.date | date_to_string }}</p>
        {{ post.content }}
      {% endfor %}
    </div>
    <hr />
    <h4>Recently...</h4>
    <ul class="recent_posts">
      {% for post in site.posts limit:4 offset:1 %}
        <li class="{% cycle nil,'margin_left' %}">
          <span>{{ post.date | date_to_string }}</span><br /><a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a>
        </li>
      {% endfor %}
    </ul>
  </span>
</div>