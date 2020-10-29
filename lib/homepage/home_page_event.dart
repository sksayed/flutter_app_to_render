import 'package:equatable/equatable.dart';

abstract class HomePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomePageDefaultButtonPressedEvent extends HomePageEvent {}

class HomePageModifiedButtonPressedEvent extends HomePageEvent {}

class HomePageMoveToNewPageEvent extends HomePageEvent {}

class HomePageInitialEvent extends HomePageEvent {}

class HomePageLogoutButtonClicked extends HomePageEvent {}
