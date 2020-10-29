import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/authentication/authentication_bloc.dart';
import 'package:flutter_app_to_render/route/route_name.dart';
import 'package:flutter_app_to_render/ui/another_page.dart';
import 'package:flutter_app_to_render/ui/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

      case RouteName.initial:
        return MaterialPageRoute(builder: (_) => SplashPage());

      default:
        return _errorRoute();
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
