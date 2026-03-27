export type FeatureItem = {
  title: string;
  description: string;
};

export const homeFeatures: FeatureItem[] = [
  { title: "轻松记录心情", description: "几句话就好，不必写成长篇。" },
  { title: "日历回看轨迹", description: "在月历里看见情绪走过的痕迹。" },
  { title: "写作提示", description: "温柔引导，降低开口的难度。" },
  { title: "自动保存", description: "草稿悄悄留住，少一份担心。" },
  { title: "本地优先", description: "文字先属于你与设备，更安心。" },
  { title: "多端同步", description: "能力随版本迭代，以应用内为准。" },
];

export const capabilityModules: {
  title: string;
  description: string;
  side: "left" | "right";
}[] = [
  {
    title: "快速记录",
    description: "打开就能写，不被流程打断。",
    side: "left",
  },
  {
    title: "安静回看",
    description: "像翻笔记本一样，慢慢看回自己。",
    side: "right",
  },
  {
    title: "多端同步",
    description: "若已开放账号与云同步，可在多设备间延续。",
    side: "left",
  },
  {
    title: "本地优先",
    description: "默认以设备本地为主，隐私相关选项集中在一处。",
    side: "right",
  },
  {
    title: "轻提示写作",
    description: "偶尔不知道写什么时，一点轻提示，不施压。",
    side: "left",
  },
  {
    title: "情绪留痕",
    description: "心情与标记留在日历里，成为温柔的时间线。",
    side: "right",
  },
];
