import 'package:codepan/bloc/parent_bloc.dart';
import 'package:codepan/data/database/initializer.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:codepan/data/database/sqlite_cache.dart';
import 'package:codepan/resources/strings.dart';
import 'package:codepan/utils/codepan_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:employee_email/data/database/db_config.dart';
import 'package:http/http.dart';
import '../../rest/rx.dart';
import 'events.dart';
import 'states.dart';

class AppBloc extends ParentBloc<AppEvent, AppState> {

  AppBloc({
    AppEvent? initialEvent,
  }) : super(
          initialEvent: initialEvent,
          initialState: const AppState(),
        ) {
    on<InitializeDatabase>((event, emit) async {
      final client = Client();
      emit(const Loading<Database>());
      try {
        debugPrint('Initializing database please wait...');
        SqliteAdapter db = await SqliteCache.getDatabase(
          name: dbName,
          version: version,
          password: "password",
          libraryPath: kReleaseMode ? 'sqlite3.dll' : libraryPath,
          initializer: DefaultDatabaseInitializer(
            schema,
            updateNotifier: (db, oldVersion, newVersion) async {
              debugPrint('database updated');
            },
          ),
        );
        debugPrint(db.path);
        await _dbTesting(db);
        await Future.delayed(const Duration(seconds: 1));
        Rx.getEmployees(db: db, client: client,);
        emit(
          Database(db: db),
        );
      } catch (error, stackTrace) {
        printError(error, stackTrace);
        emit(
           Error<Database>(error: error),
        );
      }
    });

  }

  Future<void> _dbTesting(SqliteAdapter db) async {
    // final s = MainService('sample');
    // await s.start();
    // final binder = SqliteBinder.of(db);
    // binder.transact<bool>(
    //   showLog: true,
    //   body: (binder) async {
    //     binder.dropTable(db.schema.of(TB.employees).tableName);
    //   },
    // );
  }
}
