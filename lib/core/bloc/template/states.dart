import 'package:codepan/bloc/bloc_handler.dart';
import 'package:codepan/bloc/parent_state.dart';

import 'events.dart';

class TemplateState extends ParentState<TemplateEvent> {
  @override
  List<Object?> get props => [];

  const TemplateState();

  @override
  TemplateEvent mirrorToEvent() {
    return TemplateEvent(state: this);
  }
}

class Loading<S extends ParentState> extends TemplateState
    with FinisherState<S> {
  const Loading();
}

class Error<S extends ParentState> extends TemplateState with ErrorState<S> {
  final Object _error;

  @override
  Object get error => _error;

  @override
  List<Object?> get props => [error];

  const Error({
    required Object error,
  }) : _error = error;
}
