export function Footer() {
  return (
    <footer className="border-t border-white/10 px-6 py-12">
      <div className="mx-auto flex max-w-6xl flex-col gap-8 md:flex-row md:items-end md:justify-between">
        <div>
          <p className="font-display text-sm font-bold uppercase tracking-[0.28em]">
            Resonance
          </p>
          <p className="mt-2 text-sm text-mute">Music that moves with you.</p>
        </div>
        <nav className="flex flex-wrap gap-x-6 gap-y-2 text-sm text-mute">
          <a href="#discover" className="hover:text-paper">
            Explore
          </a>
          <a href="#artists" className="hover:text-paper">
            Artists
          </a>
          <a href="#songs" className="hover:text-paper">
            Songs
          </a>
          <a href="https://github.com/Harshul-Gupta/Resonance-App" className="hover:text-paper">
            About
          </a>
          <a href="#login" className="hover:text-paper">
            Login
          </a>
        </nav>
      </div>
      <p className="mx-auto mt-10 max-w-6xl text-xs text-mute">© 2026 Resonance</p>
	  <p className="mx-auto mt-10 max-w-6xl text-xs text-mute">This is a side project made to learn and practice backend concepts -Harshul Gupta</p>
    </footer>
  );
}
