import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

MaterialColor whiteSwatch = const MaterialColor(0xFFFFFFFF, {
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
  300: Colors.white,
  400: Colors.white,
  500: Colors.white,
  600: Colors.white,
  700: Colors.white,
  800: Colors.white,
  900: Colors.white,
});

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: whiteSwatch,
      ),
      home: const EmployeeEmailScreen(title: 'Employees'),
    );
  }
}

class EmployeeEmailScreen extends StatefulWidget {
  const EmployeeEmailScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EmployeeEmailScreenState createState() => _EmployeeEmailScreenState();
}

class _EmployeeEmailScreenState extends State<EmployeeEmailScreen> {
  // override init .then
  String selectedFilter = '';
  List employeeList = <EmployeeModel>[];
  List<String> teamIdList = ['No Filter'];
  List filteredEmployees = <EmployeeModel>[];
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
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.filter_alt),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
                selectedFilter = value!;
                if (selectedFilter == "No Filter" || selectedFilter == "") {
                  filteredEmployees = employeeList;
                } else {
                  filteredEmployees = employeeList
                      .where((employee) => employee._teamId == selectedFilter)
                      .toList();
                }
              });
            },
            items: teamIdList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: filteredEmployees.length,
          itemBuilder: (BuildContext context, int index) {
            EmployeeModel employee = filteredEmployees[index];

            return EmployeeCard(employee);
          },
        ),
      ),
    );
  }
  Future<void> initializeData() async {
    dropdownValue = teamIdList.first;
    employeeList = parseEmployeeList(await fetchData(), teamIdList);
    filteredEmployees = employeeList;
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

  List<EmployeeModel> parseEmployeeList(
      String jsonData, List<String> teamIdList) {
    final parsedData = json.decode(jsonData)['data'];
    List<EmployeeModel> employeeList = [];

    for (var employeeData in parsedData) {
      EmployeeModel employee = EmployeeModel.fromJson(employeeData);
      employeeList.add(employee);
      if (!teamIdList.contains(employee._teamId)) {
        teamIdList.add(employee._teamId);
      }
      //print("${employee.firstName} ${employee.lastName}, ${employee.email}, ${employee.employeeId}");
    }
    return employeeList;
  }
}

class EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final String filterTeamId = "";

  const EmployeeCard(this.employee, {super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: SizedBox(
              width: screenSize.width * 0.15,
              height: screenSize.width * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://sevie.s3.amazonaws.com/sitefiles/employee/${employee._employeeId}.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    //print('An error occurred: $error');
                    return Image.asset("assets/profile_image.png");
                  },
                ),
              ),
            ),
            title: Text(
              "${employee._firstName}, ${employee._lastName}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(employee._email),
          ),
          Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.05),
            child: Divider(
              indent: screenSize.width * 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeModel {
  final String _firstName;
  final String _lastName;
  final String _email;
  final String _employeeId;
  final String _teamId;

  const EmployeeModel({
    required String firstName,
    required String lastName,
    required String email,
    required String employeeId,
    required String teamId,
  })  : _firstName = firstName,
        _lastName = lastName,
        _email = email,
        _employeeId = employeeId,
        _teamId = teamId;

  factory EmployeeModel.fromJson(Map<String, dynamic> map) {
    return EmployeeModel(
      firstName: map['firstname'],
      lastName: map['lastname'],
      email: map['email'],
      employeeId: map['employee_id'],
      teamId: map['team_id'],
    );
  }
//Factory constructor <- handle json parsing
}
