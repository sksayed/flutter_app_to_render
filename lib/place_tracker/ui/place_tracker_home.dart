import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/place_tracker/app_bloc/appstate_bloc.dart';
import 'package:flutter_app_to_render/place_tracker/ui/place_list.dart';
import 'package:flutter_app_to_render/place_tracker/ui/place_map.dart';
import 'package:flutter_app_to_render/place_tracker/ui/place_tracker_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceTrackerHomePage extends StatefulWidget {
  @override
  _PlaceTrackerHomePageState createState() => _PlaceTrackerHomePageState();
}

class _PlaceTrackerHomePageState extends State<PlaceTrackerHomePage> {
  AppstateBloc _appstateBloc;

  AppstateBloc get getAppStateBloc => _appstateBloc;

  void _appBarIconClicked() {
    getAppStateBloc.add(ViewTypeButtonClickedEvent());
  }

  @override
  void initState() {
    _appstateBloc = AppstateBloc();
    _appstateBloc.add(AppStateInitailEvent());
    _appstateBloc.add(PlaceCategoryInintalEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (blocProviderContext) => _appstateBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.pin_drop),
              Padding(padding: EdgeInsets.only(left: 8)),
              Text("Gomax Tracker"),
            ],
          ),
          actions: [
            //inside actions only the image button will change
            BlocBuilder<AppstateBloc, AppstateState>(builder: (context, state) {
              if (state is AppstateInitialState) {
                return Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: IconButton(
                    icon: Icon(state.viewTypeIcon, color: Colors.white),
                    onPressed: _appBarIconClicked,
                  ),
                );
              }
              if (state is AppstateViewTypeChangedState) {
                return Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: IconButton(
                    icon: Icon(state.viewTypeIcon, color: Colors.white),
                    onPressed: _appBarIconClicked,
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: IconButton(
                  icon: Icon(getAppStateBloc.viewTypeIcon, color: Colors.white),
                  onPressed: _appBarIconClicked,
                ),
              );
            }),
          ],
        ),
        body: BlocBuilder<AppstateBloc, AppstateState>(
          builder: (cntx, state) {
            final int val = state.viewTypeIcon == Icons.map ? 0 : 1;
            return IndexedStack(
              index: val,
              children: [
                PlaceMap(center: const LatLng(45.521563, -122.677433)),
                PlaceTrackerList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
