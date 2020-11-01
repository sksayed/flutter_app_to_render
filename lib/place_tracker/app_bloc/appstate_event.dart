part of 'appstate_bloc.dart';

abstract class AppstateEvent extends Equatable {
  AppstateEvent();

  @override
  List<Object> get props => [];
}

class ViewTypeButtonClickedEvent extends AppstateEvent {
  @override
  List<Object> get props => [];
}
