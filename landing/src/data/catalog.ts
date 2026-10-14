export type Artist = {
  id: string;
  name: string;
  genre: string;
  songCount: number;
  palette: [string, string, string];
  motif: "rings" | "bars" | "orbit" | "grid" | "wave" | "prism";
};

export type Song = {
  id: string;
  title: string;
  artist: string;
  artistId: string;
  duration: string;
  seconds: number;
};

export const artists: Artist[] = [
  {
    id: "nova-veil",
    name: "Nova Veil",
    genre: "Dreamwave",
    songCount: 14,
    palette: ["#2e1064", "#8B5CF6", "#22D3EE"],
    motif: "rings",
  },
  {
    id: "kairo",
    name: "Kairo",
    genre: "Afro-electronica",
    songCount: 9,
    palette: ["#042f2e", "#22D3EE", "#EC4899"],
    motif: "orbit",
  },
  {
    id: "lumen-arc",
    name: "Lumen Arc",
    genre: "Ambient",
    songCount: 11,
    palette: ["#111827", "#6366f1", "#f5f5f5"],
    motif: "grid",
  },
  {
    id: "violet-static",
    name: "Violet Static",
    genre: "Synth pop",
    songCount: 18,
    palette: ["#3b0764", "#EC4899", "#8B5CF6"],
    motif: "prism",
  },
  {
    id: "low-signal",
    name: "Low Signal",
    genre: "Downtempo",
    songCount: 7,
    palette: ["#0b1020", "#22D3EE", "#64748b"],
    motif: "wave",
  },
  {
    id: "echo-room",
    name: "Echo Room",
    genre: "Alt R&B",
    songCount: 12,
    palette: ["#1c1917", "#EC4899", "#f59e0b"],
    motif: "bars",
  },
  {
    id: "aether-mill",
    name: "Aether Mill",
    genre: "Cinematic",
    songCount: 8,
    palette: ["#0f172a", "#8B5CF6", "#22D3EE"],
    motif: "orbit",
  },
  {
    id: "satin-noise",
    name: "Satin Noise",
    genre: "Indie electronic",
    songCount: 15,
    palette: ["#18181b", "#a78bfa", "#EC4899"],
    motif: "rings",
  },
];

export const songs: Song[] = [
  {
    id: "s1",
    title: "Frequency Shift",
    artist: "Nova Veil",
    artistId: "nova-veil",
    duration: "3:42",
    seconds: 222,
  },
  {
    id: "s2",
    title: "Night Circuit",
    artist: "Kairo",
    artistId: "kairo",
    duration: "4:08",
    seconds: 248,
  },
  {
    id: "s3",
    title: "Glass Harbor",
    artist: "Lumen Arc",
    artistId: "lumen-arc",
    duration: "5:16",
    seconds: 316,
  },
  {
    id: "s4",
    title: "Magenta Heat",
    artist: "Violet Static",
    artistId: "violet-static",
    duration: "2:57",
    seconds: 177,
  },
  {
    id: "s5",
    title: "Below the Line",
    artist: "Low Signal",
    artistId: "low-signal",
    duration: "4:44",
    seconds: 284,
  },
  {
    id: "s6",
    title: "Soft Collision",
    artist: "Echo Room",
    artistId: "echo-room",
    duration: "3:21",
    seconds: 201,
  },
  {
    id: "s7",
    title: "Atlas Bloom",
    artist: "Aether Mill",
    artistId: "aether-mill",
    duration: "6:02",
    seconds: 362,
  },
  {
    id: "s8",
    title: "Quiet Voltage",
    artist: "Satin Noise",
    artistId: "satin-noise",
    duration: "3:33",
    seconds: 213,
  },
];
