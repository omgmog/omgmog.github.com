#!/usr/bin/env node
// Draws the social (Open Graph) image for every post, 1200x630, from the design in the omgmog.net design board.
//
//   node scripts/og-images.mjs [--site _site] [--out _site/images/og] [--cache .cache/og] [--only slug,slug]
//
// Reads <site>/og-manifest.json (made by Jekyll), writes <out>/<slug>.png and default.png (CI: into the built site).
// For local work, where _site belongs to the dev container, use --out images/og: Jekyll serves that folder. Only
// images whose inputs changed are drawn; the rest come from the cache directory, which CI keeps between runs.
// Needs Chrome or Chromium (CHROME=/path, else the usual names are tried). Fonts, the avatar and the icons come
// from the shared assets: ASSETS is a folder or a URL (default ../assets, else https://assets.omgmog.net).
import { spawn } from "node:child_process";
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, mkdtempSync, readFileSync, copyFileSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";

const TEMPLATE_VERSION = 4; // bump to redraw everything after changing the design below
const arg = (name, fallback) => {
  const i = process.argv.indexOf(`--${name}`);
  return i > -1 ? process.argv[i + 1] : fallback;
};
const SITE = resolve(arg("site", "_site"));
const CACHE = resolve(arg("cache", ".cache/og"));
const OUT = resolve(arg("out", join(SITE, "images", "og")));
const JOBS = Number(process.env.OG_JOBS || 2);
const ASSETS = process.env.ASSETS || (existsSync("../assets/images/icons.svg") ? "../assets" : "https://assets.omgmog.net");

const asset = async (path) => {
  if (/^https?:/.test(ASSETS)) {
    const res = await fetch(`${ASSETS}/${path}`);
    if (!res.ok) throw new Error(`${ASSETS}/${path}: ${res.status}`);
    return Buffer.from(await res.arrayBuffer());
  }
  return readFileSync(join(ASSETS, path));
};

const findChrome = () => {
  const names = ["google-chrome", "google-chrome-stable", "chromium", "chromium-browser", "chrome"];
  if (process.env.CHROME) return process.env.CHROME;
  for (const dir of (process.env.PATH || "").split(":")) for (const n of names) if (existsSync(join(dir, n))) return join(dir, n);
  throw new Error("No Chrome or Chromium found: set CHROME=/path/to/chrome");
};

