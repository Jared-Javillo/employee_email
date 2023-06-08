import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_email/app.dart';
import 'package:employee_email/employee_email_observer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  //Bloc.observer = const EmployeeEmailObserver();
  runApp(const MyApp());
}
