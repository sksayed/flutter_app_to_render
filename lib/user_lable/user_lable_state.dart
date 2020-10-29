import 'package:equatable/equatable.dart';

abstract class UserLableState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLableStateInitial extends UserLableState {}

class UserLableStateAutheticated extends UserLableState {
  final String userName;

  UserLableStateAutheticated(this.userName);

  List<Object> get props => [userName];

  @override
  String toString() {
    // TODO: implement toString
    return "UserLableAuthenticated { userName: $userName }";
  }
}
