#!/usr/bin/env node

import fs from "fs";

// Configuration
const USERNAME = process.env.LASTFM_USERNAME;
const API_KEY = process.env.LASTFM_API_KEY;
const LIMIT = 1;
const TIMEOUT = 10000; // 10 seconds
const MAX_RETRIES = 3;
const RETRY_DELAY = 1000; // 1 second, doubled each retry

if (!USERNAME || !API_KEY) {
  console.error("Missing LASTFM_USERNAME or LASTFM_API_KEY");
  process.exit(1);
}

const url =
  "https://ws.audioscrobbler.com/2.0/" +
  `?method=user.getRecentTracks` +
  `&user=${encodeURIComponent(USERNAME)}` +
  `&api_key=${API_KEY}` +
  `&limit=${LIMIT}` +
  `&format=json`;

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function fetchWithRetry(url) {
  let lastError;

  for (let attempt = 1; attempt <= MAX_RETRIES; attempt++) {
    try {
      const res = await fetch(url, {
        headers: { "User-Agent": "GitHub-Actions-LastFM-Tracker/1.0" },
        signal: AbortSignal.timeout(TIMEOUT),
      });

      if (!res.ok) {
        const error = new Error(`HTTP ${res.status}: ${res.statusText}`);
        error.statusCode = res.status;
        // Retry on 429/5xx, bail immediately on other 4xx
        if (res.status !== 429 && res.status < 500) {
          throw error;
        }
        lastError = error;
        console.log(`Retrying... (${attempt}/${MAX_RETRIES}) after ${error.message}`);
        await sleep(RETRY_DELAY * attempt);
        continue;
      }

      return await res.text();
    } catch (err) {
      if (err.statusCode && err.statusCode !== 429 && err.statusCode < 500) {
        throw err;
      }

      lastError = err;
      if (attempt >= MAX_RETRIES) break;
      console.log(`Retrying... (${attempt}/${MAX_RETRIES}) after ${err.message}`);
      await sleep(RETRY_DELAY * attempt);
    }
  }

  throw new Error(`Failed after ${MAX_RETRIES} attempts. Last error: ${lastError.message}`);
}

try {
  const data = await fetchWithRetry(url);
  const json = JSON.parse(data);

  // Validate API response structure
  if (json.error) {
    throw new Error(`Last.fm API error ${json.error}: ${json.message}`);
  }

  if (!json.recenttracks) {
    throw new Error("Invalid response: missing recenttracks");
  }

  if (!json.recenttracks.track) {
    throw new Error("No tracks found in response");
  }

  // Handle both single track (object) and multiple tracks (array)
  const tracks = Array.isArray(json.recenttracks.track)
    ? json.recenttracks.track
    : [json.recenttracks.track];

  if (tracks.length === 0) {
    throw new Error("No recent tracks returned");
  }

  const track = tracks[0];

  // Validate track structure
  if (!track.name || !track.artist) {
    throw new Error("Invalid track data: missing required fields");
  }

  const output = {
    track: track.name,
    artist: track.artist["#text"] || track.artist,
    album: track.album?.["#text"] || track.album || null,
    url: track.url || null,
    now_playing: track["@attr"]?.nowplaying === "true",
    played_at: track.date ? Number(track.date.uts) : null,
    updated_at: new Date().toISOString(),
  };

  const filePath = "_data/now/lastfm.json";
  let previous = null;

  if (fs.existsSync(filePath)) {
    try {
      previous = JSON.parse(fs.readFileSync(filePath, "utf8"));
    } catch (err) {
      // Continue with null previous, will create new file
    }
  }

  // Only write if anything meaningful changed
  if (
    !previous ||
    previous.track !== output.track ||
    previous.artist !== output.artist ||
    previous.album !== output.album ||
    previous.now_playing !== output.now_playing ||
    previous.played_at !== output.played_at
  ) {
    fs.mkdirSync("_data/now", { recursive: true });
    fs.writeFileSync(filePath, JSON.stringify(output, null, 2) + "\n");
    console.log("Updated _data/now/lastfm.json");
  } else {
    console.log("Track hasn't changed, skipping update");
  }
} catch (err) {
  console.error(`Failed to process Last.fm response: ${err.message}`);
  process.exit(1);
}
