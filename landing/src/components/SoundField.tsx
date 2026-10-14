import { useEffect, useRef } from "react";
import { usePrefersReducedMotion } from "../hooks/usePrefersReducedMotion";

type Particle = {
  x: number;
  y: number;
  vx: number;
  vy: number;
  r: number;
  a: number;
};

type Props = {
  intensity?: number;
  className?: string;
};

export function SoundField({ intensity = 1, className = "" }: Props) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const reduced = usePrefersReducedMotion();

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d", { alpha: true });
    if (!ctx) return;

    const mouse = { x: 0.5, y: 0.5, tx: 0.5, ty: 0.5 };
    let raf = 0;
    let running = true;
    const particles: Particle[] = [];

    const resize = () => {
      const dpr = Math.min(window.devicePixelRatio || 1, 1.75);
      const { width, height } = canvas.getBoundingClientRect();
      canvas.width = Math.max(1, Math.floor(width * dpr));
      canvas.height = Math.max(1, Math.floor(height * dpr));
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    };

    const seedParticles = () => {
      particles.length = 0;
      const count = reduced ? 12 : 48;
      const { width, height } = canvas.getBoundingClientRect();
      for (let i = 0; i < count; i += 1) {
        particles.push({
          x: Math.random() * width,
          y: Math.random() * height,
          vx: (Math.random() - 0.5) * 0.25,
          vy: (Math.random() - 0.5) * 0.35,
          r: Math.random() * 1.6 + 0.4,
          a: Math.random() * 0.4 + 0.08,
        });
      }
    };

    const onMove = (e: PointerEvent) => {
      const rect = canvas.getBoundingClientRect();
      mouse.tx = (e.clientX - rect.left) / rect.width;
      mouse.ty = (e.clientY - rect.top) / rect.height;
    };

    const drawWave = (
      t: number,
      width: number,
      height: number,
      layer: number
    ) => {
      const amp =
        (28 + Math.sin(t * 0.0007 + layer) * 18) * intensity * (reduced ? 0.25 : 1);
      const baseY = height * (0.42 + layer * 0.08);
      const mx = mouse.x * width;
      const my = mouse.y * height;
      const radius = 180 + layer * 40;

      ctx.beginPath();
      const steps = Math.max(80, Math.floor(width / 8));
      for (let i = 0; i <= steps; i += 1) {
        const x = (i / steps) * width;
        const n =
          Math.sin(x * 0.008 + t * 0.0012 + layer) * 0.55 +
          Math.sin(x * 0.018 + t * 0.0008 + layer * 1.7) * 0.3 +
          Math.sin(x * 0.004 + t * 0.0004) * 0.2;
        let y = baseY + n * amp;
        const dx = x - mx;
        const dy = y - my;
        const dist = Math.hypot(dx, dy);
        const influence = Math.exp(-(dist * dist) / (2 * radius * radius));
        y += (my - baseY) * influence * 0.42 * intensity;
        y += Math.sin(dist * 0.04 - t * 0.003) * influence * 18 * intensity;
        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      }

      const grad = ctx.createLinearGradient(0, 0, width, 0);
      if (layer % 2 === 0) {
        grad.addColorStop(0, "rgba(139,92,246,0)");
        grad.addColorStop(0.35, `rgba(139,92,246,${0.45 * intensity})`);
        grad.addColorStop(0.7, `rgba(34,211,238,${0.4 * intensity})`);
        grad.addColorStop(1, "rgba(236,72,153,0)");
      } else {
        grad.addColorStop(0, "rgba(34,211,238,0)");
        grad.addColorStop(0.5, `rgba(139,92,246,${0.28 * intensity})`);
        grad.addColorStop(1, "rgba(34,211,238,0)");
      }
      ctx.strokeStyle = grad;
      ctx.lineWidth = layer === 1 ? 2.2 : 1.15;
      ctx.shadowColor = "rgba(139,92,246,0.35)";
      ctx.shadowBlur = reduced ? 0 : 8;
      ctx.stroke();
      ctx.shadowBlur = 0;
    };

    const tick = (t: number) => {
      if (!running) return;
      const { width, height } = canvas.getBoundingClientRect();
      mouse.x += (mouse.tx - mouse.x) * 0.06;
      mouse.y += (mouse.ty - mouse.y) * 0.06;
      ctx.clearRect(0, 0, width, height);

      for (let layer = 0; layer < 4; layer += 1) {
        drawWave(t + layer * 220, width, height, layer);
      }

      particles.forEach((p) => {
        p.x += p.vx;
        p.y += p.vy - 0.05;
        if (p.y < -4) p.y = height + 4;
        if (p.x < -4) p.x = width + 4;
        if (p.x > width + 4) p.x = -4;
        const dx = p.x - mouse.x * width;
        const dy = p.y - mouse.y * height;
        const d = Math.hypot(dx, dy) + 1;
        p.x += (dx / d) * 0.12;
        p.y += (dy / d) * 0.12;
        ctx.beginPath();
        ctx.fillStyle = `rgba(165,180,252,${p.a * intensity})`;
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fill();
      });

      if (!reduced) raf = requestAnimationFrame(tick);
    };

    resize();
    seedParticles();
    window.addEventListener("resize", resize);
    window.addEventListener("pointermove", onMove, { passive: true });
    raf = requestAnimationFrame(tick);
    if (reduced) {
      cancelAnimationFrame(raf);
      tick(0);
    }

	const io = new IntersectionObserver(([entry]) => {
	  if (reduced) return;
	  if (entry?.isIntersecting) {
	    if (!running) {
	      running = true;
	      raf = requestAnimationFrame(tick);
	    }
	  } else {
	    running = false;
	    cancelAnimationFrame(raf);
	  }
	});
	io.observe(canvas);
	
    return () => {
	  io.disconnect();
      running = false;
      cancelAnimationFrame(raf);
      window.removeEventListener("resize", resize);
      window.removeEventListener("pointermove", onMove);
    };
  }, [intensity, reduced]);

  return (
    <canvas
      ref={canvasRef}
      className={`absolute inset-0 h-full w-full ${className}`}
      aria-hidden="true"
    />
  );
}
