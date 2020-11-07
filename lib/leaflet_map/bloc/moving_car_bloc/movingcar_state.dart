part of 'movingcar_bloc.dart';

abstract class MovingcarState extends Equatable {
  MovingcarState();

  @override
  List<Object> get props => [];
}

class MovingcarInitialState extends MovingcarState {}

class MovingCarUpdatedState extends MovingcarState {
  final LatLng point;

  MovingCarUpdatedState(this.point) : assert(point != null);
}
