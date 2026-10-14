import { useEffect, useState } from "react";
import { getJson } from "../api";
import type { ApiSong } from "../types";
import { loadArtists, type DisplayArtist } from "./useArtists";

export type DisplaySong = {
  id: string;
  title: string;
  artistNames: string;
  album: string;
  duration: string;
  audioUrl: string;
  imageURL: string | null; // song artwork, wired up later
  artist: DisplayArtist; // used for the fallback picture
};

function fmt(sec: number) {
  if (!Number.isFinite(sec) || sec <= 0) return "";
  const t = Math.round(sec);
  return `${Math.floor(t / 60)}:${String(t % 60).padStart(2, "0")}`;
}

function toDisplay(s: ApiSong, artist: DisplayArtist): DisplaySong {
  const names = (s.artists ?? []).map((a) => a.artistName).filter(Boolean).join(", ");
  return {
    id: String(s.id),
    title: s.songName,
    artistNames: names || artist.name,
    album: s.albumName ?? "",
    duration: fmt(s.duration),
    audioUrl: s.s3URL,
    imageURL: null, // later: s.imageURL once the backend has it
    artist,
  };
}

async function loadAll(): Promise<DisplaySong[]> {
  const artists = await loadArtists();
  const results = await Promise.allSettled(
    artists.map((a) => getJson<ApiSong[]>(`/api/songs/artist/${a.id}`))
  );
  const seen = new Set<number>();
  const out: DisplaySong[] = [];
  let ok = 0;
  results.forEach((r, i) => {
    if (r.status !== "fulfilled") {
      console.warn("songs failed for", artists[i]?.name, r.reason);
      return;
    }
    ok++;
    for (const s of r.value) {
      if (seen.has(s.id)) continue; // multi-artist songs come back once per artist
      seen.add(s.id);
      out.push(toDisplay(s, artists[i]!));
    }
  });
  if (ok === 0 && artists.length > 0) throw new Error("songs failed");
  return out;
}

let cache: Promise<DisplaySong[]> | null = null;
function load() {
  if (!cache) {
    cache = loadAll().catch((e) => {
      cache = null;
      throw e;
    });
  }
  return cache;
}

export function useSongs() {
  const [songs, setSongs] = useState<DisplaySong[] | null>(null);
  const [error, setError] = useState(false);

  useEffect(() => {
    let alive = true;
    load()
      .then((l) => alive && setSongs(l))
      .catch(() => alive && setError(true));
    return () => {
      alive = false;
    };
  }, []);

  return { songs: songs ?? [], loading: songs === null && !error, error };
}