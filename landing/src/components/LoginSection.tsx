import { motion } from "framer-motion";
import { FormEvent, useState } from "react";
import { appUrl } from "../api";
import { useSession } from "../hooks/useSession";
import { MagneticButton } from "./MagneticButton";

export function LoginSection() {
  const { user, checked, signIn, signOut } = useSession();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const onSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (busy) return;
    setBusy(true);
    setError(null);
    const msg = await signIn(username, password);
    setBusy(false);
    setError(msg);
    if (!msg) setPassword("");
  };

  return (
    <section id="login" className="relative px-6 py-28">
      <div className="mx-auto grid max-w-6xl items-center gap-16 lg:grid-cols-[1.1fr_0.9fr]">
        <div>
          <motion.h2
            initial={{ y: 40, filter: "blur(16px)", opacity: 0 }}
            whileInView={{ y: 0, filter: "blur(0px)", opacity: 1 }}
            viewport={{ once: true, amount: 0.5 }}
            transition={{ duration: 0.8 }}
            className="font-grotesk text-[clamp(2.2rem,6vw,4.6rem)] font-medium leading-[0.92] tracking-tightest"
          >
            Enter the
            <br />
            frequency.
          </motion.h2>
          <p className="mt-6 max-w-md text-mute">
            Sign in to manage artists, songs, and a collection that stays in
            tune with you.
          </p>
        </div>

        <motion.div
          initial={{ rotateY: 12, opacity: 0 }}
          whileInView={{ rotateY: 0, opacity: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
          className="rounded-3xl border border-white/10 bg-white/[0.04] p-8 shadow-[0_40px_80px_rgba(0,0,0,0.45)] backdrop-blur-xl"
          style={{ transformStyle: "preserve-3d" }}
        >
          {!checked ? (
            <div className="h-72 animate-pulse rounded-2xl bg-white/5" />
          ) : user ? (
            <div>
              <p className="font-display text-sm uppercase tracking-[0.22em] text-cyan">
                Signed in
              </p>
              <p className="mt-4 font-grotesk text-3xl">{user.username}</p>
              <p className="mt-2 text-sm text-mute">
                Your library and collection are ready.
              </p>
              <div className="mt-8 flex flex-wrap items-center gap-3">
                <MagneticButton href={appUrl("/library")}>Open library</MagneticButton>
                <MagneticButton onClick={() => void signOut()}>Log out</MagneticButton>
              </div>
            </div>
          ) : (
            <form onSubmit={onSubmit}>
              <p className="font-display text-sm uppercase tracking-[0.22em] text-cyan">
                Welcome back
              </p>
              <h3 className="mt-3 font-grotesk text-3xl">Sign in</h3>
              {error && (
                <p className="mt-4 rounded-xl border border-pink/30 bg-pink/10 px-3 py-2 text-sm text-pink" role="alert">
                  {error}
                </p>
              )}
              <label className="mt-6 block text-[11px] font-medium uppercase tracking-[0.14em] text-mute" htmlFor="login-username">
                Username
              </label>
              <input
                id="login-username"
                name="username"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                autoComplete="username"
                className="mt-2 h-12 w-full rounded-xl border border-white/10 bg-white/5 px-4 text-paper outline-none focus:border-violet/60"
                required
              />
              <label className="mt-5 block text-[11px] font-medium uppercase tracking-[0.14em] text-mute" htmlFor="login-password">
                Password
              </label>
              <input
                id="login-password"
                name="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                autoComplete="current-password"
                className="mt-2 h-12 w-full rounded-xl border border-white/10 bg-white/5 px-4 text-paper outline-none focus:border-violet/60"
                required
              />
              <div className="mt-8">
                <MagneticButton type="submit" className="w-full">
                  {busy ? "Signing in…" : "Sign in"}
                </MagneticButton>
              </div>
              <div className="mt-5 flex items-center justify-between text-sm">
                <a href={appUrl("/oauth2/authorization/google")} className="text-mute hover:text-paper">
                  Continue with Google
                </a>
                <a href={appUrl("/register")} className="text-mute hover:text-paper">
                  Create an account
                </a>
              </div>
            </form>
          )}
        </motion.div>
      </div>
    </section>
  );
}