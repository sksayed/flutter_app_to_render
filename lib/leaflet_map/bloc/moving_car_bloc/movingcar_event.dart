part of 'movingcar_bloc.dart';

abstract class MovingcarEvent extends Equatable {
  MovingcarEvent();

  @override
  List<Object> get props => [];
}


class MovingCarInitialEvent extends MovingcarEvent {}
