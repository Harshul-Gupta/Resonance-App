import { motion, useReducedMotion } from "framer-motion";
import { useEffect, useRef, useState } from "react";

// Palette tuned for the #050505 background
const VIOLET = "#7c5cff";
const PINK = "#e0489a";
const CYAN = "#22d3ee";

const orbs = [
  { color: VIOLET, size: 540, className: "-left-36 -top-36", dx: 80, dy: -40, dur: 18, opacity: 0.35 },
  { color: PINK, size: 480, className: "-bottom-40 -right-24", dx: -70, dy: 50, dur: 22, opacity: 0.28 },
  { color: CYAN, size: 360, className: "left-[50%] top-[30%]", dx: 60, dy: 70, dur: 26, opacity: 0.18 },
];

function useMotionScale() {
  const reduce = useReducedMotion();
  return reduce ? 0.35 : 1;
}

function Equalizer() {
  const ref = useRef<HTMLCanvasElement>(null);
  const scale = useMotionScale();
  const scaleRef = useRef(scale);
  scaleRef.current = scale;

  useEffect(() => {
    const canvas = ref.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    let W = 0;
    let H = 0;
    let targetMx = 0.5;
    let currentMx = 0.5; // Smooth interpolation for cursor interaction
    let raf = 0;
    let phase = 0;
    let last = performance.now();

    const resize = () => {
      const d = window.devicePixelRatio || 1;
      W = canvas.clientWidth;
      H = canvas.clientHeight;
      canvas.width = W * d;
      canvas.height = H * d;
      ctx.setTransform(d, 0, 0, d, 0, 0);
    };

    const onMove = (e: PointerEvent) => {
      targetMx = e.clientX / window.innerWidth;
    };

    const draw = (now: number) => {
      const deltaTime = now - last;
      phase += deltaTime * scaleRef.current;
      last = now;

      // Smoothly slide the mouse influence toward the cursor
      currentMx += (targetMx - currentMx) * 0.08;

      ctx.clearRect(0, 0, W, H);
      const gap = 14;
      const barWidth = 8;
      const bars = Math.floor(W / gap);
      
      const grad = ctx.createLinearGradient(0, 0, W, 0);
      grad.addColorStop(0, VIOLET);
      grad.addColorStop(0.5, PINK);
      grad.addColorStop(1, CYAN);
      ctx.fillStyle = grad;

      for (let i = 0; i < bars; i++) {
        const u = i / bars;
        
        // Physics-driven hover bulge using Gaussian distribution
        const distance = Math.abs(u - currentMx);
        const boost = Math.exp(-Math.pow(distance * 6, 2)) * 0.55;
        
        // Multi-frequency wave synchronization
        const wave1 = Math.sin(phase / 400 + i * 0.25);
        const wave2 = Math.sin(phase / 700 + i * 0.12) * 0.7;
        const wave3 = Math.cos(phase / 1200 - i * 0.08) * 0.4;
        
        const combinedWave = (wave1 + wave2 + wave3 + 2.1) / 4.2;
        const finalAmplitude = combinedWave + boost;
        const h = Math.max(8, finalAmplitude * H * 0.85);
        
        ctx.globalAlpha = 0.15 + finalAmplitude * 0.55;
        ctx.beginPath();
        if (typeof ctx.roundRect === "function") {
          ctx.roundRect(i * gap, H - h, barWidth, h, 4);
        } else {
          ctx.rect(i * gap, H - h, barWidth, h);
        }
        ctx.fill();
      }
	  const io = new IntersectionObserver(([entry]) => {
	    cancelAnimationFrame(raf);
	    if (entry?.isIntersecting) {
	      last = performance.now(); // avoids a big time jump on resume
	      raf = requestAnimationFrame(draw);
	    }
	  });
	  io.observe(canvas);
    };

    resize();
    window.addEventListener("resize", resize);
    window.addEventListener("pointermove", onMove);
    raf = requestAnimationFrame(draw);
    
    return () => {
	  
      cancelAnimationFrame(raf);
      window.removeEventListener("resize", resize);
      window.removeEventListener("pointermove", onMove);
    };
  }, []);

  return (
    <canvas
      ref={ref}
      aria-hidden="true"
      className="absolute inset-x-0 bottom-0 h-[45%] w-full [mask-image:linear-gradient(to_top,black_50%,transparent)]"
    />
  );
}

const HERO_VIDEO =
  "https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260815_030633_1712fc71-4979-4e14-98f9-9f95702ab3da.mp4";

// How visible the video is: lower = subtler/darker, higher = brighter
const VIDEO_OPACITY = 0.55;

function BackgroundVideo({ src }: { src: string }) {
  const ref = useRef<HTMLVideoElement>(null);
  const [ready, setReady] = useState(false);
  const [failed, setFailed] = useState(false);

  // play only while the hero is on screen
  useEffect(() => {
    const v = ref.current;
    if (!v) return;
    const io = new IntersectionObserver(([e]) => {
      if (e?.isIntersecting) void v.play().catch(() => {});
      else v.pause();
    });
    io.observe(v);
    return () => io.disconnect();
  }, []);

  if (failed) return null; // falls back to the plain dark background

  return (
    <video
      ref={ref}
      src={src}
      autoPlay
      muted
      loop
      playsInline
      preload="auto"
      disablePictureInPicture
      onCanPlay={() => setReady(true)}
      onError={() => setFailed(true)}
      className="absolute inset-0 h-full w-full object-cover transition-opacity duration-1000"
      style={{ opacity: ready ? VIDEO_OPACITY : 0 }}
    />
  );
}

export function HeroBackdrop({ videoSrc = HERO_VIDEO }: { videoSrc?: string }) {
  const scale = useMotionScale();
  const slow = 1 / scale;
  const reduce = useReducedMotion();

  return (
    <div aria-hidden="true" className="pointer-events-none absolute inset-0 -z-10 overflow-hidden bg-[#050505]">
      {!reduce && <BackgroundVideo src={videoSrc} />}

      {/* dark scrim keeps the video subtle and the headline readable */}
      <div className="absolute inset-0 bg-gradient-to-b from-[#050505]/70 via-[#050505]/35 to-[#050505]/80" />

      {/* Floating orbs */}
      {orbs.map((o, i) => (
        <motion.div
          key={i}
          className={`absolute rounded-full blur-[130px] mix-blend-screen ${o.className}`}
          style={{ width: o.size, height: o.size, background: o.color, opacity: o.opacity }}
          animate={{
            x: [0, o.dx, o.dx * -0.3, 0],
            y: [0, o.dy, o.dy * 0.4, 0],
            scale: [1, 1.18, 0.92, 1],
          }}
          transition={{
            duration: o.dur * slow,
            repeat: Infinity,
            ease: "easeInOut",
          }}
        />
      ))}

      <Equalizer />
    </div>
  );
}