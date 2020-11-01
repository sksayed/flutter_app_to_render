part of 'appstate_bloc.dart';

@immutable
abstract class AppstateState extends Equatable {
  final IconData viewTypeIcon;

  AppstateState(this.viewTypeIcon);

  @override
  List<Object> get props => [viewTypeIcon];
}

@immutable
class AppstateInitial extends AppstateState {
  final List<Place> places;
  final PlaceCategory selectedCategory;
  final PlaceTrackerViewType viewType;

  AppstateInitial(
      {this.places,
      this.selectedCategory,
      @required this.viewType,
      IconData viewTypeIcon})
      : super(viewTypeIcon);

  @override
  List<Object> get props => [places, selectedCategory, viewType, viewTypeIcon];
}

@immutable
class AppstateViewTypeChangedState extends AppstateInitial {
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
