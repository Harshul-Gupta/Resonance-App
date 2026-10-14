/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        ink: "#050505",
        paper: "#F5F5F5",
        mute: "#929292",
        violet: "#8B5CF6",
        cyan: "#22D3EE",
        pink: "#EC4899",
      },
      fontFamily: {
        display: ["Syne", "sans-serif"],
        grotesk: ["Space Grotesk", "sans-serif"],
        sans: ["DM Sans", "sans-serif"],
      },
      letterSpacing: {
        tightest: "-0.06em",
      },
      boxShadow: {
        glow: "0 0 40px rgba(139, 92, 246, 0.35)",
        cyan: "0 0 32px rgba(34, 211, 238, 0.28)",
      },
    },
  },
  plugins: [],
};
