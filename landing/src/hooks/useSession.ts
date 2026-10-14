import { useEffect, useSyncExternalStore } from "react";

export type SessionUser = { username: string; initials: string };
type State = { user: SessionUser | null; checked: boolean };

let state: State = { user: null, checked: false };
const listeners = new Set<() => void>();
const subscribe = (l: () => void) => {
  listeners.add(l);
  return () => listeners.delete(l);
};
const getState = () => state;
const setState = (s: State) => {
  state = s;
  listeners.forEach((l) => l());
};

function initials(name: string) {
  const parts = name.trim().split(/[\s._-]+/).filter(Boolean);
  const letters =
    parts.length > 1 ? parts[0]!.charAt(0) + parts[1]!.charAt(0) : name.trim().slice(0, 2);
  return letters.toUpperCase();
}

async function check() {
  try {
    const res = await fetch("/api/artists/me", {
      credentials: "include",
	  cache: "no-store",
      headers: { Accept: "application/json" },
    });
    if (res.status === 200 && res.headers.get("content-type")?.includes("application/json")) {
      const d = (await res.json()) as { username?: string };
      if (d.username) {
        setState({ user: { username: d.username, initials: initials(d.username) }, checked: true });
        return;
      }
    }
  } catch {
    /* unreachable server: treat as signed out */
  }
  setState({ user: null, checked: true });
}

let inflight: Promise<void> | null = null;
export function refreshSession() {
  if (!inflight) inflight = check().finally(() => (inflight = null));
  return inflight;
}

/** Returns an error message, or null on success. */
export async function signIn(username: string, password: string): Promise<string | null> {
  try {
    const res = await fetch("/login", {
      method: "POST",
      credentials: "include",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ username, password }),
    });
    // Spring answers with a redirect; fetch follows it. Failure lands on /login?error=true
    if (new URL(res.url).searchParams.has("error")) return "Invalid username or password.";
    await refreshSession();
    return state.user ? null : "Couldn't sign in. Please try again.";
  } catch {
    return "Can't reach the server. Please try again.";
  }
}

export async function signOut() {
  try {
    await fetch("/logout", { method: "POST", credentials: "include" });
  } catch {
    /* fall through to the check below */
  }
  await refreshSession(); // reflects what the server says
}

// coming back via the browser's back button should not show a stale state
window.addEventListener("pageshow", (e) => {
  if ((e as PageTransitionEvent).persisted) void refreshSession();
});

export function useSession() {
  const s = useSyncExternalStore(subscribe, getState, getState);
  useEffect(() => {
    if (!state.checked) void refreshSession();
  }, []);
  return { user: s.user, checked: s.checked, signIn, signOut };
}