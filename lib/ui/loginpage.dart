import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/authentication/authentication_bloc.dart';
import 'package:flutter_app_to_render/login/login_bloc.dart';
import 'package:flutter_app_to_render/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'loginform.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  UserRepository _userRepository;
  @override
  void initState() {
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
        userRepository: _userRepository,
        authenticationBloc: _authenticationBloc);
    super.initState();
  }

  @override
  void dispose() {
    print("login page is dispoed");
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: LoginForm(
        loginBloc: _loginBloc,
        authenticationBloc: _authenticationBloc,
      ),
    );
  }
}
