---
title: The Movies I Watched in 2022
tags: [data, guide]
comments_issue: 118
syndication: 
- https://social.omgmog.net/2023/i-finally-got-around-to-publishing-a
- https://indieweb.social/@omgmog/109784861736204017
- https://www.linkedin.com/posts/omgmog_the-movies-i-watched-in-2022-the-blog-of-activity-7026847479715246081-Pflh
---

Through 2022 I kept track of most the movies I watched. In this post I'll talk about how I took that data and, combined with the OMDb API, used the data with Jekyll.

<!-- more -->

I'm subscribed to Amazon Prime Video, Netflix and Disney Plus. The movies I watched show a good mix of all of these services. I found that I would more often use Netflix or Disney Plus when choosing movies to watch with my wife, and Amazon Prime Video for movies that I watched on my own. I watched only one movie at the cinema (The Batman).

Each time I watched a movie, I added an entry to a list in [Notion](https://www.notion.so). Later on I went through the list and manually got the IMDB movie ID for each movie. I didn't record ratings or anything, but it was interesting to me to be able to reference a list when suggesting movies to friends and family.

It looks like I didn't watch any movies in January or October -- this is probably right! In January my son was born, and in October we had a holiday.

In 2023 I'm considering tracking all of the series I watch too.

## Presenting a list of movies

To put this post together I've used the [OMDb API](https://omdbapi.com) to gather movies details and posters. OMDb provides a simple endpoint that you can pass either a title or IMDB movie ID to and in return get a bunch of data back.

For example you can get the JSON formatted data for a specific movie using it's IMDB movie ID and save that to a file using cURL:

```shell
curl -o _data/movies/2022/tt10298810.json -L -O "https://www.omdbapi.com/?apikey=<API KEY>&i=tt10298810"
```

This will give you the following:

```json
{{ site.data.movies['2022']['tt10298810'] | jsonify }}
```

I then took that JSON into Jekyll. Outputting to the `_data/movies/2022/*.json` path exposes this to Jekyll's data like this:

```liquid
site.data.movies['2022']['tt10298810']
```

Where you can then read the content, or access any of the properties:

```liquid
site.data.movies['2022']['tt10298810'].Plot => "{{ site.data.movies['2022']['tt10298810'].Plot }}"
```

You can easily grab a copy of the movie poster in a similar way:

```shell
curl -o tt10298810.jpg -L -O "https://img.omdbapi.com/?apikey=<API KEY>&i=tt10298810"
```

I'm currently storing the list of movies and the date I watched them in a data file at `_data/movies/2022/index.yml`. I loop through that list, and then pull in the further movie data from the OMDb JSON files I grabbed earlier (`_data/movies/2022/*.json`). Once I had all of the movie data from OMDb I wrote a bunch of convoluted Jekyll/Liquid logic in this post to render it as you see below.

{% assign movies = site.data.movies['2022']['index'] %}
{% assign movie_data = site.data.movies['2022'] %}

{%- capture elapsed_watch_time_mins -%}{% assign total = 0 %}{% for movie in movies %}{% assign mins = movie_data[movie.id].Runtime | plus:0 %}{% assign total = total | plus:mins %}{% endfor %}{{ total }}{%- endcapture -%}
{% assign elapsed_watch_time_hours_and_remainder = elapsed_watch_time_mins | divided_by:60.0 %}
{% assign elapsed_watch_time_hours = elapsed_watch_time_hours_and_remainder | split:'.' | first %}
{% assign elapsed_watch_time_remainder = elapsed_watch_time_hours_and_remainder | split:'.' | last | slice:0,2 %}
{% assign elpased_watch_time_remainder_mins = 60 | divided_by: 100.0 | times: elapsed_watch_time_remainder | floor %}

With all of the data collected I can do stuff like calculate the amount of time spent watching films in 2022 ({{ elapsed_watch_time_hours }}h {{ elpased_watch_time_remainder_mins }}m) 🤷‍♂️

Enough of the technical mumbo jumbo... Here's the list of movies I watched in 2022:


{% assign prev_month = "" %}
{% for movie in movies %}
{% assign month = movie.date | date:"%B" %}
{% if month != prev_month %}
{% unless forloop.index0 == 0 %}
</div>
{% endunless %}
{% assign prev_month = month %}
<h3>{{ month }}</h3>
<div class="posters-wrap">
{% endif %}
{% assign filename = "movies/"|append:movie.id|append:".jpg" %}
{% assign title = movie_data[movie.id].Title | append:" (" | append:movie_data[movie.id].Year | append:")" %}
{% capture genre %}<b>Genre: </b>{{ movie_data[movie.id].Genre | split:' ' | join:'' | split:',' | uniq | sort | join:'/' }}<br><br>{% endcapture %}
{% capture plot %}<em>{{ movie_data[movie.id].Plot }}</em><br><br>{% endcapture %}
{% capture ratings %}{% for rating in movie_data[movie.id].Ratings %}<b>{{rating.Source}}:</b> {{rating.Value}}<br>{% endfor %}{% endcapture %}
{% assign blurb = genre | append:plot | append:ratings  %}
{% include posts/figure.html src=filename type="image-with-blurb" title=title blurb=blurb %}
{% endfor %}
