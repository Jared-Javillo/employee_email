import 'package:flutter/material.dart';
import 'package:employee_email/employee_email/model/employee_model.dart';

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
