part of 'lefletmap_bloc.dart';

abstract class LefletmapEvent extends Equatable {
  LefletmapEvent();

  @override
  List<Object> get props => [];
}

class MapReadyEvent extends LefletmapEvent {}

class MapPlaceCategoryChangedEvent extends LefletmapEvent {
  final PlaceCategory placeCategory;

  MapPlaceCategoryChangedEvent(this.placeCategory)
      : assert(placeCategory != null);
}
