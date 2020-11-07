import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/authentication/authentication_bloc.dart';
import 'package:flutter_app_to_render/homepage/home_bloc.dart';
import 'package:flutter_app_to_render/homepage/home_page_event.dart';
import 'package:flutter_app_to_render/homepage/home_page_state.dart';
import 'package:flutter_app_to_render/repository/user_repository.dart';
import 'package:flutter_app_to_render/route/route_name.dart';
import 'package:flutter_app_to_render/test_bloc/test_bloc.dart';
import 'package:flutter_app_to_render/user_lable/user_lable_bloc.dart';
import 'package:flutter_app_to_render/user_lable/user_lable_event.dart';
import 'package:flutter_app_to_render/user_lable/user_lable_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'default_home_page.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //it needs a appbar lable mvc
  // so it needs a bloc
  UserLableBloc userLableBloc;
  AuthenticationBloc _authenticationBloc;
  HomePageBloc _homePageBloc;
  UserRepository _userRepository;

  @override
  void initState() {
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    print(_authenticationBloc.getMyName());
    userLableBloc = UserLableBloc(_authenticationBloc, _userRepository);
    userLableBloc.add(UserLableAutheticatedEvent());
    _homePageBloc = HomePageBloc();
    _homePageBloc.add(HomePageInitialEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("home page gets disposed");
    userLableBloc.close();
    _homePageBloc.close();
    super.dispose();
  }

  @override
  Widget build(context) {
    print("Home page has been created");
    return MultiBlocProvider(
      providers: [
        BlocProvider<TestBloc>(create: (context) => TestBloc()),
        BlocProvider<HomePageBloc>(
          create: (context) => _homePageBloc,
          lazy: false,
        ),
      ],
      child: SafeArea(
        top: true,
        child: Scaffold(
          drawer: Drawer(
            semanticLabel: "i dont know what it is ",
            child: ListView(
              children: [
                FutureBuilder(
                  initialData: null,
                  future: _userRepository.getUsernameAndPassWord(),
                  builder: (context, asyncData) {
                    if (asyncData.hasData) {
                      return createNavDrawerHeader(
                          Text(asyncData.data[UserRepository.username]),
                          Text(asyncData.data[UserRepository.password]));
                    }
                    return createNavDrawerHeader(
                        Text("data ase nai"), Text("data ase nai"));
                  },
                ), //Drawer Header
                ExpansionTile(
                  title: Text("Flowers"),
                  subtitle: Text("List of flowers"),
                  onExpansionChanged: (changed) {
                    print("the value of expansion is $changed");
                  },
                  children: [
                    ListTile(
                      title: Text("Hasna Hena"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Rose"),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Jasmine"),
                    )
                  ],
                ), //end of expansion list
                ListTile(
                  title: Text("Default Home Page"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    /*  HomePageBloc b = BlocProvider.of<HomePageBloc>(context);
                    print(b);*/
                    /*TestBloc bloc = BlocProvider.of<TestBloc>(context);
                    print(bloc.getMyName());
                    print(context);
                    BlocProvider.of<HomePageBloc>(context)
                        .add(HomePageDefaultButtonPressedEvent());*/
                    Navigator.of(context).pop();
                    /*BlocProvider.of<HomePageBloc>(context)
                        .add(HomePageDefaultButtonPressedEvent());*/
                    _homePageBloc.add(HomePageDefaultButtonPressedEvent());
                  },
                ),
                Divider(
                  thickness: 1,
                  color: Colors.blueGrey,
                ),
                ListTile(
                  title: Text("Modified Home Page"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    /*BlocProvider.of<HomePageBloc>(context)
                        .add(HomePageModifiedButtonPressedEvent());*/
                    Navigator.of(context).pop();
                    _homePageBloc.add(HomePageModifiedButtonPressedEvent());
                    /*BlocProvider.of<HomePageBloc>(context)
                        .add(HomePageModifiedButtonPressedEvent());*/
                  },
                ),
                Divider(
                  thickness: 1,
                  color: Colors.blueGrey,
                ),
                ListTile(
                  title: Text("Move to Another Page"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    //close the drawer
                    Navigator.of(context).pop();
                    //move to next page
                    final AuthenticationBloc authBloc =
                        BlocProvider.of<AuthenticationBloc>(context);
                    Navigator.pushNamed(context, RouteName.anotherpage,
                        arguments: {
                          "name": "this is from Home page",
                          "authBloc": authBloc
                        });
                  },
                ),
                Divider(
                  thickness: 1,
                  color: Colors.blueGrey,
                ),
                ListTile(
                  title: Text("Move to Google Maps"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    //close the drawer
                    Navigator.of(context).pop();
                    //move to next page
                    final AuthenticationBloc authBloc =
                        BlocProvider.of<AuthenticationBloc>(context);
                    Navigator.pushNamed(context, RouteName.placeTrackerHomePage,
                        arguments: {
                          "name": "this is from Home page",
                          "authBloc": authBloc
                        });
                  },
                ),
                ListTile(
                  title: Text("Move to LeafLet Map"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, RouteName.leafletMapHomePage);
                  },
                ),

                ListTile(
                  title: Text("Moving Car"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, RouteName.movingCarPage);
                  },
                ),
                ListTile(
                  title: Text("Learning Streams"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, RouteName.learningStreams);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: BlocBuilder<UserLableBloc, UserLableState>(
                cubit: userLableBloc,
                builder: (context, state) {
                  if (state is UserLableStateInitial) {
                    userLableBloc.add(UserLableAutheticatedEvent());
                  }
                  if (state is UserLableStateAutheticated) {
                    return Text(state.userName);
                  } else {
                    return Text("");
                  }
                }),
          ),
          body: BlocConsumer<HomePageBloc, HomePageState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is HomePageDefaultState) {
                return DefaultHomePage();
              }

              if (state is HomePageModifiedButtonState) {
                return createModifiedWidget();
              }

              return Container(
                child: Center(
                  child: Text("No State was invoked"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget createModifiedWidget() {
    return Container(
      color: Colors.cyan,
      child: Center(
        child: Text(
          "Modified Page",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Widget createNavDrawerHeader(Widget accountName, Widget accountEmail) {
    return UserAccountsDrawerHeader(
      accountName: accountName,
      accountEmail: accountEmail,
      decoration: BoxDecoration(color: Colors.green),
    );
  }
}
