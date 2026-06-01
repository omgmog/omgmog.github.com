---
title: Merge Commits Are Just Noise
comments_issue: 148
tags: [guide, programming, git]
---

Run `git log --graph` on most team projects and you'll see the problem. Parallel lines everywhere, merge commits that just say "Merge branch 'feature/x' into develop". None of it useful. It's noise.

I've been using a rebase-based workflow for years to avoid this. The history stays linear and the diffs stay readable. This post covers both the argument and the specific branch structure I use for team feature work.

<!-- more -->

I use [Git Fork](https://git-fork.com/) as my day-to-day git GUI, so some of this is written from that perspective, but the concepts and CLI equivalents apply whichever git client you use.

## Why rebasing over merging

The standard objection to rebasing is that it rewrites history. What it actually discards is the record of *when you synced with main*, which is rarely useful information to future readers. The commit messages still say what changed and why, and those stay intact.

You get a linear history. The same project with a rebase workflow reads like a changelog.

<div class="inline-grid two-columns">
{% include posts/figure.html src="2026-06/git/merge-heavy.png" %}
{% include posts/figure.html src="2026-06/git/rebase-clean.png" %}
</div>

[git bisect](https://git-scm.com/docs/git-bisect) works properly. Binary searching for a bug-introducing commit is much more reliable on a linear history. Merge commits add noise and make the search harder to follow.

`git blame` is cleaner too. Blame output points to the commit that actually introduced a line.

With rebasing, conflicts come up one commit at a time rather than all at once. That encourages keeping commits small. Smaller commits mean easier code review, and reverts are less painful when you need them. If you find yourself resolving the same conflict repeatedly, [enabling `git rerere`](https://git-scm.com/book/en/v2/Git-Tools-Rerere) can automate that.

There are still cases where merging is the right call. Merging a long-lived release branch back into main is worth recording as a merge commit. The argument for rebasing applies to day-to-day feature work. Long-lived release branches are a different case (and a problem all of their own, but that's a separate post).

Squash merging is another way to keep main clean, but it collapses every commit on the branch into one and throws the individual messages away. That's fine if you don't need the individual commit history, but rebasing keeps those commits intact and you still get the detail.

## The workflow

For parallel feature work I use a three-tier branch structure:

```
main
└─ feature/xyz
   ├─ user1/xyz-backend
   └─ user2/xyz-frontend
```

`main` stays stable. `feature/xyz` is the integration branch for the feature, owned by whoever's leading it. Individual developers branch off that, not off main.

I always branch from the feature branch, not main.

```bash
git checkout feature/xyz
git checkout -b user1/xyz-backend
```

Sub-branch developers rebase on the feature branch regularly. The feature lead keeps the feature branch current with main and announces when they've done so, so everyone knows to update.

```bash
# feature lead
git fetch origin
git rebase origin/main
git push --force-with-lease origin feature/xyz

# sub-branch developers, after the above
git fetch origin
git rebase origin/feature/xyz
```

PRs target `feature/xyz`, not `main`. When the first PR lands, the second developer rebases before their PR goes up for review.

```bash
git rebase origin/feature/xyz
git push --force-with-lease origin user2/xyz-frontend
```

Once the feature is complete, the feature branch gets rebased on main one last time, then merges via PR as a single coherent unit. No `--no-ff` needed. The rebased history is already readable without forcing a merge commit to mark the boundary.

[--force-with-lease](https://git-scm.com/docs/git-push#Documentation/git-push.txt---force-with-leaseltrefnamegt) is safer than `--force` because it refuses to push if someone else has pushed to the branch since you last fetched. On a branch you own it's fine; on anything shared, you announce the rebase first.

Only rebase branches you own. Once someone else has based work on a branch, rebasing it rewrites the history they're working against (they'll need to rebase again before they can push). For shared branches like `feature/xyz`, the feature lead rebases and tells the team, everyone else updates before pushing.

## Interactive rebase

I treat commits as cheap checkpoints while working, not as the finished article. A commit is local until you push, so nobody sees it and it costs nothing. Made some progress? Commit it. Going to make a cup of tea? Commit first. The working copy stays tidy and you can always get back to a known state.

The condition is that you clean up before anyone else sees it. That's what `git rebase -i` is for.

```bash
git rebase -i origin/feature/xyz  # all commits ahead of the upstream branch
git rebase -i HEAD~3               # last 3 commits
git rebase -i abc1234              # everything after a specific commit
```

The editor opens with each commit listed as `pick`. I annotate them:

```
pick de96a62 scaffold payments module
fixup b0ba055 implement stripe integration
fixup 8a7a4cf add payment form
reword accd3f7 add webhook handler
```

`pick` keeps a commit as-is. `fixup` folds it into the one before and discards the message, good for WIP commits and drive-by typo fixes. `squash` does the same but keeps both messages so they can be combined. `reword` keeps the commit but opens the message for editing.

Fork handles this visually, with a draggable list and buttons for each operation rather than a text file. There are keyboard shortcuts too (`p`/`f`/`s`/`r` for the operations, `cmd+up`/`cmd+down` to reorder). One thing to note: Fork lists commits newest-first, the opposite of the CLI editor above.

{% include posts/figure.html src="2026-06/git/rebase.png" %}{:.center}

The result is one or two commits that describe what changed. While working I make commits whenever it's convenient, then tidy them into something readable before the PR goes up. I aim for each commit to represent one coherent change, so sort it before the PR goes up, not during review.

## Common sticking points

A lot of the anxiety around rebasing comes from it feeling irreversible, but it isn't. As long as you committed something locally, [git reflog](https://git-scm.com/docs/git-reflog) gets you back to any previous state.

```bash
git reflog                    # see everywhere HEAD has been
git reset --hard HEAD@{n}     # go back to wherever you need
```

Nothing's lost until git's garbage collection runs, which it does every 90 days by default. If you're nervous about a rebase, create a throwaway branch first:

```bash
git branch backup/xyz-before-rebase
```

It costs nothing and takes a couple of seconds, and you can delete it once you're happy with the rebase. Once people realise commits aren't fragile, the whole model feels less precarious.

`--force-with-lease` needs a bit more explaining. Force pushing anything feels wrong until you think of it in terms of branch ownership, and on a branch you own, it's fine.

One habit that's hard to shift is `git add .`. Selective staging (building commits that represent one coherent idea even when the working copy is messier) is one of git's more useful features and almost invisible to people who've never used it.

The CLI equivalent is [git add -p](https://git-scm.com/docs/git-add), which walks through each changed hunk and asks what to do with it. Fork makes this easier. In the diff view, individual hunks can be staged with a click, and if a hunk is too coarse, individual lines within it can be staged too. In practice this means a messy working copy with three half-finished things in it can still produce three focused commits.
