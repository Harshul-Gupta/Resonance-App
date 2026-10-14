import { useEffect, useState } from "react";

export async function getJson<T>(path: string, signal?: AbortSignal): Promise<T> {
  const res = await fetch(path, { signal, headers: { Accept: "application/json" } });
  if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);
  if (!res.headers.get("content-type")?.includes("application/json")) {
    throw new Error("Expected JSON (probably redirected to login)");
  }
  return res.json() as Promise<T>;
}

export const appUrl = (path: string) =>
  (import.meta.env.DEV ? "http://localhost:8080" : "") + path;

export function useApi<T>(path: string) {
  const [data, setData] = useState<T | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const ctrl = new AbortController();
    setLoading(true);
    setError(null);
    getJson<T>(path, ctrl.signal)
      .then(setData)
      .catch((e: Error) => {
        if (e.name !== "AbortError") setError(e.message);
      })
      .finally(() => {
        if (!ctrl.signal.aborted) setLoading(false);
      });
    return () => ctrl.abort();
  }, [path]);

  return { data, error, loading };
}