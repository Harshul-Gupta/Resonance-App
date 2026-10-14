import { motion } from "framer-motion";
import { MagneticButton } from "./MagneticButton";
import { SoundField } from "./SoundField";

export function FinalCTA() {
  return (
    <section className="relative flex min-h-[100svh] items-center justify-center overflow-hidden">
      <SoundField intensity={0.35} />
      <div className="absolute inset-0 bg-gradient-to-b from-ink via-ink/70 to-black" />
      <div className="relative z-10 px-6 text-center">
        <motion.p
          initial={{ opacity: 0, letterSpacing: "0.4em" }}
          whileInView={{ opacity: 1, letterSpacing: "0.18em" }}
          viewport={{ once: true }}
          transition={{ duration: 1.2 }}
          className="font-display text-sm uppercase text-mute"
        >
          Find your frequency.
        </motion.p>
        <motion.h2
          initial={{ scale: 1.2, opacity: 0, filter: "blur(20px)" }}
          whileInView={{ scale: 1, opacity: 1, filter: "blur(0px)" }}
          viewport={{ once: true }}
          transition={{ duration: 1.1, ease: [0.16, 1, 0.3, 1] }}
          className="mt-6 font-display text-[clamp(3rem,14vw,9rem)] font-extrabold uppercase tracking-[0.12em]"
        >
          Resonance
        </motion.h2>
        <div className="mt-10 flex justify-center">
          <MagneticButton href="https://github.com/Harshul-Gupta/Resonance-App">Source Code</MagneticButton>
        </div>
      </div>
    </section>
  );
}
