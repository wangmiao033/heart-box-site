import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        page: "#F7F4EF",
        "page-soft": "#f0e9e0",
        warm: "#D6A77A",
        "warm-deep": "#c4956a",
        blush: "#F4C6CC",
        sage: "#CDE7D8",
        mist: "#DCE8F9",
        ink: "#3A3A3A",
        sub: "#7A7A7A",
        brand: "#D6A77A",
      },
      boxShadow: {
        paper: "0 8px 30px rgba(0,0,0,0.04)",
        warm: "0 10px 28px rgba(214, 167, 122, 0.22)",
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
