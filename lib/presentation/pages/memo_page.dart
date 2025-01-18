import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/memo_notifier.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Widgetがビルドされた後にメモをロード
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemoNotifier>().loadMemos();
    });
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
          // 入力フォーム
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // メモ入力フィールド
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'メモを入力してください',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // 追加ボタン
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      memoNotifier.addMemo(_controller.text);
                      _controller.clear();
                    }
                  },
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
                        final editController =
                            TextEditingController(text: memo.text);

                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('メモを編集'),
                              content: TextField(
                                controller: editController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  labelText: 'メモを編集してください',
                                  border: OutlineInputBorder(),
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
                                    memoNotifier.updateMemo(
                                      index,
                                      editController.text,
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
                              Text(memo.text,
                                  style: const TextStyle(fontSize: 16)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      memo.isPinned
                                          ? Icons.push_pin
                                          : Icons.push_pin_outlined,
                                      color:
                                          memo.isPinned ? Colors.orange : Colors.grey,
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
