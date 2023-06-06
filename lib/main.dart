import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<EmployeeModel> employeeList = [];

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

class EmployeeEmailScreen extends StatelessWidget {
  const EmployeeEmailScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: employeeList.length,
          itemBuilder: (BuildContext context, int index) {
            EmployeeModel employee = employeeList[index];

            return EmployeeCard(employee);
          },
        ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;

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
                    print('An error occurred: $error');
                    return Image.asset(
                        "assets/profile_image.png"); // Replace with your error handling widget
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
            // Set a different right padding
            child: Divider(
              indent: screenSize.width *
                  0.05, // Specify the indent or left margin of the divider
            ), // Add another Divider widget
          ),
          // Add another Divider widget
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
  final String firstName, lastName, email, employeeId;

  EmployeeModel(this.firstName, this.lastName, this.email, this.employeeId);
}

List<EmployeeModel> parseEmployeeList(String jsonData) {
  final parsedData = json.decode(jsonData)['data'];
  List<EmployeeModel> employeeList = [];

  for (var employeeData in parsedData) {
    String firstName = employeeData['firstname'];
    String lastName = employeeData['lastname'];
    String email = employeeData['email'];
    String employeeId = employeeData['employee_id'];

    EmployeeModel employee =
        EmployeeModel(firstName, lastName, email, employeeId);
    employeeList.add(employee);
    //print("${firstName} ${lastName}, ${email}, ${employeeId}");
  }

  return employeeList;
}
