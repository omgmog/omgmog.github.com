// Refresh button under Discussion: fetches anything newer than the build from webmention.io and GitHub and
// adds it to the page. The display rules mirror _plugins/webmention_policy.rb and posts/discussion-item.html:
// keep them in step.
(() => {
  "use strict";
  const root = document.getElementById("discussion");
  const btn = root?.querySelector(".discussion-refresh");
  if (!btn) return;

  const d = root.dataset;
  // The lists come from _data/webmention_policy.yml, via the data-policy attribute.
  let policy;
  try {
    policy = JSON.parse(d.policy);
  } catch (e) {
    return;
  }
  const targets = (d.targets || "").split("|").filter(Boolean);
  const issue = d.issue;
  const AUTHOR = d.author || "";
  const syndicated = new Set((d.syndication || "").split("|").map((u) => normUrl(u)).filter(Boolean));
  const seenWm = new Set((d.wmIds || "").split(",").filter(Boolean));
  const seenGh = new Set((d.ghIds || "").split(",").filter(Boolean));
  let counts = {};
  try {
    counts = JSON.parse(d.counts || "null") || {};
  } catch (e) {}

  const timeEl = root.querySelector(".discussion-fetched__time");
  const statusEl = root.querySelector(".discussion-fetched__status");

  // ---- policy (mirrors WebmentionPolicy) -------------------------------------------------------------
  const OWN = policy.own_markers;
  const SILO = policy.silo_hosts;
  const REACTIONS = policy.reactions;
  const FEDI = new RegExp(`^/(?:${policy.fediverse_path})/?$`);
  const ALLOWED = new Set(policy.allowed_tags);
  const SAFE_URL = new RegExp(`^(?:${policy.safe_url})`, "i");

  function hostOf(u) {
    try {
      return new URL(u).hostname.toLowerCase();
    } catch (e) {
      return "";
    }
  }
  function normUrl(u) {
    try {
      const x = new URL(String(u).trim());
      return x.hostname.toLowerCase() + x.pathname.replace(/\/$/, "") + x.search;
    } catch (e) {
      return null;
    }
  }
  const siloHost = (h) => !!h && (h.split(".").includes("lemmy") || SILO.some((s) => h === s || h.endsWith("." + s)));
  const fediUrl = (u) => {
    try {
      return FEDI.test(new URL(u).pathname);
    } catch (e) {
      return false;
    }
  };
  const own = (m) => [m.author?.url, m["wm-source"]].some((s) => OWN.some((o) => (s || "").includes(o)));
  const silo = (m) => [m["wm-source"], m.url].some((u) => siloHost(hostOf(u)) || fediUrl(u));
  const mode = (m) => (own(m) || !silo(m) ? "full" : REACTIONS.includes(m["wm-property"]) ? "count" : "link");
  const sharedLink = (m) => {
    const src = (m.url || "") + (m["wm-source"] || "");
    if (m["wm-property"] === "bookmark-of") return /reddit\.com\/r\/|news\.ycombinator\.com/i.test(src);
    if (m["wm-property"] === "repost-of") return /lobste\.rs/i.test(src);
    return false;
  };
  const pointer = (m) => {
    if (sharedLink(m)) return true;
    if (m["wm-property"] !== "mention-of") return false;
    if (m.community) return true;
    const md = mode(m);
    return md === "link" || (md === "full" && !own(m) && m.content?.text == null);
  };

  // ---- small helpers ---------------------------------------------------------------------------------
  const esc = (v) =>
    String(v ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]);
  const fmtDate = (v) => {
    const t = new Date(v);
    return isNaN(t) ? "" : t.toLocaleDateString("en-GB", { day: "numeric", month: "long", year: "numeric" });
  };
  const hue = (name) => Array.from(new TextEncoder().encode(name || "")).reduce((h, b) => (h * 31 + b) % 360, 7);
  const initials = (name) => {
    const words = (name || "").trim().split(/\s+/).filter(Boolean);
    if (!words.length) return "?";
    const named = words.filter((w) => /^[\p{L}\p{N}]/u.test(w));
    const picks = named.length >= 2 ? [named[0], named[named.length - 1]] : [words[0]];
    const first = (s) => ("Segmenter" in Intl ? [...new Intl.Segmenter().segment(s)][0]?.segment : Array.from(s)[0]);
    return picks.map(first).join("").toUpperCase();
  };
  // Same rules as the sanitize_content_html filter: unwrap anything not allowed, drop every attribute
  // except a safe href/src. Built as a string from text nodes, never by copying attributes across.
  const sanitize = (html) => {
    const walk = (node) =>
      [...node.childNodes]
        .map((n) => {
          if (n.nodeType === 3) return esc(n.textContent);
          if (n.nodeType !== 1) return "";
          const tag = n.tagName.toLowerCase();
          if (!ALLOWED.has(tag)) return walk(n);
          if (tag === "img") {
            const src = n.getAttribute("src") || "";
            return SAFE_URL.test(src) ? `<img src="${esc(src)}" alt="${esc(n.getAttribute("alt"))}" loading="lazy">` : "";
          }
          if (tag === "a") {
            const href = n.getAttribute("href") || "";
            return SAFE_URL.test(href) ? `<a href="${esc(href)}" rel="nofollow">${walk(n)}</a>` : `<a>${walk(n)}</a>`;
          }
          return `<${tag}>${walk(n)}</${tag}>`;
        })
        .join("");
    return walk(new DOMParser().parseFromString(html || "", "text/html").body);
  };
  const paragraphs = (text) =>
    String(text || "")
      .split(/\n{2,}/)
      .map((p) => `<p>${esc(p.trim()).replace(/\n/g, "<br>")}</p>`)
      .join("");
  const truncate = (text, n = 60) => {
    const w = String(text || "").trim().split(/\s+/);
    return w.length > n ? w.slice(0, n).join(" ") + "…" : w.join(" ");
  };

  const PLATFORMS = { mastodon: "Mastodon", bluesky: "Bluesky", reddit: "Reddit", hackernews: "Hacker News", lemmy: "Lemmy", lobsters: "Lobsters", twitter: "Twitter", github: "GitHub" };
  function platformOf(m, url) {
    if (url.includes("reddit.com")) return "reddit";
    if (url.includes("news.ycombinator.com")) return "hackernews";
    if (url.includes("lobste.rs")) return "lobsters";
    if (url.includes("bsky.app")) return "bluesky";
    if (url.includes("twitter.com") || url.includes("x.com")) return "twitter";
    if (url.includes("lemmy") || m.community) return "lemmy";
    if ((m["wm-source"] || "").includes("brid.gy") || url.includes("mastodon") || url.includes("indieweb.social")) return "mastodon";
    return "website";
  }
  const avatar = (name, isAuthor, extra = "") =>
    isAuthor
      ? `<span class="discussion-avatar discussion-avatar--author ${extra}"><img src="${esc(d.avatar)}" alt="" width="36" height="36"></span>`
      : `<span class="discussion-avatar ${extra}" style="background: hsl(${hue(name)}, 55%, 40%)">${esc(initials(name))}</span>`;
  const byline = ({ name, url, isAuthor, platform, label, date, dateUrl }) =>
    `<p class="discussion-item__byline">` +
    (url ? `<a href="${esc(url)}" rel="nofollow" class="discussion-item__name">${esc(name)}</a>` : `<span class="discussion-item__name">${esc(name)}</span>`) +
    (isAuthor ? `<span class="discussion-item__author-pill">Author</span>` : "") +
    `<span class="discussion-item__platform"><span class="discussion-item__platform-dot" data-platform="${platform}"></span>${PLATFORMS[platform] || "Website"}</span>` +
    `<span class="meta">${esc(label)} &middot; ${dateUrl ? `<a href="${esc(dateUrl)}" rel="nofollow">${esc(date)}</a>` : esc(date)}</span></p>`;

  // ---- one discussion item (mirrors posts/discussion-item.html) --------------------------------------
  function mentionItem(m) {
    const url = m.url || m["wm-source"] || "";
    const date = m.published || m["wm-received"];
    const domain = hostOf(url);
    const isAuthor = own(m);
    const name = isAuthor ? AUTHOR : m.author?.name || domain;
    const platform = platformOf(m, url);
    const prop = m["wm-property"];

    if (pointer(m) || mode(m) === "link") {
      let what = prop === "in-reply-to" ? "Reply on" : "Mentioned on";
      let label = domain;
      if (prop === "repost-of" && platform === "lobsters") [what, label] = ["Shared on", "Lobsters"];
      else if (prop === "bookmark-of" && platform === "reddit") [what, label] = ["Shared on", "r/" + (url.split("/r/").pop().split("/")[0] || "")];
      else if (prop === "bookmark-of" && platform === "hackernews") [what, label] = ["Shared on", "Hacker News"];
      else if (m.community) [what, label] = ["Shared on", `!${m.community.name}@${hostOf(m.community.url)}`];
      return `<li class="discussion-item discussion-item--compact" data-platform="${platform}"><span class="discussion-item__dot"></span>` +
        `<p>${what} ${esc(label)} <span class="meta">&middot; <a href="${esc(url)}" rel="nofollow">${esc(fmtDate(date))}</a></span></p></li>`;
    }
    if (prop === "mention-of" && !m.content?.text && !m.summary?.value) {
      return `<li class="discussion-item discussion-item--compact" data-platform="${platform}"><span class="discussion-item__dot"></span>` +
        `<p><strong>${esc(name)}</strong> shared this on ${esc(domain)} <span class="meta">&middot; <a href="${esc(url)}" rel="nofollow">${esc(fmtDate(date))}</a></span></p></li>`;
    }
    const html = m.content?.html;
    const body = m.summary?.value
      ? paragraphs(m.summary.value)
      : html && html.length <= 1000
        ? sanitize(html)
        : paragraphs(truncate(m.content?.text));
    return `<li class="discussion-item${isAuthor ? " discussion-item--author" : ""}" data-platform="${platform}">${avatar(name, isAuthor)}` +
      `<div class="discussion-item__body">${byline({ name, url: m.author?.url || url, isAuthor, platform, label: domain, date: fmtDate(date), dateUrl: url })}` +
      `<div class="discussion-item__content">${body}</div></div></li>`;
  }

  function githubItem(c) {
    const isAuthor = (c.user?.login || "").toLowerCase() === policy.github_login;
    const name = isAuthor ? AUTHOR : c.user?.login || "";
    const num = (c.html_url || "").split("/issues/").pop().split("#")[0];
    return `<li class="discussion-item${isAuthor ? " discussion-item--author" : ""}" data-platform="github">${avatar(name, isAuthor)}` +
      `<div class="discussion-item__body">${byline({ name, url: c.user?.html_url, isAuthor, platform: "github", label: `GitHub issue #${num}`, date: fmtDate(c.created_at), dateUrl: c.html_url })}` +
      `<div class="discussion-item__content">${c.body_html || paragraphs(c.body)}</div></div></li>`;
  }

  // ---- page updates ----------------------------------------------------------------------------------
  const TYPES = [
    { prop: "like-of", key: "likes", noun: "like", icon: "icon-heart" },
    { prop: "repost-of", key: "reposts", noun: "repost", icon: "icon-repeat-2" },
    { prop: "bookmark-of", key: "bookmarks", noun: "bookmark", icon: "icon-bookmark" },
  ];

  // The people who reacted from their own sites, as the build listed them.
  const people = Object.fromEntries(TYPES.map((t) => [t.prop, []]));
  root.querySelectorAll(".reaction-group").forEach((g) => {
    g.querySelectorAll(".reaction-group__people li").forEach((li) =>
      people[g.dataset.type]?.push({ name: li.title, own: li.dataset.own === "1" }),
    );
  });

  // Reactions: one group per kind, with the total (which includes the ones that are counted but never
  // listed) and the avatars of the people who reacted from their own sites. Mirrors the markup in post.html.
  function renderReactions() {
    const groups = TYPES.map((t) => {
      const list = people[t.prop];
      const total = Math.max(counts[t.key] || 0, list.length);
      if (!total) return "";
      return `<div class="reaction-group" data-type="${t.prop}"><span class="reaction-group__count"><svg aria-hidden="true"><use href="#${t.icon}"/></svg> ${total} ${t.noun}${total === 1 ? "" : "s"}</span>` +
        (list.length
          ? `<ul class="reaction-group__people" role="list">${list.map((p) => `<li title="${esc(p.name)}" data-own="${p.own ? 1 : ""}">${avatar(p.name, p.own, "discussion-avatar--sm")}</li>`).join("")}</ul>`
          : "") +
        `</div>`;
    }).join("");
    let bar = root.querySelector(".discussion-reactions-bar");
    if (!groups) return bar?.remove();
    if (!bar) {
      bar = document.createElement("div");
      bar.className = "discussion-reactions-bar";
      root.querySelector("h2").after(bar);
    }
    bar.innerHTML = groups;
  }

  function addToFeed(html, dateValue) {
    let feed = root.querySelector(".discussion-feed");
    if (!feed) {
      root.querySelector(".discussion-none")?.remove();
      feed = document.createElement("ul");
      feed.className = "discussion-feed";
      feed.setAttribute("role", "list");
      root.querySelector(".discussion-reply").before(feed);
    }
    const year = new Date(dateValue).getFullYear();
    const last = [...feed.querySelectorAll(".discussion-year")].pop();
    if (!last || last.textContent.trim() !== String(year)) {
      feed.insertAdjacentHTML("beforeend", `<li class="discussion-year" role="presentation"><span class="discussion-year__dot"></span>${year}<span class="discussion-year__rule"></span></li>`);
    }
    feed.insertAdjacentHTML("beforeend", html);
    // Same as the build: links to other sites open in a new tab and aren't vouched for
    feed.querySelectorAll("a[href]").forEach((a) => {
      if (/^https?:/.test(a.href) && a.host !== location.host) {
        a.target = "_blank";
        a.rel = "nofollow noopener";
      }
    });
  }

  // ---- fetch -----------------------------------------------------------------------------------------
  async function fetchMentions() {
    const q = targets.map((t) => `target[]=${encodeURIComponent(t)}`).join("&");
    const r = await fetch(`https://webmention.io/api/mentions.jf2?${q}&per-page=1000`, { cache: "no-store" });
    if (!r.ok) throw new Error("webmention.io " + r.status);
    return (await r.json()).children || [];
  }
  async function fetchComments() {
    if (!issue) return [];
    const r = await fetch(`https://api.github.com/repos/omgmog/omgmog.github.com/issues/${issue}/comments`, {
      headers: { Accept: "application/vnd.github.v3.full+json" },
      cache: "no-store",
    });
    if (!r.ok) throw new Error("GitHub " + r.status);
    return r.json();
  }

  async function refresh() {
    btn.disabled = true;
    btn.setAttribute("aria-busy", "true");
    statusEl.textContent = "";
    const failed = [];
    const [wm, gh] = await Promise.all([
      fetchMentions().catch(() => (failed.push("webmention.io"), [])),
      fetchComments().catch(() => (failed.push("GitHub"), [])),
    ]);
    const added = [];

    wm.filter((m) => m["wm-id"] && !seenWm.has(String(m["wm-id"])))
      .filter((m) => !(["in-reply-to", "mention-of"].includes(m["wm-property"]) && [m.url, m["wm-source"]].some((u) => syndicated.has(normUrl(u)))))
      .sort((a, b) => String(a["wm-received"]).localeCompare(String(b["wm-received"])))
      .forEach((m) => {
        seenWm.add(String(m["wm-id"]));
        const prop = m["wm-property"];
        if (REACTIONS.includes(prop) && !sharedLink(m)) {
          const key = { "like-of": "likes", "repost-of": "reposts", "bookmark-of": "bookmarks" }[prop];
          counts[key] = (counts[key] || 0) + 1;
          if (mode(m) === "full") {
            const mine = own(m);
            people[prop].push({ name: mine ? AUTHOR : m.author?.name || hostOf(m.url || m["wm-source"]), own: mine });
          }
          added.push(m);
        } else if (["in-reply-to", "mention-of"].includes(prop) || sharedLink(m)) {
          addToFeed(mentionItem(m), m.published || m["wm-received"]);
          added.push(m);
        }
      });

    gh.filter((c) => !seenGh.has(String(c.id))).forEach((c) => {
      seenGh.add(String(c.id));
      addToFeed(githubItem(c), c.created_at);
      added.push(c);
    });

    if (added.length) {
      renderReactions();
    }
    const now = new Date();
    timeEl.textContent = `${fmtDate(now)}, ${now.toLocaleTimeString("en-GB", { hour: "2-digit", minute: "2-digit" })}`;
    statusEl.textContent = failed.length
      ? ` Couldn't reach ${failed.join(" or ")}.`
      : added.length
        ? ` ${added.length} new.`
        : " Nothing new.";
    btn.disabled = false;
    btn.removeAttribute("aria-busy");
  }

  btn.addEventListener("click", refresh);
})();
