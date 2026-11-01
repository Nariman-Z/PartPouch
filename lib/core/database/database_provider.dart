import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';

/// Global Riverpod provider for the singleton AppDatabase
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
