import 'package:codepan/bloc/bloc_handler.dart';
import 'package:codepan/bloc/parent_state.dart';
import 'package:employee_email/data/models/entities/employee.dart';

import 'events.dart';

class EmployeeState extends ParentState<EmployeeEvent> {
  @override
  List<Object?> get props => [];

  const EmployeeState();

  @override
  EmployeeEvent mirrorToEvent() {
    return EmployeeEvent(state: this);
  }
}

class EmployeesDisplayed extends EmployeeState {
  final List<EmployeeData> employeeList;

  @override
  List<Object?> get props => [employeeList];

  const EmployeesDisplayed({
    required this.employeeList,
  });
}

class Loading<S extends ParentState> extends EmployeeState
    with FinisherState<S> {
  const Loading();
}

class Error<S extends ParentState> extends EmployeeState with ErrorState<S> {
  final Object _error;

  @override
  Object get error => _error;

  @override
  List<Object?> get props => [error];

  const Error({
    required Object error,
  }) : _error = error;
}
