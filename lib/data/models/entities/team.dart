import 'package:codepan/data/database/schema.dart';
import 'package:codepan/data/models/entities/master.dart';
import 'package:codepan/extensions/map.dart';
import 'package:codepan/time/time.dart';
import 'package:employee_email/data/database/db_config.dart';
import 'package:employee_email/data/database/schema.dart';

const _schema = TableSchema(schema, Tb.teams);

class TeamData extends MasterData {


  @override
  TableSchema get schemaInstance => _schema;

  const TeamData({
    super.id,
    super.dateCreated,
    super.timeCreated,
    super.dateUpdated,
    super.timeUpdated,
    super.isDeleted,
    super.webId,
    super.name,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    final createdAt = Time.today();
    final updatedAt = Time.today();
    return TeamData(
      dateCreated: createdAt.date,
      timeCreated: createdAt.time,
      dateUpdated: updatedAt.date,
      timeUpdated: updatedAt.time,
      webId: json.getInt('team_id'),
      name: json.get('team_name'),
    );
  }

  static TeamData? fromQuery(Map<String, dynamic>? record) {
    final map = record?.copy();
    map?.setPrefix(_schema.alias);
    if (map?.hasKeyWithValue('id') ?? false) {
      return TeamData(
        id: map!.get('id'),
        dateCreated: map.get('dateCreated'),
        timeCreated: map.get('timeCreated'),
        dateUpdated: map.get('dateUpdated'),
        timeUpdated: map.get('timeUpdated'),
        isDeleted: map.get('isDeleted'),
        webId: map.get('webId'),
        name: map.get('name').toString(),
      );
    }
    return null;
  }

  @override
  TeamData copyWith({
    int? id,
    String? dateCreated,
    String? timeCreated,
    String? dateUpdated,
    String? timeUpdated,
    bool? isDeleted,
    int? webId,
    String? name,

  }) {
    return TeamData(
      id: id ?? this.id,
      dateCreated: dateCreated ?? this.dateCreated,
      timeCreated: timeCreated ?? this.timeCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      timeUpdated: timeUpdated ?? this.timeUpdated,
      isDeleted: isDeleted ?? this.isDeleted,
      webId: webId ?? this.webId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return filtered({
    })
      ..remove([]);
  }
}
