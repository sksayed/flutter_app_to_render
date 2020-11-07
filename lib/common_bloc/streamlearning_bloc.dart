import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'stream_controller.dart';

part 'streamlearning_event.dart';

part 'streamlearning_state.dart';

class StreamlearningBloc
    extends Bloc<StreamlearningEvent, StreamlearningState> {
  StreamlearningBloc() : super(StreamlearningInitial(0));

  StreamSubscription intSubscription;

  void start() {
    intSubscription = timedCounter(Duration(milliseconds: 100)).listen((event) {
      print(event);
    });
  }

  void pause() {
    intSubscription.pause();
  }

  @override
  Stream<StreamlearningState> mapEventToState(
    StreamlearningEvent event,
  ) async* {
    if (event is StreamlearningStartEvent) {
      start();
    }

    if (event is StreamlearningPauseEvent) {
      pause();
    }

    if (event is StreamlearningResumeEvent) {
      resume();
    }

    if (event is StreamlearningCancelEvent) {
      cancel();
    }
  }

  void resume() {
    intSubscription.resume();
  }

  void cancel() {
    intSubscription.cancel();
  }
}
