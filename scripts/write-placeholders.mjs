import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, "..");
const tinyPng = Buffer.from(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhwGAWjR9awAAAABJRU5ErkJggg==",
  "base64",
);

const shotsDir = path.join(root, "public", "screenshots");
fs.mkdirSync(shotsDir, { recursive: true });
for (const n of ["home", "calendar", "review", "settings", "compose"]) {
  fs.writeFileSync(path.join(shotsDir, `${n}.png`), tinyPng);
}
fs.writeFileSync(path.join(root, "public", "logo.png"), tinyPng);
fs.writeFileSync(path.join(root, "public", "og-cover.png"), tinyPng);
console.log("Placeholder PNGs written.");
