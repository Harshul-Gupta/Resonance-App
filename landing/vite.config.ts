import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

const api = { "/api": "http://localhost:8080" };

const proxy = {
  "/api": "http://localhost:8080",
  "/login": "http://localhost:8080",
  "/logout": "http://localhost:8080",
  "/artist-details": "http://localhost:8080"
};

export default defineConfig({
  plugins: [react()],
  build: { assetsDir: "landing-assets" },
  server: { port: 5173, host: true, proxy: api },
  preview: { port: 5173, host: true, proxy: api },
});