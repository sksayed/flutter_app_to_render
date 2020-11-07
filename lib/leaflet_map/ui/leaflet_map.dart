import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/leaflet_map/bloc/leflet_bloc/lefletmap_bloc.dart';
import 'package:flutter_app_to_render/leaflet_map/moving_car_data_repo/stream_data_repo.dart';
import 'package:flutter_app_to_render/leaflet_map/ui/example_pop_up.dart';
import 'package:flutter_app_to_render/place_tracker/domain/place.dart';
import 'package:flutter_app_to_render/route/route_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

class LeafLetMapHomePage extends StatefulWidget {
  final LatLng center;

  const LeafLetMapHomePage({Key key, @required this.center})
      : assert(center != null),
        super(key: key);

  @override
  _LeafLetMapHomePageState createState() => _LeafLetMapHomePageState();
}

class _LeafLetMapHomePageState extends State<LeafLetMapHomePage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LefletmapBloc _lefletmapBloc;
  LatLng _previousPoint;
  final MapController _mapController = MapController();
  List<Marker> _mapMarkers = [];
  Map<Place, Marker> _markedPlaces = {};
  PlaceCategory _category = PlaceCategory.favorite;
  BuildContext _buildContext;
  List<Place> _places;
  double _previousPointZoom = 10;
  Stream<LatLng> streamsData;

  StreamSubscription<LatLng> _streamSubscription;

  final PopupController _popupController = PopupController();

  @override
  void initState() {
    _places = [];
    _buildContext = context;
    _lefletmapBloc = LefletmapBloc();
    _previousPoint = widget.center;
    _mapController.onReady.whenComplete(() {
      _lefletmapBloc.add(MapReadyEvent());
      _generateMarkers(_places);
    });
    super.initState();
  }

  @override
  void dispose() {
    print("leflet map got disposed");
    _lefletmapBloc.close();
    super.dispose();
  }

  Future<void> _zoomToFitPlaces(List<Place> places) async {
    /* // Default min/max values to latitude and longitude of center.
    var minLat = widget.center.latitude;
    var maxLat = widget.center.latitude;
    var minLong = widget.center.longitude;
    var maxLong = widget.center.longitude;


    for (var place in places) {
      minLat = min(minLat, place.latitude);
      maxLat = max(maxLat, place.latitude);
      minLong = min(minLong, place.longitude);
      maxLong = max(maxLong, place.longitude);
    }*/

    var latlang = LatLngBounds.fromPoints(
        places.map((place) => _getLatLngFromPlace(place)).toList());
    _mapController.fitBounds(latlang,
        options: FitBoundsOptions(padding: EdgeInsets.all(30)));
  }

  Future<void> _generateMarkers(List<Place> places) async {
    //at first place has been fixed

    _mapMarkers.clear();
    final placeMarkerList =
        places.map((e) => _placeToMarker(_buildContext, e, _category)).toList();
    placeMarkerList.forEach((element) {
      element.then((value) => _mapMarkers.add(value));
    });
    _zoomToFitPlaces(places);
  }

  Future<Marker> _placeToMarker(
      BuildContext _context, Place place, PlaceCategory category) async {
    final marker = Marker(
        point: _getLatLngFromPlace(place),
        height: 35,
        width: 35,
        builder: (_context) {
          return GestureDetector(
            child: _getIconForMarker(_context, category),
            onTap: () {
              _animatedMapMove(_getLatLngFromPlace(place), 16);
            },
          );
        });
    _markedPlaces[place] = marker;
    return marker;
  }

  static Image _getIconForMarker(BuildContext context, PlaceCategory category) {
    switch (category) {
      case PlaceCategory.visited:
        return Image.asset(
          "assets/visited.png",
        );
        break;
      case PlaceCategory.wantToGo:
        return Image.asset("assets/heart.png");
        break;
      case PlaceCategory.favorite:
        return Image.asset("assets/point.png");
    }
  }

  void _bottomButtonHasbeenPressed(PlaceCategory placeCategory) {
    _lefletmapBloc.add(MapPlaceCategoryChangedEvent(placeCategory));
  }

  static LatLng _getLatLngFromPlace(Place place) {
    return LatLng(place.latitude, place.longitude);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    print("current map center is " + _mapController.center.toString());
    print("latlng of destination is  " + destLocation.toString());

    _previousPoint = destLocation;
    _previousPointZoom = _mapController.zoom;
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInSine);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final place = _places
            .where((element) =>
                element.latitude == destLocation.latitude &&
                element.longitude == destLocation.longitude)
            .single;
        Marker marker = _markedPlaces[place];
        _popupController.showPopupFor(marker);
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _animatedMapMoveBack(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.

    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutSine);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        /* _previousPointZoom = _mapController.zoom;
        * _zoomToFitPlaces(_places);
        * */
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _animateBackToFitZoom() {
    _animatedMapMoveBack(_previousPoint, _previousPointZoom);
  }

  void _moveToDetailsPage(LatLng latLng) {
    Place place = _places
        .where((place) =>
            place.latitude == latLng.latitude &&
            place.latitude == latLng.latitude)
        .single;
    _popupController.hidePopup();
    var x = Navigator.pushNamed(context, RouteName.placeDetailsPage,
        arguments: {"place": place});
    x.whenComplete(() {
      _animateBackToFitZoom();
    });
  }

  void _showSnackBarWithLatLnag(LatLng givenLatln) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
            "Latitude is ${givenLatln.latitude} and Longitude is ${givenLatln.longitude}")));
    print(
        "Latitude is ${givenLatln.latitude} and Longitude is ${givenLatln.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _lefletmapBloc,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Column(
            children: [
              BlocBuilder<LefletmapBloc, LefletmapState>(
                builder: (context, state) {
                  print("bloc builder called ");
                  if (state is LefletmapInitialState) {
                    _places = state.places;
                    _category = state.placeCategory;
                    _generateMarkers(_places);
                  }

                  if (state is MapPlaceCategoryChangedState) {
                    _places = state.places;
                    _category = state.placeCategory;
                    _generateMarkers(_places);
                  }

                  /*if (state is MapDetailsPageRequestState) {
                    Navigator.pushNamed(context, RouteName.anotherpage,
                        arguments: {"place": state.place});
                  }*/
                  return Visibility(
                    visible: true,
                    child: Flexible(
                      child: FlutterMap(
                        options: MapOptions(
                            center: _previousPoint,
                            minZoom: 5,
                            maxZoom: 18,
                            onTap: (latlng) => {
                                  /*  _animateBackToFitZoom(),
                                  _popupController.hidePopup(), */
                                  _showSnackBarWithLatLnag(latlng)
                                },
                            plugins: [
                              PopupMarkerPlugin(),
                            ]),
                        mapController: _mapController,
                        layers: [
                          /* TileLayerOptions(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                            tileProvider: NonCachingNetworkTileProvider(),
                            keepBuffer: 5,
                          ),*/
                          /*MarkerLayerOptions(markers: _mapMarkers) , */
                          PopupMarkerLayerOptions(
                            popupBuilder: (BuildContext _ctx, Marker marker) =>
                                ExamplePopup(
                                    marker: marker,
                                    detailesButtonPressed: _moveToDetailsPage),
                            popupController: _popupController,
                            markers: _mapMarkers,
                          )
                        ],
                        children: [
                          TileLayerWidget(
                            options: TileLayerOptions(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                              tileProvider: NonCachingNetworkTileProvider(),
                              keepBuffer: 5,
                            ),
                          ),
                          /* MarkerLayerWidget(options: PopupMarkerLayerOptions()),*/
                          _CreateBottomButtonBar(
                              placeCategory: _category,
                              onButtonPressed: _bottomButtonHasbeenPressed),
                        ],
                      ),
                    ),
                  );
                },
              ), //map object ends
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateBottomButtonBar extends StatelessWidget {
  final PlaceCategory placeCategory;
  final ValueChanged<PlaceCategory> onButtonPressed;

  _CreateBottomButtonBar(
      {Key key, @required this.placeCategory, @required this.onButtonPressed})
      : assert(placeCategory != null),
        assert(onButtonPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.all(16),
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () {
              onButtonPressed(PlaceCategory.favorite);
            },
            color: placeCategory == PlaceCategory.favorite
                ? Colors.red
                : Colors.red[200],
            child: Text("Dhaka"),
          ),
          RaisedButton(
            onPressed: () {
              onButtonPressed(PlaceCategory.wantToGo);
            },
            color: placeCategory == PlaceCategory.wantToGo
                ? Colors.red
                : Colors.red[200],
            child: Text("Chittagong"),
          ),
          RaisedButton(
            onPressed: () {
              onButtonPressed(PlaceCategory.visited);
            },
            color: placeCategory == PlaceCategory.visited
                ? Colors.red
                : Colors.red[200],
            child: Text("Khulna"),
          )
        ],
      ),
    );
  }
}
