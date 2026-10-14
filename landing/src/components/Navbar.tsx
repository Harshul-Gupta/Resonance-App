import { AnimatePresence, motion } from "framer-motion";
import { useEffect, useRef, useState } from "react";
import { useSession } from "../hooks/useSession";
import { appUrl } from "../api";

function LogoMark() {
  return (
    <svg viewBox="0 0 32 32" className="h-8 w-8" aria-hidden="true">
      <circle
        cx="16"
        cy="16"
        r="15"
        fill="none"
        stroke="url(#nav-g)"
        strokeWidth="1.5"
      />
      <circle
        cx="16"
        cy="16"
        r="9"
        fill="none"
        stroke="rgba(255,255,255,0.25)"
        strokeWidth="0.8"
      />
      <circle cx="16" cy="16" r="3" fill="#A78BFA" />
      <defs>
        <linearGradient id="nav-g" x1="0" y1="0" x2="32" y2="32">
          <stop stopColor="#A78BFA" />
          <stop offset="1" stopColor="#67E8F9" />
        </linearGradient>
      </defs>
    </svg>
  );
}

export function Navbar() {
  const { user, signOut } = useSession();
  const [open, setOpen] = useState(false);
  const wrap = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const onDoc = (e: MouseEvent) => {
      if (!wrap.current?.contains(e.target as Node)) setOpen(false);
    };

    document.addEventListener("mousedown", onDoc);
    return () => document.removeEventListener("mousedown", onDoc);
  }, []);

  return (
    <header className="pointer-events-none fixed inset-x-0 top-0 z-50 p-4 md:p-6">
      <nav
        className="
          pointer-events-auto mx-auto flex max-w-6xl items-center
          justify-between rounded-2xl
          border border-white/[0.14]
          bg-gradient-to-b from-white/[0.11] to-white/[0.04]
          px-4 py-3
          shadow-[0_8px_32px_rgba(0,0,0,0.28),inset_0_1px_0_rgba(255,255,255,0.10)]
          backdrop-blur-2xl backdrop-saturate-150
          md:px-5
        "
      >
        <a href="/" className="flex items-center gap-2.5">
          <LogoMark />
          <span className="font-display text-[15px] font-bold uppercase tracking-[0.18em] text-paper">
            Resonance
          </span>
        </a>

        <div className="flex items-center gap-2 md:gap-3">
          <a
            href={appUrl("/library")}
            className="
              rounded-xl border border-white/[0.16]
              bg-white/[0.12] px-4 py-2
              text-sm font-semibold text-paper
              shadow-[inset_0_1px_0_rgba(255,255,255,0.12)]
              backdrop-blur-xl
              transition-all duration-200
              hover:-translate-y-0.5 hover:bg-white/[0.20]
              hover:border-white/[0.24]
              active:scale-[0.97]
            "
          >
            Library
          </a>

          {user ? (
            <div className="relative" ref={wrap}>
              <button
                type="button"
                onClick={() => setOpen((v) => !v)}
                aria-haspopup="true"
                aria-expanded={open}
                className="
                  flex cursor-pointer items-center gap-2 rounded-full
                  border border-white/[0.14]
                  bg-white/[0.07] py-1 pl-1 pr-3
                  shadow-[inset_0_1px_0_rgba(255,255,255,0.08)]
                  transition-colors hover:bg-white/[0.13]
                "
              >
                <span className="flex h-7 w-7 items-center justify-center rounded-full border border-white/10 bg-gradient-to-br from-zinc-500/80 to-zinc-800 text-[11px] font-bold uppercase text-white">
                  {user.initials}
                </span>

                <span className="hidden max-w-[110px] truncate text-sm font-semibold text-white/90 md:inline">
                  {user.username}
                </span>

                <svg
                  width="12"
                  height="12"
                  viewBox="0 0 24 24"
                  fill="none"
                  aria-hidden="true"
                  className={`transition-transform duration-200 ${open ? "rotate-180" : ""}`}
                >
                  <polyline
                    points="6 9 12 15 18 9"
                    stroke="currentColor"
                    strokeWidth="2.5"
                    strokeLinecap="round"
                  />
                </svg>
              </button>

              <AnimatePresence>
                {open && (
                  <motion.div
                    initial={{ opacity: 0, y: 8, scale: 0.97 }}
                    animate={{ opacity: 1, y: 0, scale: 1 }}
                    exit={{ opacity: 0, y: 6, scale: 0.98 }}
                    transition={{ duration: 0.16, ease: "easeOut" }}
                    className="
                      absolute right-0 top-[calc(100%+10px)]
                      min-w-[180px] overflow-hidden rounded-xl
                      border border-white/[0.14]
                      bg-zinc-800/80 p-1
                      shadow-[0_16px_40px_rgba(0,0,0,0.4)]
                      backdrop-blur-2xl
                    "
                    role="menu"
                  >
                    <a
                      href={appUrl("/login")}
                      className="block rounded-lg px-3 py-2 text-sm text-white/80 transition-colors hover:bg-white/[0.10] hover:text-white"
                      role="menuitem"
                      onClick={() => setOpen(false)}
                    >
                      Profile
                    </a>

					<button
					  type="button"
					  role="menuitem"
					  className="block w-full rounded-lg px-3 py-2 text-left text-sm text-white/80 transition-colors hover:bg-white/[0.10] hover:text-white"
					  onClick={() => {
					    setOpen(false);
					    void signOut();
					  }}
					>
					  Log out
					</button>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          ) : (
            <a
              href={appUrl("/login")}
              className="
                rounded-xl border border-white/[0.08]
                px-3 py-2 text-sm font-semibold text-white/65
                transition-all duration-200
                hover:border-white/[0.14]
                hover:bg-white/[0.06] hover:text-white
              "
            >
              Log in
            </a>
          )}
        </div>
      </nav>
    </header>
  );
}