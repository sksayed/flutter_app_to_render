import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/authentication/authentication_bloc.dart';
import 'package:flutter_app_to_render/login/login_bloc.dart';
import 'package:flutter_app_to_render/login/login_event.dart';
import 'package:flutter_app_to_render/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;

  LoginBloc get getLoginBloc => loginBloc;

  LoginForm(
      {Key key, @required this.loginBloc, @required this.authenticationBloc})
      : assert(loginBloc != null),
        assert(authenticationBloc != null),
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    _loginBloc.add(LoginButtonPressed(
      username: _usernameController.text,
      password: _passwordController.text,
    ));
  }

  @override
  Widget build(context) {
    return BlocBuilder<LoginBloc, LoginState>(
      cubit: _loginBloc,
      builder: (context, loginState) {
        if (loginState is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${loginState.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Form(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 50, 16, 0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'username'),
                    controller: _usernameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'password'),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  RaisedButton(
                    onPressed: loginState is! LoginLoading
                        ? _onLoginButtonPressed
                        : null,
                    child: Text('Login'),
                  ),
                  Container(
                    child: loginState is LoginLoading
                        ? CircularProgressIndicator()
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
