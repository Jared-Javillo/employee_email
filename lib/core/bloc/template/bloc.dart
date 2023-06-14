import 'package:codepan/bloc/parent_bloc.dart';

import 'events.dart';
import 'states.dart';

class TemplateBloc extends ParentBloc<TemplateEvent, TemplateState> {
  TemplateBloc({
    TemplateEvent? initialEvent,
  }) : super(
          initialEvent: initialEvent,
          initialState: const TemplateState(),
        ) {
    on<LoadTemplate>((event, emit) async {

    });
  }
}
