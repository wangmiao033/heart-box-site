export type SceneCard = { title: string; body: string };

export const homeScenes: SceneCard[] = [
  {
    title: "睡前写一点",
    body: "不必写很长，几句就好，把今天轻轻放下。",
  },
  {
    title: "通勤时记一下",
    body: "路上闪过的念头，先收进匣子里，晚点再整理。",
  },
  {
    title: "想说但不想发出去的时候",
    body: "这里没有点赞和评论，只有你和自己的对话。",
  },
];

export const productScenarios: string[] = [
  "睡前整理心情",
  "白天短暂失落",
  "想说又不想发朋友圈",
  "某个念头怕忘记",
];

export const philosophyCards = [
  {
    title: "少一点负担",
    body: "不催促、不打卡，写与不写都由你决定。",
  },
  {
    title: "留一点空间",
    body: "留白多一点，心里就松一点。",
  },
  {
    title: "慢一点也没关系",
    body: "生活不必全程加速，记录也可以慢慢来。",
  },
];

export const usageSteps = [
  { title: "写下一点点", desc: "一句话、一个词，都算数。" },
  { title: "放进心事匣", desc: "像把纸条折好，轻轻放进去。" },
  { title: "安静保存", desc: "草稿与内容，尽量替你守住。" },
  { title: "想看的时候再回来", desc: "日历与回顾，随时翻回来看。" },
];
