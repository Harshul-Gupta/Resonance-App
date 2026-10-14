import { useCallback, useEffect, useRef, useState } from "react";

export function useSongPlayer() {
  const audio = useRef<HTMLAudioElement | null>(null);
  const [currentId, setCurrentId] = useState<string | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);

  useEffect(() => {
    const a = new Audio();
    a.preload = "none";
    a.onplay = () => setIsPlaying(true);
    a.onpause = () => setIsPlaying(false);
    a.onended = () => setIsPlaying(false);
    audio.current = a;
    return () => {
      a.pause();
      a.src = "";
    };
  }, []);

  const toggle = useCallback(
    (id: string, url: string) => {
      const a = audio.current;
      if (!a) return;
      if (currentId === id) {
        if (a.paused) void a.play();
        else a.pause();
        return;
      }
      a.src = url;
      setCurrentId(id);
      void a.play().catch(() => setIsPlaying(false));
    },
    [currentId]
  );

  return { currentId, isPlaying, toggle };
}