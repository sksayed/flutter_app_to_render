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

class MapDetailsPageRequestEvent extends LefletmapEvent {
  final LatLng point;
  MapDetailsPageRequestEvent({@required this.point}) : assert(point != null);

  @override
  List<Object> get props => [point];
}
