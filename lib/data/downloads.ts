export type PlatformStatus = "即将上线" | "开发中" | "规划中" | "测试中";

export type PlatformCard = {
  id: string;
  name: string;
  status: PlatformStatus;
  description: string;
  icon: "apple" | "android" | "globe";
};

export const platformCards: PlatformCard[] = [
  {
    id: "ios",
    name: "iOS",
    status: "即将上线",
    description: "App Store 版本筹备中，敬请期待。",
    icon: "apple",
  },
  {
    id: "android",
    name: "Android",
    status: "开发中",
    description: "正式分发渠道确定后会在此同步说明。",
    icon: "android",
  },
  {
    id: "web",
    name: "Web",
    status: "规划中",
    description: "浏览器体验版在规划中，不打扰现有节奏。",
    icon: "globe",
  },
];
