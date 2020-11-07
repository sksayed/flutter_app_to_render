part of 'streamlearning_bloc.dart';

abstract class StreamlearningEvent extends Equatable {
  StreamlearningEvent();

  @override
  List<Object> get props => [];
}

class StreamlearningStartEvent extends StreamlearningEvent {}

class StreamlearningPauseEvent extends StreamlearningEvent {}

class StreamlearningResumeEvent extends StreamlearningEvent {}

class StreamlearningCancelEvent extends StreamlearningEvent {}
