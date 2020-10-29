import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/repository/user_repository.dart';
import 'package:flutter_app_to_render/route/route_generator.dart';
import 'package:flutter_app_to_render/ui/homepage.dart';
import 'package:flutter_app_to_render/ui/loginpage.dart';
import 'package:flutter_app_to_render/ui/splash_page.dart';
import 'package:flutter_app_to_render/ui/statelesswidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication_bloc.dart';
import 'authentication/authentication_event.dart';
import 'authentication/authentication_state.dart';
import 'main3.dart';

class App extends StatefulWidget {
  static const String gmapKey = "AIzaSyA-ILRTlV8Gd-GvTXEP1oUQej4Q9ZDhe1k";
  final UserRepository userRepository;

  const App({Key key, @required this.userRepository}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;

  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(context) {
    return RepositoryProvider(
      create: (repositoryContext) => userRepository,
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => authenticationBloc,
        lazy: false,
        child: MaterialApp(
          onGenerateRoute: RouteGenerator.generateRoute,
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, AuthenticationState state) {
              if (state is AuthenticationUninitialized) {
                return SplashPage();
              }
              if (state is AuthenticationAuthenticated) {
                return HomePage();
              }
              if (state is AuthenticationLoading) {
                return LoadingIndicator();
              }
              if (state is AuthenticationUnauthenticated) {
                return LoginPage();
              }

              return Scaffold(
                body: Center(
                  child: Text("None of the state was invoked"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
