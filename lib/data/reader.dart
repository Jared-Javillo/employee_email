import 'package:codepan/data/database/models/condition.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:codepan/data/database/sqlite_query.dart';
import 'package:employee_email/data/models/entities/employee.dart';
import 'package:employee_email/data/database/schema.dart';


class Reader {
  static Future<List<EmployeeData>> getEmployees(SqliteAdapter db) async {
    final list = <EmployeeData>[];
    final query = SqliteQuery.all(
      schema: db.schema.of(Tb.employees),
      where: {
        'isDeleted': false,
      },
    );
    final records = await db.read(query.build());
    for (final record in records) {
      final data = EmployeeData.fromQuery(record);
      if (data != null) {
        list.add(data);
      }
    }
    return list;
  }

}