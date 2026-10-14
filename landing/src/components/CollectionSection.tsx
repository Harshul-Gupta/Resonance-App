import { motion } from "framer-motion";
import { useAppState } from "../context/AppState";
import { useArtists } from "../hooks/useArtists";
import { useSongs } from "../hooks/useSongs";
import { ArtistImage } from "./ArtistImage";
import { SongArt } from "./SongArt";

export function CollectionSection() {
  const { collection, removeArtist, removeSong, addArtist, addSong } = useAppState();
  const { artists } = useArtists();
  const { songs } = useSongs();

  const savedArtists = artists.filter((a) => collection.artistIds.includes(a.id));
  const savedSongs = songs.filter((s) => collection.songIds.includes(s.id));

  return (
    <section id="collection" className="relative overflow-hidden px-6 py-28">
      <motion.div
        aria-hidden="true"
        className="absolute -right-24 top-10 h-80 w-80 rounded-full bg-violet/20 blur-[90px]"
        initial={{ scale: 0.6, opacity: 0 }}
        whileInView={{ scale: 1, opacity: 1 }}
        viewport={{ once: true }}
        transition={{ duration: 1.1 }}
      />
      <div className="relative mx-auto max-w-6xl">
        <motion.h2
          initial={{ scale: 1.12, opacity: 0 }}
          whileInView={{ scale: 1, opacity: 1 }}
          viewport={{ once: true, amount: 0.5 }}
          transition={{ duration: 0.85, ease: [0.16, 1, 0.3, 1] }}
          className="font-grotesk text-[clamp(2.2rem,6vw,5rem)] font-medium leading-[0.9] tracking-tightest"
        >
          Your sound.
          <br />
          Your collection.
        </motion.h2>
        <p className="mt-6 max-w-xl text-lg text-mute">
          Add and remove artists and songs as the mood shifts. Resonance is a
          living shelf — keep only what still resonates.
        </p>

        <div className="mt-16 grid gap-10 lg:grid-cols-2">
          <div>
            <h3 className="mb-4 font-display text-sm uppercase tracking-[0.2em] text-cyan">
              Artists
            </h3>
            <div className="space-y-3">
              {savedArtists.map((artist) => (
                <div
                  key={artist.id}
                  className="flex items-center gap-4 rounded-2xl border border-white/10 bg-white/[0.03] p-3"
                >
                  <div className="h-14 w-14 overflow-hidden rounded-sm">
                    <ArtistImage artist={artist} />
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="font-medium">{artist.name}</p>
                    <p className="text-sm text-mute">{artist.genreLabel}</p>
                  </div>
                  <button
                    type="button"
                    onClick={() => removeArtist(artist.id)}
                    className="cursor-pointer text-xs uppercase tracking-wider text-mute hover:text-pink"
                  >
                    Remove
                  </button>
                </div>
              ))}
              {savedArtists.length === 0 && (
                <p className="text-sm text-mute">No artists yet — add from the showcase.</p>
              )}
            </div>
          </div>

          <div>
            <h3 className="mb-4 font-display text-sm uppercase tracking-[0.2em] text-cyan">
              Songs
            </h3>
            <div className="space-y-3">
              {savedSongs.map((song) => (
                <div
                  key={song.id}
                  className="flex items-center gap-4 rounded-2xl border border-white/10 bg-white/[0.03] p-3"
                >
                  <div className="h-14 w-14 overflow-hidden rounded-sm">
                    <SongArt song={song} />
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="truncate font-medium">{song.title}</p>
                    <p className="truncate text-sm text-mute">{song.artistNames}</p>
                  </div>
                  <button
                    type="button"
                    onClick={() => removeSong(song.id)}
                    className="cursor-pointer text-xs uppercase tracking-wider text-mute hover:text-pink"
                  >
                    Remove
                  </button>
                </div>
              ))}
              {savedSongs.length === 0 && (
                <p className="text-sm text-mute">No saved tracks yet.</p>
              )}
            </div>
          </div>
        </div>

        <div className="mt-12 flex flex-wrap gap-2">
          {artists
            .filter((a) => !collection.artistIds.includes(a.id))
            .slice(0, 4)
            .map((artist) => (
              <button
                key={artist.id}
                type="button"
                onClick={() => addArtist(artist.id)}
                className="cursor-pointer rounded-full border border-white/10 px-4 py-2 text-sm text-mute hover:border-violet/50 hover:text-paper"
              >
                + {artist.name}
              </button>
            ))}
          {songs
            .filter((s) => !collection.songIds.includes(s.id))
            .slice(0, 3)
            .map((song) => (
              <button
                key={song.id}
                type="button"
                onClick={() => addSong(song.id)}
                className="cursor-pointer rounded-full border border-white/10 px-4 py-2 text-sm text-mute hover:border-cyan/50 hover:text-paper"
              >
                + {song.title}
              </button>
            ))}
        </div>
      </div>
    </section>
  );
}