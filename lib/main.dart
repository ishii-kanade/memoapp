import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'メモアプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoApp(),
    );
  }
}

class MemoApp extends StatefulWidget {
  @override
  _MemoAppState createState() => _MemoAppState();
}

class _MemoAppState extends State<MemoApp> {
  List<String> _memos = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  Future<File> _getMemoFile() async {
    final directory = await getApplicationDocumentsDirectory();
    print("path::" + directory.path);
    return File('${directory.path}/memos.json');
  }

  Future<void> _loadMemos() async {
    try {
      final file = await _getMemoFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonMemos = jsonDecode(content);
        setState(() {
          _memos = jsonMemos.cast<String>();
        });
      }
    } catch (e) {
      // エラー時は空のリストを使う
      setState(() {
        _memos = [];
      });
    }
  }

  Future<void> _saveMemos() async {
    try {
      final file = await _getMemoFile();
      final content = jsonEncode(_memos);
      await file.writeAsString(content);
    } catch (e) {
      // エラー時の処理
      print('Failed to save memos: $e');
    }
  }

  void _addMemo(String memo) {
    setState(() {
      _memos.add(memo);
    });
    _saveMemos();
  }

  void _deleteMemo(int index) {
    setState(() {
      _memos.removeAt(index);
    });
    _saveMemos();
  }

  void _editMemo(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController editController = TextEditingController();
        editController.text = _memos[index]; // 現在のメモを編集用に設定

        return AlertDialog(
          title: Text("メモを編集"),
          content: TextField(
            controller: editController,
            maxLines: null, // 自動改行を有効にする
            decoration: InputDecoration(
              labelText: 'メモを編集してください',
              border: OutlineInputBorder(), // 枠線を追加
            ),
            keyboardType: TextInputType.multiline, // 改行を許可
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("キャンセル"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _memos[index] = editController.text; // メモを更新
                });
                _saveMemos(); // 更新後に保存
                Navigator.of(context).pop();
              },
              child: Text("保存"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メモアプリ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null, // 自動改行を有効にする
                    decoration: InputDecoration(
                      labelText: 'メモを入力してください',
                      border: OutlineInputBorder(), // 枠線を追加
                    ),
                    keyboardType: TextInputType.multiline, // 改行を許可
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addMemo(_controller.text);
                      _controller.clear();
                    }
                  },
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
                  children: _memos.asMap().entries.map((entry) {
                    final index = entry.key;
                    final memo = entry.value;
                    return InkWell(
                      onTap: () {
                        _editMemo(index); // タップ時に編集ダイアログを開く
                      },
                      borderRadius: BorderRadius.circular(8.0), // 波紋アニメーションの範囲を指定
                      splashColor: Colors.blue.shade200, // 波紋の色を指定
                      child: Card(
                        color: Colors.blue.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                memo,
                                style: TextStyle(fontSize: 16),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _deleteMemo(index);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
