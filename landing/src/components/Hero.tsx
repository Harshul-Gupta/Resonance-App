import { AnimatePresence, motion } from "framer-motion";
import { FormEvent, useEffect, useRef, useState } from "react";
import { useAppState } from "../context/AppState";
import { HeroBackdrop } from "./HeroBackdrop";

type ArtistHit = {
  id: string;
  name: string;
  genres: string[];
  image?: string;
};

const normalize = (a: any): ArtistHit => ({
  id: String(a.mongoId ?? a.id),
  name: a.name,
  genres: Array.isArray(a.genre) ? a.genre : [],
  image: a.imageURL || undefined,
});

function useArtistSearch(query: string) {
  const [results, setResults] = useState<ArtistHit[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const q = query.trim();
    if (q.length < 2) {
      setResults([]);
      setError(null);
      setLoading(false);
      return;
    }

    const controller = new AbortController();
    const timer = setTimeout(async () => {
      setLoading(true);
      setError(null);
      try {
        const res = await fetch(`/api/artists/search?name=${encodeURIComponent(q)}`, {
          signal: controller.signal,
          headers: { Accept: "application/json" },
        });
        if (!res.ok) throw new Error(`Search failed (${res.status})`);
        const data = await res.json();
        const list: any[] = data.content ?? [];
        setResults(list.slice(0, 6).map(normalize));
      } catch (err) {
        if ((err as Error).name !== "AbortError") {
          setError("Couldn't load results");
          setResults([]);
        }
      } finally {
        if (!controller.signal.aborted) setLoading(false);
      }
    }, 300);

    return () => {
      clearTimeout(timer);
      controller.abort();
    };
  }, [query]);

  return { results, loading, error };
}

function ArtistAvatar({ name, src }: { name: string; src?: string }) {
  const [failed, setFailed] = useState(false);
  if (!src || failed) {
    return (
      <span className="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-gradient-to-br from-violet-400 to-cyan-300 text-sm font-semibold text-black/70">
        {name.charAt(0).toUpperCase()}
      </span>
    );
  }
  return (
    <img
      src={src}
      alt=""
      loading="lazy"
      onError={() => setFailed(true)}
      className="h-10 w-10 shrink-0 rounded-full object-cover ring-1 ring-white/15"
    />
  );
}

