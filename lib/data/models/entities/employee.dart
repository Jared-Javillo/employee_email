import 'package:codepan/data/database/schema.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:codepan/data/database/sqlite_query.dart';
import 'package:codepan/data/models/entities/master.dart';
import 'package:codepan/extensions/map.dart';
import 'package:codepan/time/time.dart';
import 'package:employee_email/data/database/db_config.dart';
import 'package:employee_email/data/database/schema.dart';
import 'package:employee_email/data/models/entities/team.dart';

const _schema = TableSchema(schema, Tb.employees);

class EmployeeData extends MasterData {
  final String? firstName, lastName, email, teamId;
  final TeamData? team;

  @override
  TableSchema get schemaInstance => _schema;

  const EmployeeData({
    super.id,
    super.dateCreated,
    super.timeCreated,
    super.dateUpdated,
    super.timeUpdated,
    super.isDeleted,
    super.webId,
    this.teamId,
    this.firstName,
    this.lastName,
    this.email,
    this.team,
  });

  factory EmployeeData.fromJson(
    Map<String, dynamic> json, {
    required TeamData team,
  }) {
    final createdAt = Time.today();
    final updatedAt = Time.today();
    return EmployeeData(
      dateCreated: createdAt.date,
      timeCreated: createdAt.time,
      dateUpdated: updatedAt.date,
      timeUpdated: updatedAt.time,
      webId: int.parse(json['employee_id']),
      lastName: json['lastname'],
      firstName: json['firstname'],
      email: json['email'],
      teamId: json['team_id'],
      team: team,
    );
  }

  static EmployeeData? fromQuery(
    Map<String, dynamic>? record, {
    TeamData? team,
  }) {
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
        webId: map.get('webId'),
        lastName: map.get('lastName').toString(),
        firstName: map.get('firstName').toString(),
        email: map.get('email').toString(),
        teamId: map.get('teamId').toString(),
        team: team ?? TeamData.fromQuery(record),
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
    int? webId,
    String? lastName,
    String? firstName,
    String? email,
    String? teamId,
    TeamData? team,
  }) {
    return EmployeeData(
      id: id ?? this.id,
      dateCreated: dateCreated ?? this.dateCreated,
      timeCreated: timeCreated ?? this.timeCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      timeUpdated: timeUpdated ?? this.timeUpdated,
      isDeleted: isDeleted ?? this.isDeleted,
      webId: webId ?? this.webId,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      team: team ?? this.team,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return filtered({
      'teamId': team?.id,
    });
  }
}
