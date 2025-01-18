import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class Memo {
  String text;
  bool isPinned;

  Memo({required this.text, this.isPinned = false});

  Map<String, dynamic> toJson() => {'text': text, 'isPinned': isPinned};

  factory Memo.fromJson(Map<String, dynamic> json) =>
      Memo(text: json['text'], isPinned: json['isPinned'] ?? false);
}

class MemoApp extends StatefulWidget {
  const MemoApp({super.key});

  @override
  _MemoAppState createState() => _MemoAppState();
}

class _MemoAppState extends State<MemoApp> {
  List<Memo> _memos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  Future<File> _getMemoFile() async {
    final directory = await getApplicationDocumentsDirectory();
    if (kDebugMode) {
      print("path::${directory.path}");
    }
    return File('${directory.path}/memos.json');
  }

  Future<void> _loadMemos() async {
    try {
      final file = await _getMemoFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonMemos = jsonDecode(content);
        setState(() {
          _memos = jsonMemos.map((e) => Memo.fromJson(e)).toList();
        });
      }
    } catch (e) {
      setState(() {
        _memos = [];
      });
    }
  }

  Future<void> _saveMemos() async {
    try {
      final file = await _getMemoFile();
      final content = jsonEncode(_memos.map((e) => e.toJson()).toList());
      await file.writeAsString(content);
    } catch (e) {
      print('Failed to save memos: $e');
    }
  }

  void _addMemo(String memo) {
    setState(() {
      _memos.add(Memo(text: memo));
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
        editController.text = _memos[index].text;

        return AlertDialog(
          title: Text("メモを編集"),
          content: TextField(
            controller: editController,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'メモを編集してください',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
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
                  _memos[index].text = editController.text;
                });
                _saveMemos();
                Navigator.of(context).pop();
              },
              child: Text("保存"),
            ),
          ],
        );
      },
    );
  }

  void _togglePin(int index) {
    setState(() {
      _memos[index].isPinned = !_memos[index].isPinned;
      _memos.sort((a, b) => (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0));
    });
    _saveMemos();
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
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'メモを入力してください',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
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
                        _editMemo(index);
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      splashColor: Colors.blue.shade200,
                      child: Card(
                        color: memo.isPinned
                            ? Colors.yellow.shade100
                            : Colors.blue.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                memo.text,
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    onPressed: () {
                                      _togglePin(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteMemo(index);
                                    },
                                  ),
                                ],
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
