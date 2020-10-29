import 'package:bloc/bloc.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';


class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial());

  @override
  HomePageState get initialState => HomePageInitial();

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is HomePageInitialEvent) {
      yield HomePageDefaultState();
    }

    if (event is HomePageDefaultButtonPressedEvent) {
      yield HomePageDefaultState();
    }

    if (event is HomePageModifiedButtonPressedEvent) {
      yield HomePageModifiedButtonState();
    }

    if (event is HomePageMoveToNewPageEvent) {
      // find out what to do
      // make a revision on genereated route
    }

    if (event is HomePageLogoutButtonClicked) {
      yield HomePageModifiedButtonState();
    }
  }
}
