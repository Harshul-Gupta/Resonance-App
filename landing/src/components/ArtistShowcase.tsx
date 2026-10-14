import { motion, useMotionValue, useSpring } from "framer-motion";
import { useRef, type MouseEvent } from "react";
import { appUrl } from "../api";
import { useAppState } from "../context/AppState";
import { useArtists, type DisplayArtist } from "../hooks/useArtists";
import { usePrefersReducedMotion } from "../hooks/usePrefersReducedMotion";
import { ArtistImage } from "./ArtistImage";

export function ArtistShowcase() {
  const { artists, loading, error } = useArtists();

  return (
    <section id="artists" className="relative py-28">
      <div className="mx-auto max-w-6xl px-6">
        <motion.h2
          initial={{ opacity: 0, rotate: -2, y: 30 }}
          whileInView={{ opacity: 1, rotate: 0, y: 0 }}
          viewport={{ once: true, amount: 0.6 }}
          transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          className="font-grotesk text-[clamp(2.4rem,7vw,5.5rem)] font-medium leading-[0.9] tracking-tightest"
        >
          Find your artists.
        </motion.h2>
        <p className="mt-6 max-w-lg text-mute">
          Browse the registry, keep the voices you love, and shape a catalogue
          that feels like a private listening room.
        </p>
      </div>

      <div className="artist-track mt-16 flex gap-8 overflow-x-auto px-[8vw] pb-10 pt-6 no-scrollbar">
        {loading &&
          Array.from({ length: 5 }, (_, i) => (
            <div
              key={i}
              className="aspect-square w-[240px] shrink-0 animate-pulse rounded-[2px] bg-white/5 md:w-[280px]"
            />
          ))}
        {error && <p className="text-sm text-mute">Couldn't load artists right now.</p>}
        {artists.map((artist, i) => (
          <ArtistSleeve key={artist.id} artist={artist} index={i} />
        ))}
      </div>
    </section>
  );
}

function ArtistSleeve({ artist, index }: { artist: DisplayArtist; index: number }) {
  const reduced = usePrefersReducedMotion();
  const { collection, addArtist, removeArtist } = useAppState();
  const saved = collection.artistIds.includes(artist.id);
  const ref = useRef<HTMLElement>(null);
  const rx = useMotionValue(0);
  const ry = useMotionValue(0);
  const x = useSpring(rx, { stiffness: 180, damping: 20 });
  const y = useSpring(ry, { stiffness: 180, damping: 20 });

  const onMove = (e: MouseEvent) => {
    if (reduced || !ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    const dx = e.clientX - (rect.left + rect.width / 2);
    const dy = e.clientY - (rect.top + rect.height / 2);
    rx.set(dx * 0.12);
    ry.set(dy * 0.12);
  };

  const details = appUrl(artist.href);

  return (
    <motion.article
      ref={ref}
      style={{ x, y }}
      initial={{ opacity: 0, y: 50, filter: "blur(10px)" }}
      whileInView={{ opacity: 1, y: 0, filter: "blur(0px)" }}
      viewport={{ once: true, amount: 0.35 }}
      transition={{ delay: index * 0.06, duration: 0.7 }}
      onMouseMove={onMove}
      onMouseLeave={() => {
        rx.set(0);
        ry.set(0);
      }}
      whileHover={reduced ? undefined : { scale: 1.04, zIndex: 10 }}
      className="group relative w-[240px] shrink-0 md:w-[280px]"
    >
      <a href={details} className="block">
        <div className="aspect-square overflow-hidden rounded-[2px] border border-white/10 bg-black shadow-[0_24px_60px_rgba(0,0,0,0.45)] transition-shadow duration-300 group-hover:shadow-[0_0_50px_rgba(139,92,246,0.35)]">
          <ArtistImage artist={artist} />
        </div>
      </a>
      <div className="mt-4 flex items-end justify-between gap-3">
        <div className="min-w-0">
          <h3 className="truncate font-display text-lg font-semibold">
            <a href={details}>{artist.name}</a>
          </h3>
          <p className="truncate text-sm text-mute opacity-0 transition-opacity duration-300 group-hover:opacity-100">
            {artist.country} · {artist.genreLabel}
          </p>
        </div>
        <button
          type="button"
          onClick={() => (saved ? removeArtist(artist.id) : addArtist(artist.id))}
          className="cursor-pointer rounded-lg border border-white/15 px-3 py-1.5 text-xs font-semibold uppercase tracking-wider text-paper/80 hover:bg-white/10"
        >
          {saved ? "Remove" : "Add"}
        </button>
      </div>
    </motion.article>
  );
}