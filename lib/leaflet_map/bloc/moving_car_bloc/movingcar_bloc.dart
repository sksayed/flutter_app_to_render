import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app_to_render/leaflet_map/moving_car_data_repo/stream_data_repo.dart';
import 'package:latlong/latlong.dart';

part 'movingcar_event.dart';

part 'movingcar_state.dart';

class MovingcarBloc extends Bloc<MovingcarEvent, MovingcarState> {
  MovingcarBloc() : super(MovingcarInitialState());
  final LatLng center = LatLng(45.51022, -122.69704);
  Stream<LatLng> movingData;
  Stream<MovingcarState> _startListeningFordata() {
    movingData = StreamDataRepo.getMovingData2(Duration(seconds: 1));
    movingData.forEach((element) async* {
      yield MovingCarUpdatedState(element);
    });
  }

  @override
  Stream<MovingcarState> mapEventToState(
    MovingcarEvent event,
  ) async* {
    if (event is MovingCarInitialEvent) {
      yield* _startListeningFordata();
    }
  }
}
