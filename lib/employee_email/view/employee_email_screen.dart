import 'package:employee_email/employee_email/cubit/employee_email_cubit.dart';
import 'package:employee_email/employee_email/cubit/filter_list_Cubit.dart';
import 'package:employee_email/employee_email/view/employee_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_email/employee_email/employee_email.dart';

class EmployeeEmailScreen extends StatelessWidget {
  const EmployeeEmailScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeEmailCubit>(
          create: (_) => EmployeeEmailCubit(),
        ),
        BlocProvider<FilterListCubit>(
          create: (_) => FilterListCubit(),
        ),
      ],
      child: const EmployeeEmailView(title: "Employees"),
    );
  }
}

