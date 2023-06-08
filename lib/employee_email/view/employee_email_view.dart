import 'package:employee_email/employee_email/cubit/employee_email_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:employee_email/employee_email/model/employee_model.dart';
import 'package:employee_email/employee_email/widgets/employee_card.dart';
import 'dart:convert';

import '../cubit/filter_list_Cubit.dart';

class EmployeeEmailView extends StatefulWidget {
  const EmployeeEmailView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EmployeeEmailViewState createState() => _EmployeeEmailViewState();
}

class _EmployeeEmailViewState extends State<EmployeeEmailView> {
  // override init .then
  String selectedFilter = '';
  List<EmployeeModel> employeeList = [];
  List<String> teamIdList = ['No Filter'];
  List<EmployeeModel> filteredEmployees = [];
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<FilterListCubit, List<String>>(
            builder: (context, state) {
              return DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.filter_alt),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                    context.read<EmployeeEmailCubit>().changeFilter(
                        dropdownValue, employeeList, filteredEmployees);
                  });
                },
                items: state.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<EmployeeEmailCubit, List<EmployeeModel>>(
        builder: (context, state) {
          return Center(
            child: ListView.builder(
              itemCount: state.length,
              itemBuilder: (BuildContext context, int index) {
                EmployeeModel employee = state[index];

                return EmployeeCard(employee);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> initializeData() async {
    dropdownValue = teamIdList.first;
    employeeList = parseEmployeeList(await fetchData(), teamIdList);
    filteredEmployees = employeeList;

    ///Is there a better way to write this
    if (!context.mounted) return;
    context.read<EmployeeEmailCubit>().changeFilter(
        dropdownValue, employeeList, filteredEmployees);
    context.read<FilterListCubit>().updateFilterList(teamIdList);

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

  List<EmployeeModel> parseEmployeeList(String jsonData,
      List<String> teamIdList) {
    final parsedData = json.decode(jsonData)['data'];
    List<EmployeeModel> employeeList = [];

    for (var employeeData in parsedData) {
      EmployeeModel employee = EmployeeModel.fromJson(employeeData);
      employeeList.add(employee);
      if (!teamIdList.contains(employee.teamId)) {
        teamIdList.add(employee.teamId);
      }
      print("${employee.firstName} ${employee.lastName}, ${employee
          .email}, ${employee.employeeId}");
    }
    return employeeList;
  }
}
