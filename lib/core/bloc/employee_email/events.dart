import 'package:codepan/bloc/parent_event.dart';
import 'package:codepan/bloc/parent_state.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';
import 'package:employee_email/data/models/entities/team.dart';

class EmployeeEvent extends ParentEvent {
  @override
  List<Object?> get props => [];

  const EmployeeEvent({
    ParentState? state,
  }) : super(state);
}

class GetEmployees extends EmployeeEvent {

  @override
  List<Object?> get props => [
  ];

  const GetEmployees(
      );
}
