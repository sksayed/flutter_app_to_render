part of 'appstate_bloc.dart';

@immutable
abstract class AppstateState extends Equatable {
  final IconData viewTypeIcon;

  AppstateState(this.viewTypeIcon);

  @override
  List<Object> get props => [viewTypeIcon];
}

@immutable
class AppstateInitialState extends AppstateState {
  final List<Place> places;
  final PlaceCategory selectedCategory;
  final PlaceTrackerViewType viewType;

  AppstateInitialState(
      {this.places,
      this.selectedCategory,
      @required this.viewType,
      IconData viewTypeIcon})
      : super(viewTypeIcon);

  @override
  List<Object> get props => [places, selectedCategory, viewType, viewTypeIcon];
}

@immutable
class AppstateViewTypeChangedState extends AppstateInitialState {
  AppstateViewTypeChangedState(
      {@required List<Place> places,
      @required PlaceCategory selectedCategory,
      @required PlaceTrackerViewType viewType,
      @required IconData viewTypeIcon})
      : super(
            viewType: viewType,
            viewTypeIcon: viewTypeIcon,
            places: places,
            selectedCategory: selectedCategory);

  @override
  List<Object> get props => [places, selectedCategory, viewType, viewTypeIcon];
}

class PlaceCategoryChangedState extends AppstateState {
  final PlaceCategory placeCategory;

  PlaceCategoryChangedState(IconData viewTypeIcon, @required this.placeCategory)
      : assert(viewTypeIcon != null),
        assert(placeCategory != null),
        super(viewTypeIcon);

  @override
  List<Object> get props => [placeCategory, viewTypeIcon];
}

class PlaceCategoryInitialState extends PlaceCategoryChangedState {
  PlaceCategoryInitialState(IconData viewTypeIcon, PlaceCategory placeCategory)
      : super(viewTypeIcon, placeCategory);
}