// Titles are stored as HTML text ("&lt;!-- more --&gt;", "&rsquo;"), so turn the entities back into characters before escaping
const NAMED = { amp: "&", lt: "<", gt: ">", quot: '"', apos: "'", nbsp: "\u00a0", rsquo: "\u2019", lsquo: "\u2018", rdquo: "\u201d", ldquo: "\u201c", ndash: "\u2013", mdash: "\u2014", hellip: "\u2026" };
const decode = (s) => String(s).replace(/&(#x[0-9a-f]+|#\d+|[a-z]+);/gi, (m, e) => (e[0] === "#" ? String.fromCodePoint(e[1].toLowerCase() === "x" ? parseInt(e.slice(2), 16) : Number(e.slice(1))) : NAMED[e.toLowerCase()] ?? m));

const esc = (s) => String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);

// the Lucide icon for a category, from the shared sprite, as a standalone <svg>
const iconSvg = (sprite, key, px, colour) => {
  const m = sprite.match(new RegExp(`<symbol id="icon-cat-${key}"([^>]*)>([\\s\\S]*?)</symbol>`));
  if (!m) return "";
  const attrs = m[1].replace(/\s*id="[^"]*"/, "");
  return `<svg width="${px}" height="${px}" ${attrs} style="color:${colour}">${m[2]}</svg>`;
};

// the category badge tile: 42px, rounded, the category colour with its icon. Links Worth a Look sits on the dark
// panel, so its tile is white with the dark icon, no outline.
const tile = (sprite, key, cat) => {
  const lwal = key === "lwal";
  const bg = lwal ? "#ffffff" : cat.colour;
  const ink = lwal ? "#1a1a1a" : cat.ink || "#1a1a1a";
  return `<span style="display:inline-flex;align-items:center;justify-content:center;width:42px;height:42px;border-radius:6px;background:${bg};flex-shrink:0">${iconSvg(sprite, key, 24, ink)}</span>`;
};

// Links Worth a Look titles read "Week 38: ..." on the image, as on the board
const shownTitle = (p) => {
  const week = p.kind === "lwal" && p.slug.match(/^week-(\d+)$/);
  return decode(week ? `Week ${week[1]}: ${p.title}` : p.title);
};


const page = ({ body, font, avatar }) => `<!doctype html><html><head><meta charset="utf-8"><style>
@font-face{font-family:"Fjalla One";src:url(data:font/woff2;base64,${font}) format("woff2");font-weight:400}
*{box-sizing:border-box}
html,body{margin:0;padding:0}
.og{position:relative;width:1200px;height:630px;overflow:hidden;background-color:#ffea00;background-image:radial-gradient(rgba(0,0,0,0.2) 10%,transparent 10%);background-size:24px 24px;font-family:"Helvetica Neue","Arial Nova",Helvetica,Arial,"Liberation Sans",sans-serif;color:#1a1a1a}
.rail{position:absolute;left:24px;top:40px;bottom:40px;width:80px;display:flex;flex-direction:column;align-items:center;gap:18px}
.rail img{width:64px;height:64px;flex-shrink:0;image-rendering:pixelated}
.rail span{font-family:"Fjalla One",sans-serif;font-weight:400;font-size:60px;line-height:1;text-transform:uppercase;white-space:nowrap;writing-mode:vertical-lr;transform:rotate(180deg)}
.panel{position:absolute;left:124px;top:40px;right:40px;bottom:40px;display:flex;flex-direction:column;padding:52px 60px 48px;border-radius:24px;box-shadow:0 0 24px rgba(0,0,0,0.1)}
.head{display:flex;align-items:center;gap:16px}
.label{font-size:20px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;white-space:nowrap}
.rule{flex-grow:1;height:6px}
.title{flex:1 1 auto;min-height:0;display:flex;align-items:flex-end;padding-top:28px}
h1{margin:0;width:100%;text-wrap:balance;font-family:"Fjalla One",sans-serif;font-weight:400;line-height:1.08;padding-bottom:0.14em;overflow:hidden;-webkit-box-orient:vertical}
.foot{margin-top:40px;display:flex;align-items:flex-end;justify-content:space-between;gap:24px;font-size:24px}
.foot .site{font-weight:700;text-decoration:underline;text-decoration-color:#ffea00;text-decoration-thickness:0.14em;text-underline-offset:0.18em}
.foot .meta{display:flex;align-items:center;gap:14px}
</style></head><body><div class="og"><div class="rail"><img src="${avatar}" alt=""><span>Max Glenister</span></div>${body}</div><script>
// Largest title size (up to 136px) that fits the space between the header and the footer; a title too long even at
// 52px is cut at the last line that fits.
document.fonts.ready.then(() => {
  const h1 = document.querySelector("h1"), box = h1.parentElement;
  let s = 136;
  for (; s > 52; s -= 2) { h1.style.fontSize = s + "px"; if (h1.scrollHeight <= box.clientHeight - 28) break; }
  h1.style.fontSize = s + "px";
  const lines = Math.max(1, Math.floor((box.clientHeight - 28) / (s * 1.08)));
  h1.style.display = "-webkit-box"; h1.style.webkitLineClamp = String(lines);
});
</script></body></html>`;

const postHtml = (p, cats, sprite) => {
  const lwal = p.category === "lwal";
  const cat = cats[p.category] || cats.blog;
  const panel = lwal ? "#1a1a1a" : "#ffffff";
  const ink = lwal ? "#ffffff" : "#1a1a1a";
  const muted = lwal ? "rgba(255,255,255,0.6)" : "rgba(26,26,26,0.6)";
  const accent = lwal ? "#ffea00" : cat.line || cat.colour;
  const labelInk = lwal ? "#ffea00" : "#1a1a1a";
  return `<div class="panel" style="background:${panel};color:${ink}">
<div class="head">${tile(sprite, p.category, cat)}<span class="label" style="color:${labelInk}">${esc(cat.name)}</span><span class="rule" style="background:${accent}"></span></div>
<div class="title"><h1 style="color:${ink}">${esc(shownTitle(p))}</h1></div>
<div class="foot" style="color:${muted}"><span class="meta">${esc(p.date)} · ${esc(p.meta)}</span><span class="site" style="color:${ink}">blog.omgmog.net</span></div></div>`;
};

const defaultHtml = (title, cats, sprite) => `<div class="panel" style="background:#fff">
<div class="head"><span class="label">blog.omgmog.net</span><span class="rule" style="background:#ffea00"></span></div>
<div class="title"><h1>${esc(title)}</h1></div>
<div class="foot" style="color:rgba(26,26,26,0.6)"><span class="meta">${["blog", "design", "tinkering", "web", "data", "reviews"].map((k) => tile(sprite, k, cats[k])).join("")}<span style="margin-left:6px">Writing here since 2004</span></span><span class="site" style="color:#1a1a1a">Start here</span></div></div>`;

const chrome = findChrome();
const flags = /headless_shell/.test(chrome) ? [] : ["--headless=new"];
const shoot = (html, png) =>
  new Promise((ok, fail) => {
    const dir = mkdtempSync(join(tmpdir(), "og-"));
    const file = join(dir, "page.html");
    writeFileSync(file, html);
    const p = spawn(chrome, [...flags, "--no-sandbox", "--disable-gpu", "--hide-scrollbars", "--window-size=1200,630", "--virtual-time-budget=2000", `--screenshot=${png}`, `file://${file}`], { stdio: "ignore" });
    const timer = setTimeout(() => p.kill("SIGKILL"), 60000);
    p.on("exit", () => {
      clearTimeout(timer);
      rmSync(dir, { recursive: true, force: true });
      existsSync(png) ? ok() : fail(new Error(`Chrome drew nothing for ${png}`));
    });
  });

const manifest = JSON.parse(readFileSync(join(SITE, "og-manifest.json"), "utf8"));
const [fontBuf, avatarBuf, spriteBuf] = await Promise.all([asset("fonts/fjalla-one-v13-latin-regular.woff2"), asset("images/mog.svg"), asset("images/icons.svg")]);
const font = fontBuf.toString("base64");
const avatar = `data:image/svg+xml;base64,${avatarBuf.toString("base64")}`;
const sprite = spriteBuf.toString("utf8");
const cats = manifest.categories;
const startTitle = decode(manifest.start_title); // the Start here headline, so the default image says what the page says

mkdirSync(OUT, { recursive: true });
mkdirSync(CACHE, { recursive: true });
const jobs = [
  { name: "default", inputs: { default: true, title: startTitle, cats: ["blog", "design", "tinkering", "web", "data", "reviews"].map((k) => cats[k]) }, html: () => defaultHtml(startTitle, cats, sprite) },
  ...manifest.posts.map((p) => ({ name: p.slug, inputs: { p, cat: cats[p.category] }, html: () => postHtml(p, cats, sprite) })),
];
let drawn = 0, reused = 0, failed = 0;
const run = async (job) => {
  const digest = createHash("sha1").update(JSON.stringify([TEMPLATE_VERSION, job.inputs])).digest("hex").slice(0, 10);
  const cached = join(CACHE, `${job.name}-${digest}.png`);
  try {
    if (existsSync(cached)) reused++;
    else {
      await shoot(page({ body: job.html(), font, avatar }), cached);
      drawn++;
    }
    copyFileSync(cached, join(OUT, `${job.name}.png`));
  } catch (err) {
    failed++;
    console.error(`og-images: ${job.name}: ${err.message}`);
  }
};
const only = arg("only", "")?.split(",").filter(Boolean) ?? []; // --only a,b,c: just these (for trying the design)
const queue = jobs.filter((j) => !only.length || only.includes(j.name));
await Promise.all(Array.from({ length: JOBS }, async () => { while (queue.length) await run(queue.shift()); }));
console.log(`og-images: ${drawn} drawn, ${reused} from cache, ${failed} failed (${jobs.length} total) -> ${OUT}`);
if (failed) process.exitCode = 1;
