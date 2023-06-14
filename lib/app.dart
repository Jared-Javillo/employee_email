import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:employee_email/pages/employee_email_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc/app/bloc.dart';
import 'core/bloc/app/events.dart';
import 'core/bloc/app/states.dart';


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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late final AppBloc _bloc;
  late SqliteAdapter db;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) {
        return _bloc = AppBloc(
          initialEvent: const InitializeDatabase(),
        )
          ..start();
      },
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state is Error<Database>) {
            print("error in database");
          } else if(state is Database) {
            db = state.db;
          }
        },
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: whiteSwatch,
          ),
          home: EmployeeEmailPage(),
        ),
      ),
    );
  }
}
