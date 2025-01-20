import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';

class MemoPage extends ConsumerStatefulWidget {
  const MemoPage({super.key});

  @override
  ConsumerState<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends ConsumerState<MemoPage> {
  final _textController = TextEditingController();
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Widgetがビルドされた後にメモをロード
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memoNotifierProvider.notifier).loadMemos();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // memosをProviderから取得
    final memoNotifier = ref.read(memoNotifierProvider.notifier);
    final memos = ref.watch(filteredMemosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('メモアプリ'),
      ),
      body: Column(
        children: [
          // 検索ボックス
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'タグで検索',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // MemoNotifier に直接検索クエリを送信
                ref.read(searchQueryProvider.notifier).state = query;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'メモを入力してください',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _tagController,
                  decoration: const InputDecoration(
                    labelText: 'タグを入力してください (例: 仕事,プライベート)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('追加'),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        final tags = _tagController.text.isNotEmpty
                            ? _tagController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList()
                            : <String>[];
                        memoNotifier.addMemo(_textController.text, tags: tags);
                        _textController.clear();
                        _tagController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(memos.length, (index) {
                    final memo = memos[index];
                    return InkWell(
                      onTap: () {
                        final editTextController =
                        TextEditingController(text: memo.text);
                        final editTagController =
                        TextEditingController(text: memo.tags.join(', '));
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('メモを編集'),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: editTextController,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        labelText: 'メモを編集してください',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    TextField(
                                      controller: editTagController,
                                      decoration: const InputDecoration(
                                        labelText:
                                        'タグを編集してください (例: 仕事,プライベート)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: const Text('キャンセル'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final updatedTags = editTagController.text
                                        .isNotEmpty
                                        ? editTagController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList()
                                        : <String>[];
                                    memoNotifier.updateMemo(
                                      index,
                                      newText: editTextController.text,
                                      newTags: updatedTags,
                                    );
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text('保存'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        color: memo.isPinned
                            ? Colors.yellow.shade100
                            : Colors.blue.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                memo.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8.0),
                              Wrap(
                                spacing: 4.0,
                                children: memo.tags.map((tag) {
                                  return Chip(
                                    label: Text(tag),
                                    backgroundColor: Colors.grey.shade200,
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      memo.isPinned
                                          ? Icons.push_pin
                                          : Icons.push_pin_outlined,
                                      color: memo.isPinned
                                          ? Colors.orange
                                          : Colors.grey,
                                    ),
                                    onPressed: () =>
                                        memoNotifier.togglePin(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        memoNotifier.deleteMemo(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
