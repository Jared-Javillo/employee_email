import 'package:codepan/bloc/bloc_handler.dart';
import 'package:codepan/bloc/parent_state.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';

import 'events.dart';

class AppState extends ParentState<AppEvent> {
  const AppState();

  @override
  List<Object?> get props => [];

  @override
  AppEvent mirrorToEvent() {
    return AppEvent(state: this);
  }
}

class Database extends AppState {
  final SqliteAdapter db;

  @override
  List<Object?> get props => [db];

  const Database({
    required this.db,
  });
}

class Relaunch extends AppState {}

class Loading<S extends ParentState> extends AppState with FinisherState<S> {
  final String? message;

  @override
  List<Object?> get props => [message];

  const Loading({
    this.message,
  });
}

class Error<S extends ParentState> extends AppState with ErrorState<S> {
  final Object _error;

  @override
  Object get error => _error;

  @override
  List<Object?> get props => [error];

  const Error({
    required Object error,
  }) : _error = error;
}
