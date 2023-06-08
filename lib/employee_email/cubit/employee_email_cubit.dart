import 'package:bloc/bloc.dart';
import 'package:employee_email/employee_email/model/employee_model.dart';

/// {@template counter_cubit}
/// A [Cubit] which manages an [String] as its state.
/// {@endtemplate}
class EmployeeEmailCubit extends Cubit<List<EmployeeModel>>{
  /// {@macro counter_cubit}
  EmployeeEmailCubit() : super([]);

  void changeFilter(String filter,List<EmployeeModel> employeeList, List<EmployeeModel> filteredEmployees) {
    if (filter == "No Filter" || filter == "") {
      filteredEmployees = employeeList;
    } else {
      filteredEmployees = employeeList
          .where((employee) => employee.teamId == filter)
          .toList();
    }
    emit(filteredEmployees);
  }
}