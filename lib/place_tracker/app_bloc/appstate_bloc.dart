import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/authentication/authentication_event.dart';
import 'package:flutter_app_to_render/place_tracker/domain/place.dart';
import 'package:flutter_app_to_render/place_tracker/repo/stub_data.dart';
import 'package:flutter_app_to_render/place_tracker/ui/place_tracker_home.dart';

part 'appstate_event.dart';

part 'appstate_state.dart';

class AppstateBloc extends Bloc<AppstateEvent, AppstateState> {
  AppstateBloc(
      {this.places = StubData.places,
      this.selectedCategory = PlaceCategory.favorite,
      this.viewType = PlaceTrackerViewType.map,
      this.viewTypeIcon = Icons.map})
      : assert(places != null),
        assert(selectedCategory != null),
        super(AppstateInitialState(
            places: places,
            selectedCategory: selectedCategory,
            viewType: viewType,
            viewTypeIcon: viewTypeIcon)) {
    this.viewTypeIcon =
        viewType == PlaceTrackerViewType.map ? Icons.map : Icons.list;
  }

  List<Place> places;
  PlaceCategory selectedCategory;
  PlaceTrackerViewType viewType;
  IconData viewTypeIcon;

  @override
  Stream<AppstateState> mapEventToState(
    AppstateEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is ViewTypeButtonClickedEvent) {
      _toggleViewType();
      yield AppstateViewTypeChangedState(
          viewType: this.viewType,
          places: this.places,
          selectedCategory: selectedCategory,
          viewTypeIcon: this.viewTypeIcon);
    }

    if (event is PlaceCategoryChangedEvent) {
      _changeCategoryType(event.placeCategory);
      yield PlaceCategoryChangedState(this.viewTypeIcon, this.selectedCategory);
    }

    if (event is PlaceCategoryInintalEvent) {
      yield PlaceCategoryInitialState(this.viewTypeIcon, this.selectedCategory);
    }
  }

  void _changeCategoryType(PlaceCategory placeCategory) {
    this.selectedCategory = placeCategory;
  }

  void _toggleViewType() {
    this.viewType == PlaceTrackerViewType.map
        ? this.viewType = PlaceTrackerViewType.listView
        : this.viewType = PlaceTrackerViewType.map;

    this.viewTypeIcon =
        this.viewType == PlaceTrackerViewType.map ? Icons.map : Icons.list;
  }
}

enum PlaceTrackerViewType { map, listView }
