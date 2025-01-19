import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/memo_notifier.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final _textController = TextEditingController();
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Widgetがビルドされた後にメモをロード
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemoNotifier>().loadMemos();
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
    final memoNotifier = context.watch<MemoNotifier>();
    final memos = memoNotifier.memos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('メモアプリ'),
      ),
      body: Column(
        children: [
          // 新規メモ入力フォーム
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // メモの本文入力フィールド
                TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'メモを入力してください',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                // タグ入力フィールド（カンマ区切りで複数入力）
                TextField(
                  controller: _tagController,
                  decoration: const InputDecoration(
                    labelText: 'タグを入力してください (例: 仕事,プライベート)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                // 追加ボタン
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('追加'),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        // タグ文字列をカンマで分割してリストに変換
                        final tags = _tagController.text.isNotEmpty
                            ? _tagController.text.split(',').map((e) => e.trim()).toList()
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

          // メモ一覧
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
                        // 編集用ダイアログ
                        final editTextController =
                        TextEditingController(text: memo.text);
                        // タグはカンマ区切りの文字列に変換して表示
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
                                        labelText: 'タグを編集してください (例: 仕事,プライベート)',
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
                                    // 編集時も同様にタグ文字列をリストへ変換
                                    final updatedTags = editTagController.text.isNotEmpty
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
                              // タグ表示（Chipで一覧表示）
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
                                      color: memo.isPinned ? Colors.orange : Colors.grey,
                                    ),
                                    onPressed: () =>
                                        memoNotifier.togglePin(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
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
