#!/usr/bin/env python3
"""thread_candidates.py [--views FILE] [--top N]

Reviews the "Pick a thread" choices in _data/starthere.yml against the posts: for each thread's category, the
current picks and the best alternatives, with date, engagement (webmentions from other people + GitHub comments
from anyone but the author) and whether a post starts a series. FILE is optional page views, as CSV (path,views)
or JSON ({path: views}), e.g. exported from Cloudflare. Run from blog/. Engagement here is a plain count, a bit
looser than the site's own tally (no de-duping), which is fine for ranking."""
import argparse, csv, glob, json, os, re, sys, yaml
from collections import defaultdict
from datetime import date

ap = argparse.ArgumentParser()
ap.add_argument("--views"); ap.add_argument("--top", type=int, default=8)
args = ap.parse_args()

wm = json.load(open("_data/webmentions.json"))
gh = json.load(open("_data/github_comments.json"))
views = {}
if args.views:
    if args.views.endswith(".json"):
        views = json.load(open(args.views))
    else:
        for row in csv.reader(open(args.views)):
            if len(row) >= 2 and row[1].replace(",", "").isdigit():
                views[row[0].split("?")[0].rstrip("/") + "/"] = int(row[1].replace(",", ""))
views = {k if k.endswith("/") else k + "/": v for k, v in views.items()}

posts = []
for f in sorted(glob.glob("_posts/*/*.md")):
    m = re.match(r"_posts/\d+/(\d{4})-(\d\d)-(\d\d)-(.+)\.md$", f)
    text = open(f).read()
    fm = yaml.safe_load(text.split("---")[1]) or {}
    url = f"/post/{m.group(4)}/"
    mentions = [x for x in wm.get(url, []) if not x.get("_own")]
    issue = gh.get(str(fm.get("comments_issue")), {}) if fm.get("comments_issue") else {}
    comments = [c for c in issue.get("comments", []) if (c.get("user") or {}).get("login", "").lower() != "omgmog"]
    posts.append(dict(url=url, title=fm.get("title", ""), cat=fm.get("category"), series=fm.get("series"),
                      date=date(int(m.group(1)), int(m.group(2)), int(m.group(3))), eng=len(mentions) + len(comments),
                      views=views.get(url), archived=bool(fm.get("archive"))))

by_series = defaultdict(list)
for p in posts:
    if p["series"]:
        by_series[p["series"]].append(p)
starts = {min(v, key=lambda p: p["date"])["url"] for v in by_series.values() if len(v) > 1}
today = date.today()

def row(p, mark=""):
    age = (today - p["date"]).days / 365
    v = f"{p['views']:>6}" if p["views"] is not None else "     -"
    s = "start of series" if p["url"] in starts else (f"series: {p['series']}" if p["series"] else "")
    return f"  {mark:<2}{p['date']} {age:4.1f}y eng {p['eng']:>2} views {v}  {p['title'][:52]:<52} {s}"

picks = yaml.safe_load(open("_data/starthere.yml"))["threads"]
byurl = {p["url"]: p for p in posts}
for t in picks:
    cat = t["category"]
    chosen = [byurl.get(u) for u in t["posts"]]
    pool = [p for p in posts if p["cat"] == cat and p["url"] not in t["posts"]]
    key = (lambda p: (p["views"] or 0, p["eng"], p["date"])) if views else (lambda p: (p["eng"], p["date"]))
    print(f"\n== {cat}: {len(pool) + len(chosen)} posts ==")
    print(" current picks:")
    for u, p in zip(t["posts"], chosen):
        print(row(p, "*") if p else f"  ? missing: {u}")
    print(" best of the rest" + (" (by views, then engagement)" if views else " (by engagement, then recency)") + ":")
    for p in sorted(pool, key=key, reverse=True)[:args.top]:
        print(row(p))
    recent = [p for p in sorted(pool, key=lambda p: p["date"], reverse=True) if p["date"].year >= today.year - 1][:3]
    if recent:
        print(" most recent:")
        for p in recent:
            print(row(p))
