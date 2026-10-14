import sharp from "sharp";
import { readdir, readFile, unlink } from "node:fs/promises";
import path from "node:path";

const dir = "src/assets/discover";
for (const file of await readdir(dir)) {
  const ext = path.extname(file).toLowerCase();
  if (![".jpg", ".jpeg", ".png", ".webp", ".avif"].includes(ext)) continue;

  const input = path.join(dir, file);
  const out = path.join(dir, path.basename(file, ext) + ".webp");
  const buf = await readFile(input);
  const meta = await sharp(buf).metadata();
  if (ext === ".webp" && meta.width === 640 && meta.height === 640) continue;

  await sharp(buf)
    .resize(640, 640, { fit: "cover", position: "attention" })
    .webp({ quality: 78 })
    .toFile(out);
  if (out !== input) await unlink(input);
  console.log("optimized", path.basename(out));
}