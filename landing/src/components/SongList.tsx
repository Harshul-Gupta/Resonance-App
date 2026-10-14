import { motion } from "framer-motion";
import { useAppState } from "../context/AppState";
import { useSongs } from "../hooks/useSongs";
import { useSongPlayer } from "../hooks/useSongPlayer";
import { SongArt } from "./SongArt";

export function SongList() {
  const { query, favorites, toggleFavorite, collection, addSong, removeSong } = useAppState();
  const { songs, loading, error } = useSongs();
  const { currentId, isPlaying, toggle } = useSongPlayer();

  const q = query.trim().toLowerCase();
  const visible = songs.filter(
    (s) =>
      !q ||
      s.title.toLowerCase().includes(q) ||
      s.artistNames.toLowerCase().includes(q)
  );

  return (
    <section id="songs" className="relative px-6 py-28">
      <div className="mx-auto max-w-5xl">
        <motion.h2
          initial={{ clipPath: "inset(0 0 100% 0)" }}
          whileInView={{ clipPath: "inset(0 0 0% 0)" }}
          viewport={{ once: true, amount: 0.7 }}
          transition={{ duration: 0.9, ease: [0.16, 1, 0.3, 1] }}
          className="font-grotesk text-[clamp(2.2rem,6vw,4.8rem)] font-medium leading-[0.92] tracking-tightest"
        >
          Everything you
          <br />
          want to hear.
        </motion.h2>
        <p className="mt-6 max-w-lg text-mute">
          A listening surface for the registry — play, keep, and curate without
          leaving the frequency.
        </p>

        <ul className="mt-14 divide-y divide-white/5 border-y border-white/5">
          {loading &&
            Array.from({ length: 5 }, (_, i) => (
              <li key={i} className="h-[76px] animate-pulse bg-white/[0.03]" />
            ))}

          {visible.map((song, i) => {
            const active = currentId === song.id && isPlaying;
            const loved = favorites.includes(song.id);
            const saved = collection.songIds.includes(song.id);

            return (
              <motion.li
                key={song.id}
                initial={{ x: i % 2 === 0 ? -40 : 40, opacity: 0 }}
                whileInView={{ x: 0, opacity: 1 }}
                viewport={{ once: true, amount: 0.4 }}
                transition={{ duration: 0.55, delay: Math.min(i, 8) * 0.05 }}
                className="group grid grid-cols-[auto_1fr_auto] items-center gap-4 py-4 md:grid-cols-[auto_auto_1fr_1fr_auto_auto]"
              >
                {/* Play / Pause Toggle Button */}
                <button
                  type="button"
                  aria-label={active ? `Pause ${song.title}` : `Play ${song.title}`}
                  onClick={() => toggle(song.id, song.audioUrl)}
                  className={`grid h-11 w-11 cursor-pointer place-items-center rounded-full border transition group-hover:scale-105 ${
                    active
                      ? "border-cyan bg-cyan/20 text-cyan shadow-[0_0_15px_rgba(34,211,238,0.4)]"
                      : "border-white/10 bg-white/5 text-paper group-hover:border-cyan/50 group-hover:bg-cyan/10"
                  }`}
                >
                  {active ? (
                    <svg width="14" height="14" viewBox="0 0 14 14" fill="currentColor">
                      <rect x="2" y="1" width="3.5" height="12" rx="1" />
                      <rect x="8.5" y="1" width="3.5" height="12" rx="1" />
                    </svg>
                  ) : (
                    <svg width="14" height="14" viewBox="0 0 14 14" className="opacity-60 transition group-hover:opacity-100" aria-hidden="true">
                      <path d="M3 1.5 12 7 3 12.5Z" fill="currentColor" />
                    </svg>
                  )}
                </button>

                <div className="hidden h-12 w-12 overflow-hidden rounded-sm md:block">
                  <SongArt song={song} />
                </div>
                <div className="min-w-0">
                  <p className="truncate font-medium text-paper">{song.title}</p>
                  <p className="truncate text-sm text-mute md:hidden">{song.artistNames}</p>
                </div>
                <p className="hidden truncate text-sm text-mute md:block">{song.artistNames}</p>
                <p className="hidden tabular-nums text-sm text-mute md:block">{song.duration}</p>

                <div className="flex items-center gap-3">
                  {/* Bookmark / Save Icon */}
                  <button
                    type="button"
                    aria-label={loved ? "Remove bookmark" : "Bookmark track"}
                    onClick={() => toggleFavorite(song.id)}
                    className={`cursor-pointer rounded-lg p-2 transition-all duration-200 active:scale-75 ${
                      loved
                        ? "scale-110 text-cyan drop-shadow-[0_0_10px_rgba(34,211,238,0.7)]"
                        : "text-white/40 hover:scale-105 hover:text-white"
                    }`}
                  >
                    <svg
                      width="18"
                      height="18"
                      viewBox="0 0 24 24"
                      fill={loved ? "currentColor" : "none"}
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    >
                      <path d="m19 21-7-4-7 4V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16z" />
                    </svg>
                  </button>

                  {/* Fixed-width container prevents text layout shifts when toggling Add / Remove */}
                  <div className="w-20 text-right">
                    <button
                      type="button"
                      onClick={() => (saved ? removeSong(song.id) : addSong(song.id))}
                      className="cursor-pointer rounded-lg border border-white/15 px-3 py-1.5 text-xs font-semibold uppercase tracking-wider text-paper/80 transition hover:bg-white/10"
                    >
                      {saved ? "Remove" : "Add"}
                    </button>
                  </div>
                </div>
              </motion.li>
            );
          })}
        </ul>

        {error && <p className="py-10 text-center text-mute">Couldn't load tracks right now.</p>}
        {!loading && !error && visible.length === 0 && (
          <p className="py-10 text-center text-mute">No tracks in this frequency.</p>
        )}
      </div>
    </section>
  );
}