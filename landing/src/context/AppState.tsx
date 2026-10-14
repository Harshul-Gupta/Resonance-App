import {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import { artists, songs, type Artist, type Song } from "../data/catalog";

const USER_KEY = "resonance.user";
const COLLECTION_KEY = "resonance.collection";
const FAV_KEY = "resonance.favorites";

export type User = {
  username: string;
  initials: string;
};

type Collection = {
  artistIds: string[];
  songIds: string[];
};

type AppState = {
  user: User | null;
  query: string;
  setQuery: (q: string) => void;
  login: (username: string, password: string) => string | null;
  logout: () => void;
  currentSongId: string | null;
  isPlaying: boolean;
  togglePlay: (songId: string) => void;
  favorites: string[];
  toggleFavorite: (songId: string) => void;
  collection: Collection;
  addArtist: (id: string) => void;
  removeArtist: (id: string) => void;
  addSong: (id: string) => void;
  removeSong: (id: string) => void;
  artists: Artist[];
  songs: Song[];
};

const Ctx = createContext<AppState | null>(null);

function initialsFrom(name: string) {
  const parts = name.trim().split(/\s+/);
  if (parts.length === 1) return name.slice(0, 2).toUpperCase();
  return `${parts[0]?.[0] ?? ""}${parts[1]?.[0] ?? ""}`.toUpperCase();
}

function readJson<T>(key: string, fallback: T): T {
  try {
    const raw = localStorage.getItem(key);
    return raw ? (JSON.parse(raw) as T) : fallback;
  } catch {
    return fallback;
  }
}

export function AppStateProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(() =>
    readJson<User | null>(USER_KEY, null)
  );
  const [query, setQuery] = useState("");
  const [currentSongId, setCurrentSongId] = useState<string | null>(songs[0]?.id ?? null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [favorites, setFavorites] = useState<string[]>(() =>
    readJson<string[]>(FAV_KEY, ["s1", "s4"])
  );
  const [collection, setCollection] = useState<Collection>(() =>
    readJson<Collection>(COLLECTION_KEY, {
      artistIds: ["nova-veil", "kairo"],
      songIds: ["s1", "s2", "s6"],
    })
  );

  const login = useCallback((username: string, password: string) => {
    if (!username.trim() || !password.trim()) {
      return "Enter a username and password.";
    }
    if (password.trim().length < 4) {
      return "Password must be at least 4 characters.";
    }
    const next = { username: username.trim(), initials: initialsFrom(username) };
    setUser(next);
    localStorage.setItem(USER_KEY, JSON.stringify(next));
    return null;
  }, []);

  const logout = useCallback(() => {
    setUser(null);
    localStorage.removeItem(USER_KEY);
  }, []);

  const togglePlay = useCallback((songId: string) => {
    setCurrentSongId((prev) => {
      if (prev === songId) {
        setIsPlaying((p) => !p);
        return prev;
      }
      setIsPlaying(true);
      return songId;
    });
  }, []);

  const toggleFavorite = useCallback((songId: string) => {
    setFavorites((prev) => {
      const next = prev.includes(songId)
        ? prev.filter((id) => id !== songId)
        : [...prev, songId];
      localStorage.setItem(FAV_KEY, JSON.stringify(next));
      return next;
    });
  }, []);

  const persistCollection = (next: Collection) => {
    localStorage.setItem(COLLECTION_KEY, JSON.stringify(next));
    return next;
  };

  const addArtist = useCallback((id: string) => {
    setCollection((prev) => {
      if (prev.artistIds.includes(id)) return prev;
      return persistCollection({ ...prev, artistIds: [...prev.artistIds, id] });
    });
  }, []);

  const removeArtist = useCallback((id: string) => {
    setCollection((prev) =>
      persistCollection({
        ...prev,
        artistIds: prev.artistIds.filter((a) => a !== id),
      })
    );
  }, []);

  const addSong = useCallback((id: string) => {
    setCollection((prev) => {
      if (prev.songIds.includes(id)) return prev;
      return persistCollection({ ...prev, songIds: [...prev.songIds, id] });
    });
  }, []);

  const removeSong = useCallback((id: string) => {
    setCollection((prev) =>
      persistCollection({
        ...prev,
        songIds: prev.songIds.filter((s) => s !== id),
      })
    );
  }, []);

  const value = useMemo(
    () => ({
      user,
      query,
      setQuery,
      login,
      logout,
      currentSongId,
      isPlaying,
      togglePlay,
      favorites,
      toggleFavorite,
      collection,
      addArtist,
      removeArtist,
      addSong,
      removeSong,
      artists,
      songs,
    }),
    [
      user,
      query,
      login,
      logout,
      currentSongId,
      isPlaying,
      togglePlay,
      favorites,
      toggleFavorite,
      collection,
      addArtist,
      removeArtist,
      addSong,
      removeSong,
    ]
  );

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

export function useAppState() {
  const ctx = useContext(Ctx);
  if (!ctx) throw new Error("useAppState must be used within AppStateProvider");
  return ctx;
}
