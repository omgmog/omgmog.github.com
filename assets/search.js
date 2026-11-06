// Search page: queries the Pagefind index (built after Jekyll, see scripts/search_index.sh) and lists matches as post rows.
const input = document.getElementById("q");
const list = document.getElementById("search-results");
const status = document.getElementById("search-status");
const empty = document.getElementById("search-empty");
const cats = JSON.parse(list.dataset.cats);
const MAX = 30;

// Show something straight away: loading the engine and index is the slow part of a first search.
if (new URLSearchParams(location.search).get("q")) { say("busy", "Searching\u2026"); empty.hidden = true; }

let pagefind;
try {
  pagefind = await import("/pagefind/pagefind.js");
  pagefind.init();   // start fetching the wasm and index now rather than on the first keystroke
} catch {
  say("done", "Search isn't available here: the index hasn't been built.");
  input.disabled = true;
}

// state: "busy" (spinner), "done" (result count) or "" (nothing to say)
function say(state, ...parts) {
  status.dataset.state = state;
  status.replaceChildren(...parts);
}
const bold = (t) => Object.assign(document.createElement("b"), { textContent: t });

const esc = (s) => s.replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);

// Pagefind also returns loose "similar word" matches (it matched "sausages" to "2xSaI"). Keep a result only if a
// highlighted word in its excerpt shares the first few letters with a search term. Loose matches rank last, so we
// load results in batches and stop at the first batch that contains one.
const BATCH = 30;
const LIMIT = 120;
const words = (s) => s.toLowerCase().match(/[\p{L}\p{N}]+/gu) || [];
function genuine(d, terms) {
  const marked = [...d.excerpt.matchAll(/<mark>(.*?)<\/mark>/g)].flatMap((m) => words(m[1]));
  return marked.some((w) => terms.some((t) => {
    const k = Math.min(4, t.length);   // a marked word shorter than that can't be a match for this term
    return w.length >= k && w.slice(0, k) === t.slice(0, k);
  }));
}

async function run(q) {
  if (!q.trim()) { list.replaceChildren(); empty.hidden = false; say(""); return; }
  if (!list.children.length) say("busy", "Searching\u2026");
  const search = await pagefind.debouncedSearch(q);
  if (!search) return;   // superseded by a newer keystroke
  const terms = words(q);
  const hits = [];
  let loaded = 0;
  while (loaded < Math.min(search.results.length, LIMIT)) {
    const batch = await Promise.all(search.results.slice(loaded, loaded + BATCH).map((r) => r.data()));
    loaded += batch.length;
    const good = batch.filter((d) => genuine(d, terms));
    hits.push(...good);
    if (good.length < batch.length || hits.length >= MAX) break;
  }
  const more = loaded < search.results.length && hits.length >= MAX;   // stopped early with real results still unseen
  const n = more ? search.results.length : hits.length;
  empty.hidden = n > 0;
  list.replaceChildren();   // swap results only once the new ones are ready, so typing doesn't flash an empty list
  const term = `\u201c${q.trim()}\u201d`;
  if (n === 0) say("done", "Nothing found for ", bold(term), ". Try fewer or different words.");
  else say("done", bold(n), ` result${n === 1 ? "" : "s"} for `, bold(term), n > MAX ? `, showing the first ${MAX}` : "");
  for (const d of hits.slice(0, MAX)) {
    const date = d.meta.date ? new Date(d.meta.date).toLocaleDateString("en-GB", { day: "numeric", month: "long", year: "numeric" }) : "";
    const li = document.createElement("li");
    const cat = cats[d.meta.category] || { name: "", colour: "", ink: "" };
    li.className = "post-item";
    li.style.setProperty("--cat", cat.colour);
    li.innerHTML = `<span class="badge" style="--badge-bg: ${esc(cat.colour)}; --badge-ink: ${esc(cat.ink)}"><svg aria-hidden="true"><use href="#icon-cat-${esc(d.meta.category || "")}"/></svg></span>`
      + `<div class="post-item__body"><a class="post-item__title" href="${esc(d.url)}">${esc(d.meta.title || d.url)}</a>`
      + `<p class="post-item__excerpt">${d.excerpt}</p>`   // Pagefind's excerpt: escaped text with <mark> around matches
      + `<span class="meta">${esc(cat.name)}${date ? " &bull; " + date : ""}</span></div>`;
    list.append(li);
  }
}

if (pagefind) {
  input.focus();   // not `autofocus`: with no index the field is disabled and would flash its focus ring
  const sync = () => {
    const q = input.value;
    history.replaceState(null, "", q ? `?q=${encodeURIComponent(q)}` : location.pathname);
    run(q);
  };
  input.addEventListener("input", sync);
  empty.addEventListener("click", (e) => {   // suggested searches fill the box instead of reloading the page
    const chip = e.target.closest("[data-q]");
    if (!chip) return;
    e.preventDefault();
    input.value = chip.dataset.q;
    input.focus();
    sync();
  });
  input.value = new URLSearchParams(location.search).get("q") || "";
  run(input.value);
}
