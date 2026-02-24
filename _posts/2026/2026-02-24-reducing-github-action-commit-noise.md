---
title: Reducing commit log noise caused by a GitHub Action
comments_issue: 139
tags: [jekyll, github-actions, guide]
---

I have a "now playing" widget on my [/now page](/now) that shows the last track scrobbled to Last.fm. It's powered by a [GitHub Actions workflow](https://github.com/omgmog/omgmog.github.com/blob/main/.github/workflows/lastfm.yml) that polls the Last.fm API every hour and commits the result to the repo. It worked fine, but quietly polluted my commit history.

<!-- more -->

## The setup

A scheduled action runs every hour, fetches my most recent track via the Last.fm API, and writes it to `_data/now/lastfm.json`. If the track changes, it commits the file and pushes, triggering a Jekyll build and redeploy.

```yaml
- name: Commit changes
  run: |
    git config user.name "github-actions"
    git config user.email "actions@github.com"
    git add _data/now/lastfm.json
    if git diff --staged --quiet; then
      echo "No change"
    else
      git commit -m "Update Last.fm now playing"
      git push
    fi
```

The script only writes to disk when something actually changes (track name, artist, or now-playing status), so most hourly runs are no-ops. But when I'm listening to music, each track change produced a new commit. After a few months the log looked like this:

```
d3e220d post about my home nas
a051ecf Update Last.fm now playing
c2d9699 Update Last.fm now playing
5eb6c17 Update Last.fm now playing
9644ed6 Update Last.fm now playing
e4dca4d Update Last.fm now playing
b4c5fba limit the feed to 25 posts
```

142 Last.fm commits across 1091 total. Roughly one in eight commits was noise.

## Fixing it going forward

The solution was to make the workflow amend the previous Last.fm update commit, instead of creating a new commit each time. That leaves at most one Last.fm commit between real ones:

```yaml
- name: Checkout repo
  uses: actions/checkout@v4
  with:
    fetch-depth: 0

- name: Commit changes
  id: commit
  run: |
    git config user.name "github-actions"
    git config user.email "actions@github.com"
    git add _data/now/lastfm.json
    if git diff --staged --quiet; then
      echo "changed=false" >> $GITHUB_OUTPUT
    else
      if [ "$(git log -1 --pretty=%s)" = "Update Last.fm now playing" ]; then
        git commit --amend --no-edit
        git push --force-with-lease
      else
        git commit -m "Update Last.fm now playing"
        git push
      fi
      echo "changed=true" >> $GITHUB_OUTPUT
    fi
```

`fetch-depth: 0` is important here. [`actions/checkout@v4`](https://github.com/actions/checkout) does a shallow clone by default (depth 1), and force-pushing a shallow clone replaces the entire remote history with a single commit. I found this out the hard way.

`--force-with-lease` makes the push fail if something else landed on `main` in the meantime, rather than silently overwriting it.

## Cleaning up the existing history

The workflow change stopped the bleeding, but there were still 142 commits in the log. I wanted to collapse each run of consecutive Last.fm commits into one.

`git rebase -i` is the usual tool for this, but editing 190 lines of a rebase todo by hand wasn't appealing. I set `GIT_SEQUENCE_EDITOR` to a small Python script that rewrites the todo:

```python
#!/usr/bin/env python3
import sys

todo_file = sys.argv[1]
with open(todo_file) as f:
    lines = f.readlines()

out = []
prev_was_lastfm = False
for line in lines:
    stripped = line.strip()
    if not stripped or stripped.startswith('#'):
        out.append(line)
        continue
    parts = stripped.split(' ', 2)
    action, sha = parts[0], parts[1]
    msg = parts[2] if len(parts) > 2 else ''
    is_lastfm = msg == 'Update Last.fm now playing'
    if is_lastfm and prev_was_lastfm:
        out.append(line.replace(action, 'fixup', 1))
    else:
        out.append(line)
    prev_was_lastfm = is_lastfm

with open(todo_file, 'w') as f:
    f.writelines(out)
```

It reads through the rebase todo in order. The first Last.fm commit in a consecutive run stays as `pick`. Every subsequent one becomes `fixup`, folding it into the previous commit and discarding its message. Any non-Last.fm commit breaks the run.

I ran it from just before the [oldest Last.fm commit](https://github.com/omgmog/omgmog.github.com/commit/a1aaf39e):

```bash
GIT_SEQUENCE_EDITOR="python3 /tmp/squash_lastfm.py" git rebase -i a1aaf39e
```

1091 commits became 969. 142 Last.fm commits became 20, one per cluster. Then a force push:

```bash
git push --force-with-lease
```

The log now looks like it should:

```
e35e061 Update Last.fm now playing
b4c5fba limit the feed to 25 posts
fc050f2 also highlight the nav when viewing archive page
...
4fdfec4 Update Last.fm now playing
adc03e8 Improve feed.xml
```