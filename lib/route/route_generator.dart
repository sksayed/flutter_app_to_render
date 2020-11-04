import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/authentication/authentication_bloc.dart';
import 'package:flutter_app_to_render/leaflet_map/ui/leaflet_map.dart';
import 'package:flutter_app_to_render/leaflet_map/ui/page_details.dart';
import 'package:flutter_app_to_render/place_tracker/domain/place.dart';
import 'package:flutter_app_to_render/place_tracker/ui/place_tracker_home.dart';
import 'package:flutter_app_to_render/route/route_name.dart';
import 'package:flutter_app_to_render/ui/another_page.dart';
import 'package:flutter_app_to_render/ui/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case RouteName.anotherpage:
        final arg = routeSettings.arguments;
        if (arg is Map<String, Object>) {
          final text = arg["name"];
          // ignore: close_sinks
          final AuthenticationBloc bloc = arg["authBloc"] as AuthenticationBloc;
          return MaterialPageRoute(
            builder: (buildContext) {
              return BlocProvider.value(
                  value: bloc, child: AnotherPage(text: text));
            },
          );
        }
        break;

      case RouteName.placeTrackerHomePage:
        return MaterialPageRoute(
          builder: (buildContext) {
            return PlaceTrackerHomePage();
          },
        );
        break;

      case RouteName.initial:
        return MaterialPageRoute(builder: (_) => SplashPage());
        break;

      case RouteName.leafletMapHomePage:
        return MaterialPageRoute(
          builder: (_) => LeafLetMapHomePage(
            center: LatLng(45.521563, -122.677433),
          ),
        );
        break;

      case RouteName.placeDetailsPage:
        final arg = routeSettings.arguments;
        if (arg is Map<String, Place>) {
          Place place = arg["place"];
          return MaterialPageRoute(
            builder: (_) => PageDetails(
              place: place,
            ),
          );
        }
        break;

      default:
        return _errorRoute();
        break;
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("error page"),
        ),
      );
    });
  }
}