export function Hero() {
  const { query, setQuery } = useAppState();
  const { results, loading, error } = useArtistSearch(query);
  const [open, setOpen] = useState(false);
  const wrapRef = useRef<HTMLDivElement>(null);

  // close the dropdown on outside click
  useEffect(() => {
    const onDown = (e: MouseEvent) => {
      if (!wrapRef.current?.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener("mousedown", onDown);
    return () => document.removeEventListener("mousedown", onDown);
  }, []);

  const onSearch = (e: FormEvent) => {
    e.preventDefault();
    setOpen(false);
    document.getElementById("songs")?.scrollIntoView({ behavior: "smooth" });
  };

  const showPanel = open && query.trim().length >= 2;

  return (
    <section id="top" className="relative isolate flex min-h-[100svh] items-center overflow-hidden bg-[#050505]">
      {/* video, orbs and equalizer sit behind everything */}
      <HeroBackdrop />

      {/* vignette keeps the edges dark so the glow stays centred */}
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_at_center,transparent_0%,#050505_82%)]" />

      <div className="relative z-10 mx-auto w-full max-w-6xl px-6 pb-24 pt-28 text-center">
        <motion.p
          initial={{ opacity: 0, y: 16, filter: "blur(12px)" }}
          animate={{ opacity: 1, y: 0, filter: "blur(0px)" }}
          transition={{ duration: 0.9, ease: [0.22, 1, 0.36, 1] }}
          className="mb-6 font-display text-[11px] font-semibold uppercase tracking-[0.42em] text-cyan drop-shadow-[0_0_14px_rgba(34,211,238,0.55)]"
        >
          Resonance
        </motion.p>

        <h1 className="font-grotesk text-[clamp(3.2rem,12vw,8.6rem)] font-medium leading-[0.86] tracking-tightest text-paper">
          <span className="block overflow-hidden">
            <motion.span
              className="block"
              initial={{ y: "110%" }}
              animate={{ y: "0%" }}
              transition={{ duration: 1.05, ease: [0.16, 1, 0.3, 1] }}
            >
              YOUR MUSIC.
            </motion.span>
          </span>
          <span className="mt-1 block overflow-hidden">
            <motion.span
              className="block bg-gradient-to-r from-violet-400 via-pink-400 to-cyan-300 bg-clip-text pb-[0.08em] text-transparent"
              initial={{ y: "110%" }}
              animate={{ y: "0%" }}
              transition={{ duration: 1.05, delay: 0.12, ease: [0.16, 1, 0.3, 1] }}
            >
              YOUR FREQUENCY.
            </motion.span>
          </span>
        </h1>

        <motion.p
          initial={{ opacity: 0, y: 18 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.45, duration: 0.8 }}
          className="mx-auto mt-8 max-w-xl text-base text-white/65 md:text-lg"
        >
          Discover artists. Find songs. Build a collection that sounds like you.
        </motion.p>

        <div ref={wrapRef} className="relative mx-auto mt-10 w-full max-w-xl">
          <motion.form
            onSubmit={onSearch}
            initial={{ opacity: 0, scale: 0.96 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.6, type: "spring", stiffness: 180, damping: 18 }}
            className="flex w-full items-center gap-2 rounded-2xl border border-white/15 bg-white/[0.06] p-1.5 shadow-[0_8px_50px_-12px_rgba(124,92,255,0.55)] backdrop-blur-xl transition-colors focus-within:border-violet-400/60 focus-within:bg-white/[0.09]"
            role="search"
          >
            <label htmlFor="hero-search" className="sr-only">
              Search artists and songs
            </label>
            <svg
              className="ml-3 h-[18px] w-[18px] text-white/55"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              aria-hidden="true"
            >
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
            <input
              id="hero-search"
              value={query}
              onChange={(e) => {
                setQuery(e.target.value);
                setOpen(true);
              }}
              onFocus={() => setOpen(true)}
              onKeyDown={(e) => e.key === "Escape" && setOpen(false)}
              autoComplete="off"
              aria-expanded={showPanel}
              aria-controls="hero-search-results"
              placeholder="Search a frequency, artist, or song"
              className="h-12 flex-1 bg-transparent px-3 text-[15px] text-paper outline-none placeholder:text-white/40"
            />
          </motion.form>

          <AnimatePresence>
            {showPanel && (
              <motion.ul
                id="hero-search-results"
                role="listbox"
                initial={{ opacity: 0, y: -6 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -6 }}
                transition={{ duration: 0.18 }}
                className="absolute left-0 right-0 top-full z-20 mt-2 max-h-80 overflow-y-auto rounded-2xl border border-white/15 bg-[#0b0b10]/85 p-1.5 text-left shadow-[0_20px_60px_-15px_rgba(0,0,0,0.8)] backdrop-blur-xl"
              >
                {loading && <li className="px-3 py-3 text-sm text-white/50">Searching…</li>}
                {error && <li className="px-3 py-3 text-sm text-pink-300">{error}</li>}
                {!loading && !error && results.length === 0 && (
                  <li className="px-3 py-3 text-sm text-white/50">No artists found</li>
                )}
                {results.map((a) => (
                  <li key={a.id} role="option">
                    <a
                      href={`/artist-details/${a.id}`}
                      className="flex items-center gap-3 rounded-xl px-3 py-2 transition-colors hover:bg-white/10"
                    >
                      <ArtistAvatar name={a.name} src={a.image} />
                      <span className="truncate text-sm text-paper">{a.name}</span>
                      {a.genres.length > 0 && (
                        <span className="ml-auto shrink-0 text-xs text-white/40">
                          {a.genres.slice(0, 2).join(" · ")}
                        </span>
                      )}
                    </a>
                  </li>
                ))}
              </motion.ul>
            )}
          </AnimatePresence>
        </div>
      </div>
    </section>
  );
}