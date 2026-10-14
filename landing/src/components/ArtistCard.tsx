import type { Artist } from "../types";
import { appUrl } from "../api";

export function ArtistCard({ artist }: { artist: Artist }) {
  return (
    <a
      href={appUrl(`/artist-details/${artist.mongoId}`)}
      className="group block overflow-hidden rounded-2xl border border-white/10 bg-white/[0.03] transition hover:border-violet/60 hover:shadow-glow"
    >
      <div className="aspect-square overflow-hidden bg-gradient-to-br from-violet/30 to-cyan/20">
        {artist.imageURL ? (
          <img
            src={artist.imageURL}
            alt={artist.name}
            loading="lazy"
            className="h-full w-full object-cover transition duration-500 group-hover:scale-105"
          />
        ) : (
          <div className="grid h-full place-items-center font-display text-5xl text-paper/70">
            {artist.name.charAt(0)}
          </div>
        )}
      </div>
      <div className="p-4">
        <h3 className="font-display text-lg text-paper">{artist.name}</h3>
        <p className="mt-1 font-grotesk text-sm text-mute">
          {artist.country} · {(artist.genre ?? []).slice(0, 2).join(", ")}
        </p>
      </div>
    </a>
  );
}