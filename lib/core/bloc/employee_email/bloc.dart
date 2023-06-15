import 'package:codepan/bloc/parent_bloc.dart';
import 'package:codepan/data/database/initializer.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:codepan/data/database/sqlite_cache.dart';
import 'package:codepan/utils/codepan_utils.dart';
import 'package:employee_email/core/rest/rx.dart';
import 'package:employee_email/data/database/db_config.dart';
import 'package:employee_email/data/reader.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'events.dart';
import 'states.dart';

class EmployeeBloc extends ParentBloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc({
    EmployeeEvent? initialEvent,
  }) : super(
          initialEvent: initialEvent,
          initialState: const EmployeeState(),
        ) {
    on<GetEmployees>((event, emit) async {
      emit(const Loading<EmployeesDisplayed>());
      final client = Client();
      final db = await getDatabase();
      print("EmployeeEmailPage: Loading employees");
      try {
        final list = await Reader.getEmployees(db);
        emit(
          EmployeesDisplayed(employeeList: list)
        );
      } catch (error, stackTrace) {
        printError(error, stackTrace);
        emit(
          Error<EmployeesDisplayed>(error: error.toString()),
        );
      } finally {
        client.close();
      }
    });
  }
}

Future<SqliteAdapter> getDatabase() async {
  return await SqliteCache.getDatabase(
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
}

