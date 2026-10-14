export type Artist = {
  mongoId: string;
  id: string;
  name: string;
  type: string;
  bio: string;
  country: string;
  genre: string[];
  imageURL: string | null;
  viewCount: number;
};

export type ApiSong = {
  id: number;
  songName: string;
  artists: { artistMongoId: string; artistName: string }[] | null;
  albumName: string | null;
  duration: number; // int in your entity, assumed to be seconds
  s3URL: string;
};