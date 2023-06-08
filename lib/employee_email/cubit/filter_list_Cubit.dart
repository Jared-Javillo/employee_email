import 'package:bloc/bloc.dart';
import 'package:employee_email/employee_email/model/employee_model.dart';

/// {@template counter_cubit}
/// A [Cubit] which manages an [String] as its state.
/// {@endtemplate}
class FilterListCubit extends Cubit<List<String>>{
  /// {@macro counter_cubit}
  FilterListCubit() : super(["No Filter"]);

  void updateFilterList(List<String> filterList){
    emit(filterList);
  }
}