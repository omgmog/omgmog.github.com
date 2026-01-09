#!/usr/bin/env node

import fs from "fs";
import https from "https";

// Configuration
const USERNAME = process.env.LASTFM_USERNAME;
const API_KEY = process.env.LASTFM_API_KEY;
const LIMIT = 1;
const TIMEOUT = 10000; // 10 seconds
const MAX_RETRIES = 3;
const RETRY_DELAY = 1000; // 1 second

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

// Utility function to sleep
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

// Enhanced HTTP request with timeout and retry
function fetchWithRetry(url, retries = MAX_RETRIES) {
  return new Promise((resolve, reject) => {
    const attempt = (attemptNum) => {
      const req = https.get(url, {
        headers: {
          'User-Agent': 'GitHub-Actions-LastFM-Tracker/1.0'
        },
        timeout: TIMEOUT
      }, (res) => {
        let data = "";

        res.on("data", (chunk) => (data += chunk));
        res.on("end", () => {
          if (res.statusCode !== 200) {
            const error = new Error(`HTTP ${res.statusCode}: ${res.statusMessage}`);
            error.statusCode = res.statusCode;
            error.response = data;
            reject(error);
            return;
          }
          resolve(data);
        });
      });

      req.on("timeout", () => {
        req.destroy();
        const error = new Error(`Request timeout after ${TIMEOUT}ms`);
        error.code = 'TIMEOUT';
        reject(error);
      });

      req.on("error", (err) => {
        reject(err);
      });
    };

    const executeWithRetry = async (attemptNum = 1) => {
      try {
        await new Promise((resolve, reject) => {
          attempt(attemptNum);
          // The promise resolves/rejects in the attempt function
        });
      } catch (error) {
        if (attemptNum >= retries) {
          reject(new Error(`Failed after ${retries} attempts. Last error: ${error.message}`));
          return;
        }

        console.log(`Retrying... (${attemptNum}/${retries})`);
        await sleep(RETRY_DELAY);
        return executeWithRetry(attemptNum + 1);
      }
    };

    // Start the first attempt
    attempt(1);
  });
}

fetchWithRetry(url)
  .then(data => {
    try {
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
        updated_at: new Date().toISOString()
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

      // Only write if the track or now_playing status changed
      if (
        !previous ||
        previous.track !== output.track ||
        previous.artist !== output.artist ||
        previous.now_playing !== output.now_playing
      ) {
        try {
          fs.mkdirSync("_data/now", { recursive: true });
          fs.writeFileSync(filePath, JSON.stringify(output, null, 2) + "\n");
          console.log("Updated _data/now/lastfm.json");
        } catch (err) {
          throw new Error(`Failed to write file: ${err.message}`);
        }
      } else {
        console.log("Track hasn't changed, skipping update");
        process.exit(0); // Exit gracefully without attempting commit
      }

    } catch (err) {
      console.error(`Failed to process Last.fm response: ${err.message}`);
      process.exit(1);
    }
  })
  .catch(err => {
    // Handle timeout gracefully - don't fail the workflow
    if (err.code === 'TIMEOUT' || err.message.includes('timeout')) {
      console.log(`Last.fm API timeout - skipping update this run`);
      process.exit(0);
    }

    // Other errors should fail the workflow
    console.error(`Request failed: ${err.message}`);
    process.exit(1);
  });
