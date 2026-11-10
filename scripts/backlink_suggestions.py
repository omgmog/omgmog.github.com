#!/usr/bin/env python3
"""backlink_suggestions.py [--top N] [--min SCORE] [--report FILE]

Where could a newer post link back to an older one? Compares post *content* (TF-IDF cosine similarity over the
title, tags and prose, with code, Liquid and markup removed) and lists, for each newer post, the older posts that
have 0-1 inbound internal links (from the build report written by _plugins/backlinks.rb) and that it doesn't
already link to. Each match shows its score and the terms the two posts share. Run from blog/ after a build.
Stdlib plus PyYAML only. Posts and Cardboctober days are compared; LWAL entries are neither sources nor targets."""
import argparse, glob, math, os, re, sys, yaml
from collections import Counter, defaultdict

ap = argparse.ArgumentParser()
ap.add_argument("--top", type=int, default=3, help="matches per newer post")
ap.add_argument("--min", type=float, default=0.18, help="minimum cosine similarity")
ap.add_argument("--table", action="store_true", help="markdown table with the sentence in the newer post that best matches")
ap.add_argument("--report", default=".jekyll-cache/backlinks-report.txt")
args = ap.parse_args()

STOP = set("""a about above after again all also am an and any are as at be because been before being below between both but by
can could did do does doing down during each few for from further had has have having he her here hers him his how i if in into
is it its just me more most my no nor not now of off on once only or other our out over own same she should so some such than that
the their them then there these they this those through to too under until up us very was we were what when where which while who
whom why will with would you your youre ive dont thats theres isnt cant didnt doesnt wasnt like get got use used using one two
make made really still much many even well also thing things way going want need new post blog""".split())


def stem(w):
    for suf in ("ing", "ed", "es", "s", "ly"):
        if w.endswith(suf) and len(w) - len(suf) >= 4:
            return w[: -len(suf)]
    return w


def tokens(text):
    return [stem(w) for w in re.findall(r"[a-z][a-z0-9]{2,}", text.lower()) if w not in STOP]


def clean(body):
    body = re.sub(r"```.*?```", " ", body, flags=re.S)
    body = re.sub(r"\{%.*?%\}|\{\{.*?\}\}", " ", body, flags=re.S)
    body = re.sub(r"<!--.*?-->|<[^>]+>", " ", body, flags=re.S)
    body = re.sub(r"`[^`]*`|https?://\S+|!?\[([^\]]*)\]\([^)]*\)", r" \1 ", body)
    return body


docs = {}
for coll, base in (("posts", "_posts"), ("cardboctober", "_cardboctober")):
    for f in glob.glob(f"{base}/**/*.md", recursive=True):
        m = re.match(r"(\d{4}-\d{2}-\d{2})-(.+)\.md$", os.path.basename(f))
        text = open(f, encoding="utf8").read()
        fm = re.match(r"---\n(.*?)\n---\n?(.*)", text, re.S)
        if not m or not fm:
            continue
        meta = yaml.safe_load(fm.group(1)) or {}
        slug = meta.get("slug") or m.group(2)
        url = f"/post/{slug}/" if coll == "posts" else f"/cardboctober/{slug}/"
        title = str(meta.get("title", slug))
        body = clean(fm.group(2))
        words = tokens(title) * 3 + tokens(" ".join(meta.get("tags") or [])) * 2 + tokens(body)
        docs[url] = {"date": m.group(1), "title": title, "tf": Counter(words), "raw": fm.group(2), "file": f}

# Posts with 0-1 inbound internal links, from the build report (first section).
low = {}
for line in open(args.report, encoding="utf8"):
    if not line.strip():
        break
    p = line.split("  ", 3)
    if len(p) == 4 and p[0].isdigit():
        low[p[2]] = int(p[0])

df = Counter(w for d in docs.values() for w in d["tf"])
N = len(docs)
for d in docs.values():
    vec = {w: (1 + math.log(c)) * math.log(N / df[w]) for w, c in d["tf"].items() if df[w] < N * 0.5}
    norm = math.sqrt(sum(v * v for v in vec.values())) or 1
    d["vec"] = {w: v / norm for w, v in vec.items()}


def links_to(src, target):
    slug = target.strip("/").split("/")[-1]
    raw = docs[src]["raw"]
    return (re.search(r"/(post|cardboctober)/" + re.escape(slug) + r"/?[)\"'#\s]", raw) is not None
            or re.search(r"post_url\s+[\w/-]*" + re.escape(slug) + r"\s*%\}", raw) is not None)  # {% post_url 2026/2026-06-11-slug %}


out = defaultdict(list)
for su, s in docs.items():
    if not su.startswith("/post/"):
        continue
    for tu, t in docs.items():
        if tu == su or tu not in low or t["date"] >= s["date"] or links_to(su, tu):
            continue
        shared = {w: s["vec"][w] * t["vec"][w] for w in s["vec"].keys() & t["vec"].keys()}
        score = sum(shared.values())
        if score >= args.min:
            why = ", ".join(w for w, _ in sorted(shared.items(), key=lambda kv: -kv[1])[:4])
            out[su].append((score, tu, why))

def best_sentence(su, tu):
    """The sentence in the newer post whose words overlap most with the older post's distinctive terms."""
    t = docs[tu]["vec"]
    best, best_score = "", 0
    prose = "\n".join(l for l in docs[su]["raw"].splitlines() if not re.match(r"\s*(\||\{:|-{3,}|\d+\.\s|[-*]\s)", l))
    prose = re.sub(r"^#+\s*", "", clean(prose), flags=re.M)
    for sent in re.split(r"(?<=[.!?])\s+|\n+", re.sub(r"[ \t]+", " ", prose)):
        if not 40 <= len(sent) <= 400:
            continue
        sc = sum(t.get(w, 0) for w in set(tokens(sent)))
        if sc > best_score:
            best, best_score = sent.strip(), sc
    return best


shown = 0
if args.table:
    print("| from | to | score | shared terms | best-matching sentence in the newer post |\n|---|---|---|---|---|")
    for su in sorted(out, key=lambda u: docs[u]["date"], reverse=True):
        for score, tu, why in sorted(out[su], reverse=True)[: args.top]:
            sent = best_sentence(su, tu).replace("|", "/")
            print(f"| {su} | {tu} | {score:.2f} | {why} | {sent} |")
    sys.exit(0)
for su in sorted(out, key=lambda u: docs[u]["date"], reverse=True):
    print(f"{docs[su]['date']}  {su}  {docs[su]['title']}")
    for score, tu, why in sorted(out[su], reverse=True)[: args.top]:
        print(f"    -> {score:.2f}  {docs[tu]['date']}  {tu}  {docs[tu]['title']}  ({low[tu]} inbound; {why})")
        shown += 1
print(f"\n{len(out)} newer posts, {shown} suggestions (min score {args.min})", file=sys.stderr)
