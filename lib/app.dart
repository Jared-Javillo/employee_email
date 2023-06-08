import 'package:flutter/material.dart';
import 'package:employee_email/employee_email/view/employee_email_screen.dart';

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
      home: const EmployeeEmailScreen(),
    );
  }
}
