import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        page: "#F7F3EF",
        "page-elevated": "#FAF7F4",
        card: "#FFFFFF",
        line: "#E8DED6",
        ink: "#3E3A37",
        sub: "#7D746D",
        accent: "#E7BFA7",
        "accent-muted": "#D9C6B8",
        warm: "#E7BFA7",
        brand: "#D9C6B8",
      },
      boxShadow: {
        paper:
          "0 1px 0 rgba(255,255,255,0.85) inset, 0 6px 28px rgba(62, 58, 55, 0.045)",
        "paper-hover":
          "0 1px 0 rgba(255,255,255,0.9) inset, 0 12px 40px rgba(62, 58, 55, 0.065)",
        glow: "0 0 48px rgba(255, 244, 214, 0.5)",
        "header-scrolled": "0 8px 32px rgba(62, 58, 55, 0.04)",
      },
      transitionTimingFunction: {
        soft: "cubic-bezier(0.25, 0.46, 0.45, 0.94)",
        out: "cubic-bezier(0.22, 1, 0.36, 1)",
      },
      borderRadius: {
        card: "24px",
        "card-md": "20px",
        control: "16px",
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
