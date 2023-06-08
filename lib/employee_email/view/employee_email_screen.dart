import 'package:employee_email/employee_email/cubit/employee_email_cubit.dart';
import 'package:employee_email/employee_email/view/employee_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_email/employee_email/employee_email.dart';

/// {@template counter_page}
/// A [StatelessWidget] which is responsible for providing a
/// [CounterCubit] instance to the [CounterView].
/// {@endtemplate}
class EmployeeEmailScreen extends StatelessWidget {
  /// {@macro counter_page}
  const EmployeeEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeEmailCubit(),
      child: const EmployeeEmailView(title: "Employees"),
    );
  }
}
