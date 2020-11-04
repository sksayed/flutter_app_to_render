import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_to_render/place_tracker/domain/place.dart';
import 'package:flutter_app_to_render/place_tracker/repo/stub_data.dart';

part 'lefletmap_event.dart';

part 'lefletmap_state.dart';

class LefletmapBloc extends Bloc<LefletmapEvent, LefletmapState> {
  List<Place> places;
  PlaceCategory placeCategory;

  LefletmapBloc(
      {@required this.places = StubData.places,
      @required this.placeCategory = PlaceCategory.favorite})
      : assert(places != null),
        assert(placeCategory != null),
        super(LefletmapInitialState(
            places: StubData.places
                .where((element) => element.category == PlaceCategory.favorite)
                .toList(),
            placeCategory: PlaceCategory.favorite));

  bool mapLoaded;

  @override
  Stream<LefletmapState> mapEventToState(
    LefletmapEvent event,
  ) async* {
    if (event is MapReadyEvent) {
      this.mapLoaded = true;
      yield LefletmapReadyState(this.mapLoaded);
    }

    if (event is MapPlaceCategoryChangedEvent) {
      this.placeCategory = event.placeCategory;
      yield MapPlaceCategoryChangedState(
          places: this
              .places
              .where((element) => element.category == this.placeCategory)
              .toList(),
          placeCategory: this.placeCategory);
    }
  }

  Future<List<Place>> getPlaces() async {
    return await this.places;
  }
}
