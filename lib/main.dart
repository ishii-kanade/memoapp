import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'domain/usecases/get_memos.dart';
import 'domain/usecases/save_memos.dart';
import 'data/datasources/memo_local_data_source_impl.dart';
import 'data/repositories/memo_repository_impl.dart';
import 'presentation/notifiers/memo_notifier.dart';
import 'presentation/pages/memo_page.dart';

void main() {
  // 依存を組み立てる
  final localDataSource = MemoLocalDataSourceImpl();
  final repository = MemoRepositoryImpl(localDataSource);
  final getMemos = GetMemos(repository);
  final saveMemos = SaveMemos(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MemoNotifier(
            getMemosUseCase: getMemos,
            saveMemosUseCase: saveMemos,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'メモアプリ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MemoPage(),
    );
  }
}
