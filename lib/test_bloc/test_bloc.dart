import 'package:flutter_app_to_render/test_bloc/test_bloc_event.dart';
import 'package:flutter_app_to_render/test_bloc/test_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestState());

  String getMyName() {
    return "Sheikh Sayed Bin";
  }

  @override
  Stream<TestState> mapEventToState(TestEvent event) {}
}
