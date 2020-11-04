import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/leaflet_map/bloc/leflet_bloc/lefletmap_bloc.dart';
import 'package:flutter_app_to_render/place_tracker/domain/place.dart';
import 'package:flutter_app_to_render/route/route_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class LeafLetMapHomePage extends StatefulWidget {
  final LatLng center;

  const LeafLetMapHomePage({Key key, @required this.center})
      : assert(center != null),
        super(key: key);

  @override
  _LeafLetMapHomePageState createState() => _LeafLetMapHomePageState();
}

class _LeafLetMapHomePageState extends State<LeafLetMapHomePage> {
  LefletmapBloc _lefletmapBloc;
  LatLng _previousPoint;
  MapController _mapController;
  List<Marker> _mapMarkers = [];
  Map<Marker, Place> _markedPlaces = {};
  PlaceCategory _category = PlaceCategory.favorite;
  BuildContext _buildContext;
  List<Place> _places;

  @override
  void initState() {
    _mapController = MapController();
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
              _mapController.move(_getLatLngFromPlace(place),20);
            },
          );
        });
    _markedPlaces[marker] = place;
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _lefletmapBloc,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              BlocBuilder<LefletmapBloc, LefletmapState>(
                builder: (context, state) {
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
                  return Visibility(
                    visible: true,
                    child: Flexible(
                      child: FlutterMap(
                        options: MapOptions(
                          center: _previousPoint,
                          minZoom: 0,
                          maxZoom: 23,
                        ),
                        mapController: _mapController,
                        /*layers: [
                          TileLayerOptions(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                            tileProvider: NonCachingNetworkTileProvider(),
                            keepBuffer: 5,
                          ),
                          MarkerLayerOptions(markers: _mapMarkers),
                        ]*/
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
                          MarkerLayerWidget(
                              options:
                                  MarkerLayerOptions(markers: _mapMarkers)),
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
