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
                    decoration: InputDecoration(
                      labelText: 'メモを入力してください',
                    ),
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
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: _memos.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blue.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _memos[index],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
