import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AppSettingsRepository(db);
});

class AppSettingsRepository {
  final AppDatabase _db;

  AppSettingsRepository(this._db);

  static const String keyOnboardingCompleted = 'has_completed_onboarding';

  Future<String?> getSetting(String key) async {
    final query = _db.select(_db.appSettings)
      ..where((tbl) => tbl.key.equals(key));
    final record = await query.getSingleOrNull();
    return record?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<bool> isOnboardingCompleted() async {
    final val = await getSetting(keyOnboardingCompleted);
    return val == 'true';
  }

  Future<void> setOnboardingCompleted([bool completed = true]) async {
    await setSetting(keyOnboardingCompleted, completed ? 'true' : 'false');
  }

  Stream<bool> watchOnboardingCompleted() {
    final query = _db.select(_db.appSettings)
      ..where((tbl) => tbl.key.equals(keyOnboardingCompleted));
    return query.watchSingleOrNull().map((record) => record?.value == 'true');
  }
}
