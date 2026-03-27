export type ChangelogEntry = {
  version: string;
  date: string;
  items: string[];
};

export const changelogEntries: ChangelogEntry[] = [
  {
    version: "0.3.0",
    date: "2025-03-20",
    items: [
      "优化写作页自动保存节奏",
      "日历视图支持按周浏览",
      "修复部分机型深色模式下的对比度",
    ],
  },
  {
    version: "0.2.1",
    date: "2025-02-08",
    items: ["新增轻量写作提示", "回顾页文案微调", "性能与启动速度优化"],
  },
  {
    version: "0.2.0",
    date: "2025-01-15",
    items: ["首版内测流程", "本地草稿机制", "基础心情标记"],
  },
];
