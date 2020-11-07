part of 'streamlearning_bloc.dart';

abstract class StreamlearningState extends Equatable {
  final int value;
  StreamlearningState(this.value) : assert(value != null);

  @override
  List<Object> get props => [value];
}

class StreamlearningInitial extends StreamlearningState {
  StreamlearningInitial(int value) : super(value);
}
