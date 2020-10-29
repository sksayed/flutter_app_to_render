import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appstate_event.dart';
part 'appstate_state.dart';

class AppstateBloc extends Bloc<AppstateEvent, AppstateState> {
  AppstateBloc() : super(AppstateInitial());

  @override
  Stream<AppstateState> mapEventToState(
    AppstateEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
