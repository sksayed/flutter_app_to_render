part of 'lefletmap_bloc.dart';

abstract class LefletmapState extends Equatable {
  LefletmapState();

  @override
  List<Object> get props => [];
}

class LefletmapInitialState extends LefletmapState {
  final List<Place> places;
  final PlaceCategory placeCategory;

  LefletmapInitialState({@required this.places, @required this.placeCategory})
      : assert(places != null),
        assert(placeCategory != null);

  List<Object> get props => [places, placeCategory];
}

class LefletmapReadyState extends LefletmapState {
  final bool mapState;

  LefletmapReadyState(this.mapState);

  @override
  List<Object> get props => [mapState];
}

class MapPlaceCategoryChangedState extends LefletmapInitialState {
  MapPlaceCategoryChangedState(
      {@required List<Place> places, @required PlaceCategory placeCategory})
      : assert(places != null),
        assert(placeCategory != null),
        super(places: places, placeCategory: placeCategory);
}
