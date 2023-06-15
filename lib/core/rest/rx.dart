import 'dart:convert';

import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:codepan/data/database/sqlite_binder.dart';
import 'package:codepan/extensions/extensions.dart';
import 'package:codepan/resources/strings.dart';
import 'package:employee_email/data/models/entities/employee.dart';
import 'package:employee_email/data/models/entities/team.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'parser.dart';

class Rx {
  static Future<bool> getEmployees({
    required SqliteAdapter db,
    required Client client,
  }) async {
    print("DB: Populating Database");
    final uri = Uri.parse(
        'https://www.app.tarkie.com/API/2.0/get-employees-access-data?api_key=3bCJ7BCm6XBS76677cb156AZH67Py1k49gP3utrbVU30bY8HRd&user_id=13');
    final future = client.get(
      uri,
    );
    return await Parser.parse<bool>(
      response: await future.timeout(timeout),
      onSuccess: (data) async {
        print("DB: Success on uri");
        print("DB: $data");
        final binder = SqliteBinder.of(db);
        return await binder.transact<bool>(
          body: (binder) async {
            List<TeamData> teams = [];
            final bool isGetTeamSuccessful = await getTeams(db: db, client: client, teams: teams);
            if (data.isNotEmpty && isGetTeamSuccessful) {
              print("DB: Inserting to Database");
              for (Map<String, dynamic> json in data) {
                EmployeeData e = EmployeeData.fromJson(json);
                e.team = assignTeamData(e, teams);
                print("DB: ${e.lastName}");
                print("DB: ${e.team?.name}");
                final employee = await e.insertForId<EmployeeData>(binder);
                binder.updateData(
                  data: e,
                );
              }
            }
          },
        );
      },
      onError: (code) async {
        return "Error $code";
      },
    );
  }

  static Future<bool> getTeams({
    required SqliteAdapter db,
    required Client client,
    required List<TeamData> teams,
  }) async {
    print("DB: Populating Team Database");
    final uri = Uri.parse(
        'https://www.app.tarkie.com/API/2.0/get-teams?api_key=3bCJ7BCm6XBS76677cb156AZH67Py1k49gP3utrbVU30bY8HRd&user_id=13');
    final future = client.get(
      uri,
    );
    return await Parser.parse<bool>(
      response: await future.timeout(timeout),
      onSuccess: (data) async {
        print("DB: Success on uri");
        print("DB: Teams: $data");
        final binder = SqliteBinder.of(db);
        return await binder.transact<bool>(
          body: (binder) async {
            if (data.isNotEmpty) {
              print("DB: Inserting to Database");
              for (Map<String, dynamic> json in data) {
                final e = TeamData.fromJson(json);
                print("DB: ${e.name}");
                final team = await e.insertForId<TeamData>(binder);
                teams.add(team);
                binder.updateData(
                  data: e,
                );
              }
            }
          },
        );
      },
      onError: (code) async {
        return "Error $code";
      },
    );
  }
}

Future<String> fetchEmployeeData() async {
  try {
    final url = Uri.parse(
        'https://www.app.tarkie.com/API/2.0/get-employees-access-data?api_key=3bCJ7BCm6XBS76677cb156AZH67Py1k49gP3utrbVU30bY8HRd&user_id=13');
    final response = await http.get(url);
    // Successful response
    final data = response.body;
    // Process the data as needed
    return data;
  } catch (e) {
    // Catch the exception and handle it
    print('An error occurred: $e');
    return "";
  }
}

TeamData? assignTeamData(EmployeeData employee, List<TeamData> teams)  {
  try {
    for(TeamData team in teams){
      if(int.parse(employee.teamId!) == team.webId){
        return team;
      }
    }
  } on Exception catch (e) {
    // TODO
  }
  return null;
}

