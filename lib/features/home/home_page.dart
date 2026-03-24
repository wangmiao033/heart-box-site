import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/mood_kind.dart';
import '../journal/journal_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JournalController>().refresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jc = context.watch<JournalController>();
    final df = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('心事匣'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) {
                return SearchBar(
                  hintText: '搜索正文或标签',
                  controller: _searchController,
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (value.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          jc.setSearchQuery('');
                        },
                      ),
                  ],
                  onChanged: jc.setSearchQuery,
                  onSubmitted: jc.setSearchQuery,
                );
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: jc.refresh,
        child: _buildBody(context, jc, df),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/compose');
          if (context.mounted) {
            await context.read<JournalController>().refresh();
          }
        },
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('记一笔'),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    JournalController jc,
    DateFormat df,
  ) {
    if (jc.loading && jc.entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (jc.error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text('加载失败：${jc.error}'),
          ),
        ],
      );
    }
    if (jc.entries.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Center(child: Text('还没有记录，点右下角开始写下第一件事吧')),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      itemCount: jc.entries.length,
      separatorBuilder: (context, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final e = jc.entries[i];
        final mood = MoodKind.fromIndex(e.moodIndex);
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/entry/${e.id}'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(mood.icon, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        mood.label,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const Spacer(),
                      Text(
                        df.format(e.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (e.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: e.tags
                          .map(
                            (t) => Chip(
                              label: Text(t),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    e.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
