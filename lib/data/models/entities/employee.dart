import 'package:codepan/data/database/schema.dart';
import 'package:codepan/data/models/entities/master.dart';
import 'package:codepan/extensions/map.dart';
import 'package:codepan/time/time.dart';
import 'package:employee_email/data/database/db_config.dart';
import 'package:employee_email/data/database/schema.dart';

const _schema = TableSchema(schema, Tb.employees);

class EmployeeData extends MasterData {
  final String? firstName, lastName, email, employeeId, teamId;

  @override
  TableSchema get schemaInstance => _schema;

  const EmployeeData({
    super.id,
    super.dateCreated,
    super.timeCreated,
    super.dateUpdated,
    super.timeUpdated,
    super.isDeleted,
    this.employeeId,
    this.teamId,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    final createdAt = Time.today();
    final updatedAt = Time.today();
    return EmployeeData(
      dateCreated: createdAt.date,
      timeCreated: createdAt.time,
      dateUpdated: updatedAt.date,
      timeUpdated: updatedAt.time,
      employeeId: json['employee_id'],
      lastName: json['lastname'],
      firstName: json['firstname'],
      email: json['email'],
      teamId: json['team_id'],
    );
  }

  static EmployeeData? fromQuery(Map<String, dynamic>? record) {
    final map = record?.copy();
    map?.setPrefix(_schema.alias);
    if (map?.hasKeyWithValue('id') ?? false) {
      return EmployeeData(
        id: map!.get('id'),
        dateCreated: map.get('dateCreated'),
        timeCreated: map.get('timeCreated'),
        dateUpdated: map.get('dateUpdated'),
        timeUpdated: map.get('timeUpdated'),
        isDeleted: map.get('isDeleted'),
        employeeId: map.get('employeeId').toString(),
        lastName: map.get('lastName').toString(),
        firstName: map.get('firstName').toString(),
        email: map.get('email').toString(),
        teamId: map.get('teamId').toString(),
      );
    }
    return null;
  }

  @override
  EmployeeData copyWith({
    int? id,
    String? dateCreated,
    String? timeCreated,
    String? dateUpdated,
    String? timeUpdated,
    bool? isDeleted,
    String? employeeId,
    String? lastName,
    String? firstName,
    String? email,
    String? teamId,
  }) {
    return EmployeeData(
      id: id ?? this.id,
      dateCreated: dateCreated ?? this.dateCreated,
      timeCreated: timeCreated ?? this.timeCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      timeUpdated: timeUpdated ?? this.timeUpdated,
      isDeleted: isDeleted ?? this.isDeleted,
      employeeId: employeeId ?? this.employeeId,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      teamId: teamId ?? this.teamId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return filtered({
      'employeeId': employeeId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'teamId': teamId,
    })
      ..remove(['name', 'webId']);
  }
}
