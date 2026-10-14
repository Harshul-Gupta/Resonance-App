import { motion, useScroll, useSpring, useTransform, type MotionValue } from "framer-motion";
import { useRef } from "react";

// Any of these formats, bundled at build time (hashed names under /landing-assets/)
const images = Object.entries(
  import.meta.glob<string>("../assets/discover/*.{webp,jpg,jpeg,png,avif}", {
    eager: true,
    import: "default",
  })
).map(([path, src]) => ({
  key: path.split("/").pop()!.replace(/\.\w+$/, ""),
  src,
}));

const floats = [
  { top: "8%", left: "6%", w: "w-36 md:w-48", speed: 1.15, rot: -8 },
  { top: "18%", left: "72%", w: "w-44 md:w-56", speed: 0.7, rot: 10 },
  { top: "52%", left: "8%", w: "w-40 md:w-52", speed: 1.4, rot: 6 },
  { top: "58%", left: "62%", w: "w-32 md:w-44", speed: 0.9, rot: -12 },
  { top: "28%", left: "42%", w: "w-28 md:w-36", speed: 1.8, rot: 4 },
  { top: "74%", left: "38%", w: "w-36 md:w-40", speed: 0.55, rot: 14 },
];

export function DiscoverSection() {
  const ref = useRef<HTMLElement>(null);

  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start end", "end start"],
  });
  // wheel notches become continuous motion
  const smooth = useSpring(scrollYProgress, {
    stiffness: 80,
    damping: 26,
    mass: 0.4,
    restDelta: 0.0005,
  });

  const headlineX = useTransform(smooth, [0, 1], ["-8%", "8%"]);
  const copyY = useTransform(smooth, [0, 1], [40, -40]);
  const copyOpacity = useTransform(smooth, [0.12, 0.34], [0.2, 1]);

  return (
    <section
      id="discover"
      ref={ref}
      className="relative min-h-[140vh] overflow-hidden px-6 py-32"
    >
      <div className="pointer-events-none absolute inset-0">
        {images.slice(0, floats.length).map((img, i) => (
          <FloatingSleeve key={img.key} src={img.src} config={floats[i]!} progress={smooth} />
        ))}
      </div>

      <div className="relative z-10 mx-auto max-w-5xl pt-[18vh]">
        <motion.h2
          style={{ x: headlineX }}
          className="font-grotesk text-[clamp(2.6rem,8vw,6.5rem)] font-medium leading-[0.9] tracking-tightest"
        >
          Music without
          <br />
          limits.
        </motion.h2>
        <motion.p
          style={{ y: copyY, opacity: copyOpacity }}
          className="mt-8 max-w-md text-lg text-mute"
        >
          Explore artists, discover new sounds, and keep the music that matters
          to you close.
        </motion.p>
      </div>
    </section>
  );
}

function FloatingSleeve({
  src,
  config,
  progress,
}: {
  src: string;
  config: (typeof floats)[number];
  progress: MotionValue<number>;
}) {
  const y = useTransform(progress, [0, 1], [80 * config.speed, -180 * config.speed]);
  const rotate = useTransform(progress, [0, 1], [config.rot, config.rot + 8 * config.speed]);

  return (
    <motion.div
      style={{ top: config.top, left: config.left, y, rotate, willChange: "transform" }}
      className={`absolute ${config.w} aspect-square overflow-hidden rounded-sm shadow-[0_18px_40px_rgba(0,0,0,0.5)]`}
    >
      <img
        src={src}
        alt=""
        width={640}
        height={640}
        decoding="async"
        draggable={false}
        className="h-full w-full object-cover"
      />
    </motion.div>
  );
}