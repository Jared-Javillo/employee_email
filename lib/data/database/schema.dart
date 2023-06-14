import 'package:codepan/data/database/models/field.dart';
import 'package:codepan/data/database/schema.dart';
import 'package:employee_email/data/database/db_config.dart' as config;

enum Tb implements DatabaseEntity {
  employees;

  @override
  String get dbName => config.dbName;

  @override
  int get version => config.version;

  @override
  int get count => Tb.values.length;
}

class Schema extends DatabaseSchema<Tb> {
  const Schema();

  @override
  List<Tb> get entities => Tb.values;

  @override
  List<Field> fields(entity) {
    switch (entity) {
      case Tb.employees:
        return <Field>[
          Field.primaryKey('id'),
          Field.defaultDate('dateCreated'),
          Field.defaultTime('timeCreated'),
          Field.autoUpdateDate('dateUpdated'),
          Field.autoUpdateTime('timeUpdated'),
          Field.defaultValue('isDeleted', value: false),
          Field.unique('employeeId', type: DataType.integer),
          Field.column('lastName', type: DataType.text),
          Field.column('firstName', type: DataType.text),
          Field.column('email', type: DataType.text),
          Field.column('teamId', type: DataType.integer),
        ];
      default:
        return <Field>[
          Field.primaryKey('id'),
          Field.defaultDate('dateCreated'),
          Field.defaultTime('timeCreated'),
          Field.autoUpdateDate('dateUpdated'),
          Field.autoUpdateTime('timeUpdated'),
          Field.defaultValue('isDeleted', value: false),
          Field.unique('webId', type: DataType.integer),
          Field.column('name', type: DataType.text),
        ];
    }
  }
}
