import 'dart:math';

import '../../models/mood_kind.dart';

// —— 写作提示（新建随机；可换一条；可插入正文）——

const List<String> kWritingPrompts = [
  '今天最想记住的一件小事是什么？',
  '今天让你开心的一瞬间是什么？',
  '今天最让你疲惫的事是什么？',
  '如果给今天起一个标题，会是什么？',
  '今天你最想对自己说的一句话是什么？',
  '今天有没有一个时刻让你觉得安心？',
  '今天有什么没说出口的话？',
  '今天最明显的情绪是什么？它从什么时候开始的？',
  '今天你在意的人或事，发生了什么？',
  '如果只记录一个画面，你会写下什么？',
  '今天有什么事情比你想象中更难？',
  '今天有没有一件值得感谢的小事？',
  '今天你为自己做的一件小事是什么？',
  '如果现在有人认真听你说话，你会从哪里讲起？',
  '今天身体哪里最累？心里又是什么感觉？',
  '写下一件「本来可以、但没有勉强自己」的选择。',
  '今天有没有一件小事其实在帮你撑着？',
  '如果今天只能用一句话收束，你会写什么？',
  '今天有没有一个瞬间，你其实想被理解？',
  '今天结束时，你最想留下的一句备注是什么？',
];

String pickWritingPrompt(Random random, {String? avoid}) {
  final pool = List<String>.from(kWritingPrompts);
  if (avoid != null && pool.length > 1) {
    pool.removeWhere((e) => e == avoid);
    if (pool.isEmpty) pool.addAll(kWritingPrompts);
  }
  return pool[random.nextInt(pool.length)];
}

// —— 情绪安抚（与现有 MoodKind：低落 / 焦虑 / 烦躁）——

bool moodNeedsComfort(MoodKind m) =>
    m == MoodKind.low || m == MoodKind.anxious || m == MoodKind.angry;

class ComfortCopy {
  const ComfortCopy({
    required this.line1,
    required this.line2,
    required this.suggestion,
  });

  final String line1;
  final String line2;
  final String suggestion;
}

ComfortCopy? comfortForMood(MoodKind m) {
  switch (m) {
    case MoodKind.low:
      return const ComfortCopy(
        line1: '你现在的感受值得被认真对待。',
        line2: '不急着整理清楚，先把它写下来就可以。',
        suggestion: '先写下此刻最真实的一句话。',
      );
    case MoodKind.anxious:
      return const ComfortCopy(
        line1: '先不用一次想明白所有事情。',
        line2: '把脑子里最吵的那件事写下来，可能会轻一点。',
        suggestion: '写下「我现在最担心的是……」。',
      );
    case MoodKind.angry:
      return const ComfortCopy(
        line1: '先把情绪放到文字里，而不是憋在心里。',
        line2: '你可以先记录事实，再写感受。',
        suggestion: '试着分两句写：发生了什么 / 你为什么生气。',
      );
    case MoodKind.calm:
    case MoodKind.happy:
    case MoodKind.grateful:
      return null;
  }
}

// —— 保存成功反馈（SnackBar 文案）——

const _saveNewPositive = [
  '已帮你记下这一刻。',
  '这段心情已经收好了。',
  '记下来了，稍后回看也会有答案。',
  '今天的这份感受，已经被留住了。',
];

const _saveNewGentle = [
  '已经帮你收好这一段，随时可以再翻开。',
  '写下来了，不用急着对自己下结论。',
  '这一刻的心情，已经安放在这里了。',
  '记下来了，你做得很好。',
];

const _saveEditPositive = [
  '已更新这条记录。',
  '修改已经保存。',
  '这次补充也记下来了。',
];

const _saveEditGentle = [
  '已更新，你的补充也留在这里了。',
  '修改已保存，慢慢整理也没关系。',
  '保存好了，这条记录跟着你一起更新了。',
];

bool _moodIsHeavy(MoodKind m) =>
    m == MoodKind.low || m == MoodKind.anxious || m == MoodKind.angry;

String pickComposeSaveMessage({
  required bool isNew,
  required MoodKind mood,
  required Random random,
}) {
  final heavy = _moodIsHeavy(mood);
  if (isNew) {
    final pool = heavy ? _saveNewGentle : _saveNewPositive;
    return pool[random.nextInt(pool.length)];
  }
  final pool = heavy ? _saveEditGentle : _saveEditPositive;
  return pool[random.nextInt(pool.length)];
}
