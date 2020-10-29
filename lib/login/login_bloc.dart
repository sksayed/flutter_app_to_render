import 'package:bloc/bloc.dart';
import 'package:flutter_app_to_render/authentication/authentication_bloc.dart';
import 'package:flutter_app_to_render/authentication/authentication_event.dart';
import 'package:flutter_app_to_render/repository/user_repository.dart';
import 'package:meta/meta.dart';

import 'login_event.dart';
import 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({@required this.userRepository, @required this.authenticationBloc})
      : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(LoginInitial());

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final token = await userRepository.authenticate(
            username: event.username, password: event.password);
        authenticationBloc.add(LoggedIn(token: token));
        yield LoginInitial();
      } catch (exp) {
        yield LoginFailure(error: exp.toString());
      }
    }
  }
}
