import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoapp/domain/entities/memo_entity.dart';
import 'domain/usecases/get_memos.dart';
import 'domain/usecases/save_memos.dart';
import 'data/datasources/memo_local_data_source_impl.dart';
import 'data/repositories/memo_repository_impl.dart';
import 'presentation/notifiers/memo_notifier.dart';
import 'presentation/pages/memo_page.dart';

// 依存性のプロバイダーを定義
final localDataSourceProvider = Provider((ref) => MemoLocalDataSourceImpl());

final repositoryProvider = Provider((ref) {
  final localDataSource = ref.read(localDataSourceProvider);
  return MemoRepositoryImpl(localDataSource);
});

final getMemosProvider = Provider((ref) {
  final repository = ref.read(repositoryProvider);
  return GetMemos(repository);
});

final saveMemosProvider = Provider((ref) {
  final repository = ref.read(repositoryProvider);
  return SaveMemos(repository);
});

// MemoNotifier用のStateNotifierProvider
final memoNotifierProvider =
StateNotifierProvider<MemoNotifier, List<MemoEntity>>((ref) {
  final getMemos = ref.read(getMemosProvider);
  final saveMemos = ref.read(saveMemosProvider);
  return MemoNotifier(getMemosUseCase: getMemos, saveMemosUseCase: saveMemos)
    ..loadMemos(); // 初期ロード
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
