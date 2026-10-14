import type { Artist } from "../data/catalog";

type Props = {
	artist: Pick<Artist, "id" | "name" | "palette" | "motif">;
	className?: string;
};

export function AlbumArt({ artist, className = "" }: Props) {
  const [a, b, c] = artist.palette;
  const id = artist.id.replace(/[^a-z0-9-]/gi, "");

  return (
    <svg
      viewBox="0 0 400 400"
      className={`h-full w-full object-cover ${className}`}
      role="img"
      aria-label={`${artist.name} artwork`}
    >
      <defs>
        <linearGradient id={`${id}-g`} x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stopColor={a} />
          <stop offset="55%" stopColor={b} />
          <stop offset="100%" stopColor={c} />
        </linearGradient>
        <radialGradient id={`${id}-r`} cx="30%" cy="25%" r="80%">
          <stop offset="0%" stopColor="rgba(255,255,255,0.28)" />
          <stop offset="100%" stopColor="rgba(0,0,0,0)" />
        </radialGradient>
      </defs>
      <rect width="400" height="400" fill={`url(#${id}-g)`} />
      <rect width="400" height="400" fill={`url(#${id}-r)`} />

      {artist.motif === "rings" &&
        [60, 110, 160, 210].map((r) => (
          <circle
            key={r}
            cx="210"
            cy="190"
            r={r}
            fill="none"
            stroke="rgba(255,255,255,0.18)"
            strokeWidth="1.2"
          />
        ))}

      {artist.motif === "orbit" && (
        <>
          <ellipse
            cx="200"
            cy="200"
            rx="150"
            ry="54"
            fill="none"
            stroke="rgba(255,255,255,0.22)"
            transform="rotate(-18 200 200)"
          />
          <ellipse
            cx="200"
            cy="200"
            rx="120"
            ry="40"
            fill="none"
            stroke="rgba(255,255,255,0.16)"
            transform="rotate(32 200 200)"
          />
          <circle cx="310" cy="150" r="10" fill={c} />
        </>
      )}

      {artist.motif === "grid" &&
        Array.from({ length: 8 }).map((_, i) => (
          <g key={i} stroke="rgba(255,255,255,0.12)">
            <line x1={40 + i * 40} y1="20" x2={40 + i * 40} y2="380" />
            <line x1="20" y1={40 + i * 40} x2="380" y2={40 + i * 40} />
          </g>
        ))}

      {artist.motif === "wave" && (
        <path
          d="M0 240 C 60 180, 120 300, 180 220 S 300 140, 400 210 L 400 400 L 0 400 Z"
          fill="rgba(0,0,0,0.28)"
        />
      )}

      {artist.motif === "bars" &&
        [80, 130, 180, 230, 280].map((x, i) => (
          <rect
            key={x}
            x={x}
            y={90 + (i % 3) * 20}
            width="28"
            height={180 - i * 12}
            fill="rgba(255,255,255,0.16)"
            rx="4"
          />
        ))}

      {artist.motif === "prism" && (
        <polygon
          points="200,50 340,320 60,320"
          fill="none"
          stroke="rgba(255,255,255,0.28)"
          strokeWidth="2"
        />
      )}

      <circle cx="200" cy="200" r="18" fill="rgba(5,5,5,0.55)" />
      <circle cx="200" cy="200" r="6" fill={b} />
    </svg>
  );
}
