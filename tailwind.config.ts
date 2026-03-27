import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        page: "#f7f6f3",
        "page-soft": "#f1ede7",
        brand: "#8b7cff",
        blush: "#ffb3c7",
        mint: "#7bd3c5",
        ink: "#2c2c2c",
        sub: "#888888",
      },
      boxShadow: {
        glass: "0 8px 30px rgba(0,0,0,0.05)",
        lift: "0 14px 48px rgba(139,124,255,0.12)",
        phone: "0 24px 64px rgba(44,44,44,0.08)",
      },
      keyframes: {
        "orb-drift-a": {
          "0%, 100%": { transform: "translate(0, 0) scale(1)" },
          "50%": { transform: "translate(48px, -36px) scale(1.06)" },
        },
        "orb-drift-b": {
          "0%, 100%": { transform: "translate(0, 0) scale(1)" },
          "50%": { transform: "translate(-40px, 28px) scale(1.04)" },
        },
        "orb-drift-c": {
          "0%, 100%": { transform: "translate(0, 0) scale(1)" },
          "50%": { transform: "translate(32px, 44px) scale(1.05)" },
        },
      },
      animation: {
        "orb-a": "orb-drift-a 22s ease-in-out infinite",
        "orb-b": "orb-drift-b 28s ease-in-out infinite",
        "orb-c": "orb-drift-c 26s ease-in-out infinite",
      },
      fontFamily: {
        sans: [
          '"Source Han Sans SC"',
          '"Noto Sans SC"',
          '"PingFang SC"',
          '"Microsoft YaHei"',
          "system-ui",
          "sans-serif",
        ],
      },
    },
  },
  plugins: [],
};

export default config;
