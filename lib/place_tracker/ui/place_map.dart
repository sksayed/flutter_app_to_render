import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/place_tracker/app_bloc/appstate_bloc.dart';
import 'package:flutter_app_to_render/place_tracker/domain/place.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceMap extends StatefulWidget {
  final LatLng center;

  const PlaceMap({Key key, this.center}) : super(key: key);

  @override
  _PlaceMapState createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap> {
  AppstateBloc _appstateBloc;
  Completer<GoogleMapController> mapController;
  MapType _currentMapType;
  Map<Marker, Place> _markedPlaces = {};
  Set<Marker> _marker = {};
  Marker _pendingMarker;
  LatLng _lastMapPosition;
  BuildContext _contextRecieved;

  Map<Marker, Place> get markedPlaces => _markedPlaces;

  @override
  initState() {
    mapController = Completer();
    _currentMapType = MapType.normal;
    _lastMapPosition = widget.center;
    _appstateBloc = BlocProvider.of<AppstateBloc>(context);
    _contextRecieved = context;
    super.initState();
  }

  Future<void> _onMapCreated(GoogleMapController incomingController) async {
    mapController.complete(incomingController);
    _lastMapPosition = widget.center;
    // Draw initial place markers on creation so that we have something
    // interesting to look at.
    Set<Marker> markers = {};
    for (var place in _appstateBloc.places) {
      markers.add(await _createPlaceMarker(_contextRecieved, place));
    }
    setState(() {
      _marker.addAll(markers);
    });

    _zoomTofitSelectedCatagory();
  }

  Future<Marker> _createPlaceMarker(BuildContext context, Place place) async {
    final marker = Marker(
      markerId: MarkerId(place.latLng.toString()),
      position: place.latLng,
      infoWindow: InfoWindow(
        title: place.name,
        snippet: "${place.starRating} start rating",
        //we will push it to another page on tap of it
      ),
      visible: place.category == _appstateBloc.selectedCategory,
      icon: await _getPlaceMarkerIcon(_contextRecieved, place.category),
    );
    _markedPlaces[marker] = place;
    return marker;
  }

  static Future<BitmapDescriptor> _getPlaceMarkerIcon(
      BuildContext contextRecieved, PlaceCategory category) async {
    switch (category) {
      case PlaceCategory.favorite:
        return BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(contextRecieved,
                size: Size.square(32)),
            "assets/heart.png");
        break;
      case PlaceCategory.visited:
        return BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(contextRecieved,
                size: Size.square(32)),
            "assets/visited.png");
        break;
      case PlaceCategory.wantToGo:
      default:
        return await BitmapDescriptor.defaultMarker;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //at first we will be showing a single map on the screen
    return Center(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: widget.center, zoom: 13.0),
            onMapCreated: _onMapCreated,
            mapType: _currentMapType,
            markers: _marker,
            onCameraMove: (cameraPosition) {
              _lastMapPosition = cameraPosition.target;
            },
          ),
          _CreateCategoryButtonBar(
            selectedPlaceCategory: _appstateBloc.selectedCategory,
            visibilility: _pendingMarker == null,
            onPressed: _switchSelectedCategory,
          ),
        ],
      ),
    );
  }

  Future<void> _switchSelectedCategory(PlaceCategory category) async {
    _appstateBloc.selectedCategory = category;
    await _showPlacesForSelectedCategory(category);
  }

  /// Applies zoom to fit the places of the selected category
  void _zoomTofitSelectedCatagory() {
    _zoomTofitPlaces(_getPlacesForCategory(
        _appstateBloc.selectedCategory, _appstateBloc.places));
  }

  Future<void> _zoomTofitPlaces(List<Place> places) async {
    var controller = await mapController.future;
    // Default min/max values to latitude and longitude of center.
    var minLat = widget.center.latitude;
    var maxLat = widget.center.latitude;
    var minLong = widget.center.longitude;
    var maxLong = widget.center.longitude;

    for (var place in places) {
      minLat = min(minLat, place.latitude);
      maxLat = max(maxLat, place.latitude);
      minLong = min(minLong, place.longitude);
      maxLong = max(maxLong, place.longitude);
    }

    await controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        40));
  }

  static List<Place> _getPlacesForCategory(
      PlaceCategory category, List<Place> places) {
    return places.where((element) => element.category == category).toList();
  }

  Future<void> _showPlacesForSelectedCategory(PlaceCategory category) async {
    setState(() {
      for (var marker in List.of(_markedPlaces.keys)) {
        final place = _markedPlaces[marker];
        final updatedMarker =
            marker.copyWith(visibleParam: place.category == category);
        _updateMarker(
            marker: marker, updatedMarker: updatedMarker, place: place);
      }
    });

    await _zoomTofitPlaces(
        _getPlacesForCategory(category, markedPlaces.values.toList()));
  }

  Future<void> _updateMarker(
      {@required Marker marker,
      @required Marker updatedMarker,
      @required Place place}) async {
    markedPlaces.remove(marker);
    _marker.remove(marker);

    _marker.add(updatedMarker);
    markedPlaces[updatedMarker] = place;
  }
}

class _CreateCategoryButtonBar extends StatelessWidget {
  final PlaceCategory selectedPlaceCategory;
  final bool visibilility;
  final ValueChanged<PlaceCategory> onPressed;

  const _CreateCategoryButtonBar(
      {Key key, this.selectedPlaceCategory, this.visibilility, this.onPressed})
      : assert(selectedPlaceCategory != null),
        assert(visibilility != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        alignment: Alignment.bottomCenter,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                onPressed(PlaceCategory.favorite);
              },
              color: selectedPlaceCategory == PlaceCategory.favorite
                  ? Colors.blue[700]
                  : Colors.lightBlue,
              child: const Text(
                'Favorites',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
            RaisedButton(
              onPressed: () {
                onPressed(PlaceCategory.visited);
              },
              color: selectedPlaceCategory == PlaceCategory.visited
                  ? Colors.blue[700]
                  : Colors.lightBlue,
              child: const Text(
                'Visited',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
            RaisedButton(
              onPressed: () {
                onPressed(PlaceCategory.wantToGo);
              },
              color: selectedPlaceCategory == PlaceCategory.wantToGo
                  ? Colors.blue[700]
                  : Colors.lightBlue,
              child: const Text(
                'Want To Go',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
