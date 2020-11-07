import 'dart:async';
import 'dart:io';

import 'package:latlong/latlong.dart';

class StreamDataRepo {
  final String initalStrData =
      "Latitude is 45.51022349790432 and Longitude is -122.6970442568848";
  static double lat = 45.51022;
  static double lon = -122.69704;

  ///now i will create a function that will
  ///return a stream of latLon , over the duration of specified time

  static Stream<LatLng> getMovingData(Duration duration, [int maxCount]) {
    StreamController<LatLng> _controller;
    Timer _timer;
    double lat = 45.51022;
    double lon = -122.69704;
    _incrementValue() {
      lat = lat - 0.10000;
      lon = lon + 0.10000;
    }

    void _startTime() {
      /// timer has been started
      _timer = Timer.periodic(duration, (timer) {
        _incrementValue();
        _controller.add(LatLng(lat, lon));
      });
    }

    void _stopTime() {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
    }

    _controller = StreamController<LatLng>(
        onListen: _startTime,
        onResume: _startTime,
        onPause: _stopTime,
        onCancel: _stopTime);

    return _controller.stream;
  }
}
