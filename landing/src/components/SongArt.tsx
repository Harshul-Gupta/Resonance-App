import type { DisplaySong } from "../hooks/useSongs";
import { ArtistImage } from "./ArtistImage";

export function SongArt({ song }: { song: DisplaySong }) {
  if (song.imageURL) {
    return (
      <img src={song.imageURL} alt="" loading="lazy" className="h-full w-full object-cover" />
    );
  }
  return <ArtistImage artist={song.artist} />;
}