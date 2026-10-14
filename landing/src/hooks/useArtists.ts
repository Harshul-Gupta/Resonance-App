import { useEffect, useState } from "react";
import { getJson } from "../api";
import type { Artist as ApiArtist } from "../types";
import type { Artist as CatalogArtist } from "../data/catalog";

export type DisplayArtist = {
  id: string; // mongoId, also the key stored in the collection
  name: string;
  country: string;
  genreLabel: string;
  imageURL: string | null;
  href: string; // single place to change the details-page URL
  art: Pick<CatalogArtist, "id" | "name" | "palette" | "motif">;
};

const PAGES = 3; // topArtists returns 5 per page
const MOTIFS: CatalogArtist["motif"][] = ["rings", "orbit", "grid", "wave", "bars", "prism"];

function hash(s: string) {
  let h = 0;
  for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
  return h;
}

function toDisplay(a: ApiArtist): DisplayArtist {
  const h = hash(a.mongoId || a.name);
  const hue = h % 360;
  const palette = [
    `hsl(${hue}, 70%, 45%)`,
    `hsl(${(hue + 50) % 360}, 65%, 35%)`,
    `hsl(${(hue + 110) % 360}, 60%, 22%)`,
  ] as CatalogArtist["palette"];

  return {
    id: a.mongoId,
    name: a.name,
    country: a.country,
    genreLabel: (a.genre ?? []).slice(0, 2).join(", "),
    imageURL: a.imageURL,
    href: `/artist-details/${a.mongoId}`,
    art: { id: a.mongoId, name: a.name, palette, motif: MOTIFS[h % MOTIFS.length]! },
  };
}

async function loadAll(): Promise<DisplayArtist[]> {
  const results = await Promise.allSettled(
    Array.from({ length: PAGES }, (_, p) =>
      getJson<ApiArtist[]>(`/api/artists/topArtists?pageNumber=${p}`)
    )
  );
  const seen = new Set<string>();
  const out: DisplayArtist[] = [];
  let ok = 0;
  for (const r of results) {
    if (r.status !== "fulfilled"){
		console.warn("topArtists failed: ", r.reason);
		 continue;
	}
    ok++;
    for (const a of r.value) {
      if (seen.has(a.mongoId)) continue;
      seen.add(a.mongoId);
      out.push(toDisplay(a));
    }
  }
  if (ok === 0) throw new Error("topArtists failed");
  return out;
}

let cache: Promise<DisplayArtist[]> | null = null;
export function loadArtists() {
  if (!cache) {
    cache = loadAll().catch((e) => {
      cache = null; // allow a retry on the next mount
      throw e;
    });
  }
  return cache;
}

export function useArtists() {
  const [artists, setArtists] = useState<DisplayArtist[] | null>(null);
  const [error, setError] = useState(false);

  useEffect(() => {
    let alive = true;
    loadArtists()
      .then((l) => alive && setArtists(l))
      .catch(() => alive && setError(true));
    return () => {
      alive = false;
    };
  }, []);

  return { artists: artists ?? [], loading: artists === null && !error, error };
}