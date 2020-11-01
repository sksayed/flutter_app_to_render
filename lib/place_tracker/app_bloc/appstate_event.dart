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

class PlaceCategoryChangedEvent extends AppstateEvent {
  final PlaceCategory placeCategory;

  PlaceCategoryChangedEvent(this.placeCategory);

  @override
  List<Object> get props => [placeCategory];
}

class AppStateInitailEvent extends AppstateEvent {}

class PlaceCategoryInintalEvent extends AppstateEvent {}
