import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import 'app.dart';
import 'bloc/bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(App(userRepository: UserRepository()));
}

class SimpleBlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}


