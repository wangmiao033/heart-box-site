/** 放进心事匣后的轻提示 */
export const afterPlaceQuotes = [
  "已经替你收好了。",
  "先放在这里，也很好。",
  "不急着整理，也没关系。",
  "我帮你留住了。",
  "慢慢来，不催促。",
] as const;

export function randomAfterPlaceQuote(): string {
  const i = Math.floor(Math.random() * afterPlaceQuotes.length);
  return afterPlaceQuotes[i] ?? afterPlaceQuotes[0];
}
