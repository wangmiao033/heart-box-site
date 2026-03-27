export type NoteFilterId =
  | "all"
  | "recent"
  | "gentle"
  | "low"
  | "miss"
  | "encourage";

export type NoteEntry = {
  id: string;
  excerpt: string;
  mood: NoteFilterId;
  dateLabel: string;
};

export const noteFilters: { id: NoteFilterId; label: string }[] = [
  { id: "all", label: "全部" },
  { id: "recent", label: "最近" },
  { id: "gentle", label: "温柔" },
  { id: "low", label: "低落" },
  { id: "miss", label: "想念" },
  { id: "encourage", label: "鼓励" },
];

/** 假数据：心事展示 */
export const sampleNotes: NoteEntry[] = [
  {
    id: "1",
    excerpt: "今天地铁上多坐了一站，却意外看见很亮的云。",
    mood: "gentle",
    dateLabel: "三天前",
  },
  {
    id: "2",
    excerpt: "有点累，不想说话。允许自己就这样待着。",
    mood: "low",
    dateLabel: "一周前",
  },
  {
    id: "3",
    excerpt: "想起小时候外婆泡的茶，苦里有一点甜。",
    mood: "miss",
    dateLabel: "五天前",
  },
  {
    id: "4",
    excerpt: "做完一件小事也值得夸自己一下。",
    mood: "encourage",
    dateLabel: "昨天",
  },
  {
    id: "5",
    excerpt: "雨声很大，屋里很静，刚好写两行字。",
    mood: "gentle",
    dateLabel: "今天",
  },
  {
    id: "6",
    excerpt: "不必每天都积极，低落也是真实的一部分。",
    mood: "low",
    dateLabel: "两周前",
  },
];
