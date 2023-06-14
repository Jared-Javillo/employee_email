import 'package:codepan/bloc/parent_event.dart';
import 'package:codepan/bloc/parent_state.dart';
import 'package:codepan/data/database/sqlite_adapter.dart';

class TemplateEvent extends ParentEvent {
  @override
  List<Object?> get props => [];

  const TemplateEvent({
    ParentState? state,
  }) : super(state);
}

class LoadTemplate extends TemplateEvent {
  final SqliteAdapter db;

  @override
  List<Object?> get props => [db];

  const LoadTemplate({
    required this.db,
  });
}
