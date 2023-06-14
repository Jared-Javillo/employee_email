import 'package:codepan/data/database/initializer.dart';
import 'package:codepan/extensions/context.dart';
import 'package:codepan/resources/dimensions.dart';
import 'package:codepan/utils/debouncer.dart';
import 'package:codepan/widgets/text.dart';
import 'package:employee_email/data/database/db_config.dart';
import 'package:employee_email/core/bloc/app/bloc.dart';
import 'package:employee_email/core/bloc/employee_email/bloc.dart';
import 'package:employee_email/core/bloc/employee_email/events.dart';
import 'package:employee_email/core/bloc/employee_email/states.dart';
import 'package:employee_email/data/models/entities/employee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:codepan/widgets/page_builder.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:codepan/data/database/sqlite_cache.dart';

import 'mixins/error_properties.dart';

class EmployeeEmailPage extends StatefulWidget {
  const EmployeeEmailPage({
    super.key,
  });

  @override
  State<EmployeeEmailPage> createState() => EmployeeEmailPageState();
}

class EmployeeEmailPageState extends State<EmployeeEmailPage>
    with ErrorPropertiesMixin {
  late final EmployeeBloc _bloc;
  late List<EmployeeData> _employeeList;

  @override
  void initState() {
    _employeeList = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimension.of(context);
    return PageBlocBuilder<EmployeeEvent, EmployeeBloc, EmployeeState>(
      creator: (context)  {
        return _bloc = EmployeeBloc(
          initialEvent: const GetEmployees(
          ),
        )..start();
      },
      observer: (context, state) {
        if (state is EmployeesDisplayed) {
          setState(() {
            _employeeList = state.employeeList;
          });
        } else if (state is Error) {
          showError(context, state.message);
        }
      },
      behaviour: PageScrollBehaviour.none,
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Employees",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: const [],
            ),
            body: Center(
              child: ListView.builder(
                itemCount: _employeeList.length,
                itemBuilder: (BuildContext context, int index) {
                  EmployeeData employee = _employeeList[index];

                  return EmployeeCard(employee);
                },
              ),
            ));
      },
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final EmployeeData employee;
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
            subtitle: Text(employee.email ?? ""),
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
