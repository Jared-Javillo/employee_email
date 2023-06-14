import 'package:codepan/bloc/parent_event.dart';
import 'package:codepan/bloc/parent_state.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';

class AppEvent extends ParentEvent {
  @override
  List<Object?> get props => [];

  const AppEvent({
    ParentState? state,
  }) : super(state);
}

class InitializeDatabase extends AppEvent {
  const InitializeDatabase();
}

