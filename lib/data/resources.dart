

import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:codepan/storage/shared_preferences.dart';

class ResourcesData {
  final SharedPreferencesManager prefs;
  final SqliteAdapter db;

  const ResourcesData({
    required this.db,
    required this.prefs,
  });

  ResourcesData copyWith({
    SqliteAdapter? db,
    int? totalSyncCount,
    SharedPreferencesManager? prefs,
    String? mapToken,
  }) {
    return ResourcesData(
      db: db ?? this.db,
      prefs: prefs ?? this.prefs,
    );
  }
}
