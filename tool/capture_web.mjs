/**
 * 依赖：在仓库根目录执行 npm install puppeteer-core（见下方命令）
 * 需本机已安装 Google Chrome；先启动 python tool/serve_web.py <端口>
 */
import puppeteer from "puppeteer-core";
import { existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = join(__dirname, "..");
const shotDir = join(repoRoot, "screenshots");

const chromeCandidates = [
  process.env.CHROME_PATH,
  "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
  "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
].filter(Boolean);

function findChrome() {
  for (const p of chromeCandidates) {
    if (existsSync(p)) return p;
  }
  throw new Error("未找到 Chrome，请设置环境变量 CHROME_PATH");
}

const base = process.env.SCREENSHOT_BASE_URL || "http://127.0.0.1:8765";
const routes = [
  ["01_home.png", "/#/home"],
  ["02_calendar.png", "/#/calendar"],
  ["03_review.png", "/#/review"],
  ["04_settings.png", "/#/settings"],
  ["05_compose.png", "/#/compose"],
  ["06_detail.png", "/#/entry/1"],
];

const browser = await puppeteer.launch({
  executablePath: findChrome(),
  headless: true,
  args: ["--no-sandbox", "--disable-gpu"],
  defaultViewport: { width: 430, height: 1200, deviceScaleFactor: 2 },
});

const page = await browser.newPage();

for (const [file, path] of routes) {
  const url = `${base}${path}`;
  console.log("→", url);
  await page.goto(url, { waitUntil: "networkidle0", timeout: 120000 });
  // Flutter Web 多为 Canvas，document.body.innerText 往往几乎为空，不能依赖文案等待。
  try {
    await page.waitForSelector("flt-glass-pane", { timeout: 90000 });
  } catch {
    console.warn("  (flt-glass-pane not found, still waiting)");
  }
  await new Promise((r) => setTimeout(r, 8500));
  const out = join(shotDir, file);
  await page.screenshot({ path: out, type: "png", fullPage: true });
  console.log("  saved", out);
}

await browser.close();
console.log("done");
