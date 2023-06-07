import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<EmployeeModel> employeeList = [];
List<String> teamIdList = <String>['No Filter'];

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
  employeeList = parseEmployeeList(await fetchData());
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
  String selectedFilter = '';
  List<EmployeeModel> filteredEmployees = employeeList;
  String dropdownValue = teamIdList.first;

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
                  if(selectedFilter == "No Filter" || selectedFilter == ""){
                    filteredEmployees = employeeList;
                  }else {
                    filteredEmployees =
                        employeeList.where((employee) => employee.teamId ==
                            selectedFilter).toList();
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
          ],),
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
                  'https://sevie.s3.amazonaws.com/sitefiles/employee/${employee.employeeId}.jpg',
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
              "${employee.firstName}, ${employee.lastName}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(employee.email),
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

Future<Widget> fetchImage(String employeeId) async {
  try {
    Widget image = Image.network(
      'https://sevie.s3.amazonaws.com/sitefiles/employee/${employeeId}.jpg',
      fit: BoxFit.cover,
    );
    return image;
  } catch (e) {
    // Catch the exception and handle it
    print('An error occurred: $e');
    return Image.asset("assets/profile_image.png");
  }
}

class EmployeeModel {
  final String firstName, lastName, email, employeeId, teamId;

  EmployeeModel(
      this.firstName, this.lastName, this.email, this.employeeId, this.teamId);
}

List<EmployeeModel> parseEmployeeList(String jsonData) {
  final parsedData = json.decode(jsonData)['data'];
  List<EmployeeModel> employeeList = [];

  for (var employeeData in parsedData) {
    String firstName = employeeData['firstname'];
    String lastName = employeeData['lastname'];
    String email = employeeData['email'];
    String employeeId = employeeData['employee_id'];
    String teamId = employeeData['team_id'];

    EmployeeModel employee =
        EmployeeModel(firstName, lastName, email, employeeId, teamId);
    employeeList.add(employee);
    if (!teamIdList.contains(employee.teamId)) {
      teamIdList.add(employee.teamId);
    }
    //print("${firstName} ${lastName}, ${email}, ${employeeId}");
  }

  return employeeList;
}
