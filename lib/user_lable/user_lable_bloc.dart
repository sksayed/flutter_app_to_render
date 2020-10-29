import 'package:bloc/bloc.dart';
import 'package:flutter_app_to_render/authentication/authentication_bloc.dart';
import 'package:flutter_app_to_render/authentication/authentication_state.dart';
import 'package:flutter_app_to_render/repository/user_repository.dart';
import 'package:flutter_app_to_render/user_lable/user_lable_event.dart';

import 'dart:async';

import 'package:flutter_app_to_render/user_lable/user_lable_state.dart';

class UserLableBloc extends Bloc<UserLableEvent, UserLableState> {
  StreamSubscription authBlocSubscription;
  final AuthenticationBloc _authenticationBloc;
  final UserRepository _userRepo;

  UserLableBloc(this._authenticationBloc, this._userRepo)
      : super(UserLableStateInitial()) {
    authBlocSubscription = _authenticationBloc.listen((state) {
      if (state is AuthenticationAuthenticated) {
        add(UserLableAutheticatedEvent());
      }
    });
  }

  Stream<UserLableState> _broadCastEvent() async* {
    var name = await _userRepo.getUserName();
    yield UserLableStateAutheticated(name);
  }

  @override
  Stream<UserLableState> mapEventToState(UserLableEvent event) async* {
    if (event is UserLableAutheticatedEvent) {
      var name = await _userRepo.getUserName();
      yield UserLableStateAutheticated(name);
    }
  }

  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }

  Future<String> getPassword() {
    return _userRepo.getPassword();
  }
}
