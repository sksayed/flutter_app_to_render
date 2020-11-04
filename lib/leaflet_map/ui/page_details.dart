import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/place_tracker/domain/place.dart';
import 'package:flutter_app_to_render/place_tracker/repo/stub_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class PageDetails extends StatelessWidget {
  final Place place;

  const PageDetails({Key key, this.place})
      : assert(place != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: 250,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: _Mymap(place: place),
              ),
            ),
          ),
          Flexible(
            child: ListView(children: [
              Column(
                children: [
                  _Description(
                    place: place,
                  ),
                  _StarBar(
                    rating: place.starRating,
                  ),
                  _Reviews()
                ],
              ),
            ]),
            flex: 2,
          )
        ],
      ),
    );
  }
}

class _Mymap extends StatefulWidget {
  final Place place;

  _Mymap({Key key, this.place})
      : assert(place != null),
        super(key: key) {}

  @override
  _MymapState createState() => _MymapState(place);
}

class _MymapState extends State<_Mymap> {
  MapController _mapController;
  List<Marker> _mapMarkers = [];
  Place place;

  _MymapState(Place place) {
    this.place = place;

    final marker = Marker(
        point: _getLatLngFromPlace(place),
        builder: (_) => _getIconForMarker(place.category));

    _mapMarkers.add(marker);
  }

  static LatLng _getLatLngFromPlace(Place place) {
    return LatLng(place.latitude, place.longitude);
  }

  static Image _getIconForMarker(PlaceCategory category) {
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

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: _getLatLngFromPlace(place),
        zoom: 13,
        interactive: false,
        controller: _mapController,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          tileProvider: NonCachingNetworkTileProvider(),
          keepBuffer: 5,
        ),
        MarkerLayerOptions(markers: _mapMarkers),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  final Place place;

  const _Description({Key key, this.place})
      : assert(place != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListTile(
        title: Text("${place.name} is the name of the place"),
        subtitle: Text(
            "${place.category} is the category of this place , ${place.description}"),
      ),
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Reviews',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        Column(
          children: StubData.reviewStrings
              .map((reviewText) => _buildSingleReview(reviewText))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSingleReview(String reviewText) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    width: 3,
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '5',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 36,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  reviewText,
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          color: Colors.grey[700],
        ),
      ],
    );
  }
}

class _StarBar extends StatelessWidget {
  static const int maxStars = 5;

  final int rating;

  const _StarBar({
    @required this.rating,
    Key key,
  })  : assert(rating != null && rating >= 0 && rating <= maxStars),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxStars, (index) {
        return IconButton(
          icon: const Icon(Icons.star),
          iconSize: 40,
          color: rating > index ? Colors.amber : Colors.grey[400],
          onPressed: () {},
        );
      }).toList(),
    );
  }
}
