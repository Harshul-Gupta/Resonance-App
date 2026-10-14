import { motion, useMotionValue, useSpring } from "framer-motion";
import { useRef, type MouseEvent, type ReactNode, type Ref } from "react";
import { usePrefersReducedMotion } from "../hooks/usePrefersReducedMotion";

type Props = {
  href?: string;
  onClick?: () => void;
  children: ReactNode;
  className?: string;
  type?: "button" | "submit";
};

export function MagneticButton({
  href,
  onClick,
  children,
  className = "",
  type = "button",
}: Props) {
  const reduced = usePrefersReducedMotion();
  const ref = useRef<HTMLAnchorElement | HTMLButtonElement>(null);
  const x = useMotionValue(0);
  const y = useMotionValue(0);
  const sx = useSpring(x, { stiffness: 260, damping: 20, mass: 0.4 });
  const sy = useSpring(y, { stiffness: 260, damping: 20, mass: 0.4 });

  const onMove = (e: MouseEvent) => {
    if (reduced || !ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    const dx = e.clientX - (rect.left + rect.width / 2);
    const dy = e.clientY - (rect.top + rect.height / 2);
    x.set(dx * 0.25);
    y.set(dy * 0.25);
  };

  const reset = () => {
    x.set(0);
    y.set(0);
  };

  // Clean, modern dark surface with a subtle border and smooth hover transition
  const classes = `inline-flex items-center justify-center rounded-xl px-7 py-3 font-display text-sm font-medium tracking-wide text-paper bg-white/[0.07] border border-white/10 cursor-pointer backdrop-blur-md transition-colors hover:bg-white/[0.12] hover:border-cyan/40 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-cyan ${className}`;

  const motionProps = {
    style: { x: sx, y: sy },
    whileHover: reduced ? undefined : { scale: 1.03, y: -2 },
    whileTap: { scale: 0.98 },
    transition: { type: "spring" as const, stiffness: 400, damping: 25 },
    onMouseMove: onMove,
    onMouseLeave: reset,
    className: classes,
  };

  if (href) {
    return (
      <motion.a ref={ref as Ref<HTMLAnchorElement>} href={href} {...motionProps}>
        {children}
      </motion.a>
    );
  }

  return (
    <motion.button
      ref={ref as Ref<HTMLButtonElement>}
      type={type}
      onClick={onClick}
      {...motionProps}
    >
      {children}
    </motion.button>
  );
}