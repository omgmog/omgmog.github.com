---
title: Chasing build speed on Jekyll 4
comments_issue: 172
tags: [jekyll, css, site-related]
---

I've been putting off upgrading from Jekyll 3.10. Partly late-adopter habit, partly because my setup worked fine, and a version bump seemed simple enough. I should know better by now. It mostly was.

<!-- more -->

I run Jekyll on my NAS, in Docker, with a `Gemfile` shared by the GitHub Pages deploy. I don't use Jekyll's incremental build locally, so every time I saved a post I was writing, Jekyll did a full rebuild before I could preview the change. This year that's added up, the best part of 90 new posts and the site's up to {{ site.posts.size | plus: site.cardboctober.size | plus: site.lwal.size }} files for Jekyll to churn through each time. That wait had crept up to 46 seconds, long enough that I'd lost the thread of what I was writing by the time the page reloaded.

The Gemfile's jekyll version went from `"~> 3.10.0"` to `"~> 4.3"` (resolving to 4.4.1), and the Dockerfile's base image went from `ruby:3.2-slim` to `ruby:3.4-slim` to match what the deploy workflow already uses. Since [moving to GitHub Actions](/post/moving-to-github-actions-and-adding-txt-posts/), the deploy builds the site itself from that same Gemfile, so bumping it locally meant the deploy would pick up Jekyll 4 too, with no separate change needed.

The build fell over while processing my Sass:

```
Conversion error:
  Jekyll::Converters::Scss encountered an error while converting 'assets/eras.scss':
    expected "{".
```

This didn't give me a lot to go on, but I figured it came from the switch from LibSass to Dart Sass that came with `jekyll-sass-converter` 3.x, which this Jekyll 4 upgrade happened to pull in. My stylesheets have been set up in the same way since 2014, with `_sass/` holding the meat of my Sass stylesheets, and `assets/` holding simple stubs that tell Jekyll what to process, for example `assets/eras.scss`:

```scss
---
---
@import "eras";
```

Some of the partials in `_sass/` and stubs in `assets/` had the same filename, and Dart Sass checks the importing file's own directory before it looks anywhere else. So `assets/eras.scss`, asking for `"eras"`, found `assets/eras.scss` sitting right there and imported itself.

Two changes sorted the self-import. I renamed the partials to the proper Sass convention with a leading underscore (so `_sass/eras.scss` became `_sass/_eras.scss`, along with `_core.scss` and `_pygments.scss`), and pointed each entry point at its partial with an explicit relative path. While I was in there, I also switched from `@import` to [the newer `@use` rule](https://sass-lang.com/documentation/breaking-changes/import/), since Dart Sass was warning about `@import`. Here's `assets/eras.scss` after both changes:

```scss
---
---
@use "../_sass/eras";
```

Under `@use`, global functions like `red()`, `green()`, `blue()` and `map-get()` have to come from an explicit module, and division with `/` no longer works either. Under the old `@import`, all of that lived in one shared global namespace, so it just worked without a second thought. Fixing `_core.scss` meant touching every one of those, starting with the three colour functions:

```scss
@use "sass:color";
@use "sass:list";

@function rgb-channels($value) {
  $parts: ();
  @each $channel in "red", "green", "blue" {
    $parts: list.append($parts, color.channel($value, $channel, $space: rgb));
  }
  @return $parts;
}
```

That replaced three near-identical `red()`, `green()` and `blue()` wrappers (and their call sites, which always used all three together to build the `--color-*-rgb` custom properties) with one function. `map-get()` became `map.get()`, and `(1 / $phi) * 1rem` became `math.div(1, $phi) * 1rem`.

That got the build working again, but not fast. Shaving a third off 46 seconds is something, but 29 still isn't nothing, so I went looking for where the rest of the time was going. Back in June, long before this upgrade was even on the cards, I'd [moved the ld+json structured data generation out of a Liquid include and into a Ruby generator plugin](https://github.com/omgmog/omgmog.github.com/commit/9ad4510), and in August I'd [dropped an `--lsi` flag](https://github.com/omgmog/omgmog.github.com/commit/a0a96f0) that wasn't doing anything.

Profiling the new Jekyll 4 build with `--profile` turned up the same shape of problem again, just bigger. A sidebar include was scanning every post on every page just to list five recent ones, and a tag page template was looping all posts per tag when Jekyll already keeps a `site.tags` index. Same fix as before, [moving the expensive, repeated-per-page Liquid work into a Ruby generator](https://github.com/omgmog/omgmog.github.com/commit/3a28cf7) that runs once per build instead of once per page:

```ruby
def generate(site)
  site.data['recent_posts'] = site.posts.docs.sort_by { |p| -p.date.to_i }.first(LIMIT)
end
```

| Setup | Build time |
|-------|------------|
| **Jekyll 3.10, Ruby 3.2** (warm) | 46.1s |
| **Jekyll 4.4.1, Ruby 3.4** (cold, caches cleared) | around 29s |
| **Jekyll 4.4.1** (warm rebuild) | around 11.5s |
{:.massive}

11.5 seconds is still a wait. It's not going to stop me losing the thread entirely. But it's a quarter of what it was, and I'm no longer sat there listening for the click of the NAS's disk as it writes the generated site.
