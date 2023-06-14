import 'dart:convert';

import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:codepan/data/database/sqlite_binder.dart';
import 'package:codepan/extensions/extensions.dart';
import 'package:codepan/resources/strings.dart';
import 'package:employee_email/data/models/entities/employee.dart';
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
    final String data = await fetchData();
    final binder = SqliteBinder.of(db);
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
            if (data.isNotEmpty) {
              print("DB: Inserting to Database");
              for (Map<String, dynamic> json in data) {
                final e = EmployeeData.fromJson(json);
                print("DB: ${e.lastName}");
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
}

Future<String> fetchData() async {
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
