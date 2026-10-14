import { useState } from "react";
import type { DisplayArtist } from "../hooks/useArtists";
import { AlbumArt } from "./AlbumArt";

export function ArtistImage({ artist }: { artist: DisplayArtist }) {
  const [failed, setFailed] = useState(false);

  if (artist.imageURL && !failed) {
    return (
      <img
        src={artist.imageURL}
        alt={artist.name}
        loading="lazy"
        onError={() => setFailed(true)}
        className="h-full w-full object-cover"
      />
    );
  }
  return <AlbumArt artist={artist.art} />;
}