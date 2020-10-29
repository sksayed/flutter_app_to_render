import 'package:equatable/equatable.dart';

abstract class UserLableEvent extends Equatable {
  List<Object> get props => [];
}

class UserLableAutheticatedEvent extends UserLableEvent {}

class UserLableStartedEvent extends UserLableEvent {}
