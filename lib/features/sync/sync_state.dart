/// 设置页展示的同步状态（与本地 DB 的 sync_status 字段不同层级）。
enum JournalSyncUiStatus {
  /// 未配置 Supabase 或未登录
  unavailable,
  /// 无待同步项且无错误
  synced,
  /// 有待上传/重试
  pending,
  /// 正在执行全量同步
  syncing,
  /// 最近一次同步出现错误（本地数据仍保留）
  failed,
}
