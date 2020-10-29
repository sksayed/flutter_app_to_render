import 'package:equatable/equatable.dart';

abstract class HomePageState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageDefaultState extends HomePageState {}

class HomePageModifiedButtonState extends HomePageState {}

class HomePageMoveToAnotherScreen extends HomePageState {}
