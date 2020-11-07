import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/leaflet_map/bloc/moving_car_bloc/movingcar_bloc.dart';
import 'package:flutter_app_to_render/leaflet_map/moving_car_data_repo/stream_data_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class CarMovement extends StatefulWidget {
  @override
  _CarMovementState createState() => _CarMovementState();
}

class _CarMovementState extends State<CarMovement> {
  final MovingcarBloc _movingcarBloc = MovingcarBloc();

  @override
  void initState() {
    _movingcarBloc.add(MovingCarInitialEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moving car example"),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (BuildContext ctx) => _movingcarBloc,
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: _movingcarBloc.center,
                ),
                children: [
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                      tileProvider: NonCachingNetworkTileProvider(),
                    ),
                  ),
                  /* PolylineLayerWidget(
                  options: PolylineLayerOptions(),
                ),*/
                  _MarkerOnData(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkerOnData extends StatefulWidget {
  @override
  _MarkerOnDataState createState() => _MarkerOnDataState();
}

class _MarkerOnDataState extends State<_MarkerOnData> {
  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovingcarBloc, MovingcarState>(
      builder: (context, state) {
        if (state is MovingCarUpdatedState) {
          _markers.clear();
          _markers = [
            Marker(
                point: state.point, builder: (ctx) => Icon(Icons.car_rental)),
          ];
        }
        return MarkerLayerWidget(
          options: MarkerLayerOptions(markers: _markers),
        );
      },
    );
  }
}
