import 'package:flutter/material.dart';
import 'package:flutter_app_to_render/common_bloc/streamlearning_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StreamLearning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StreamlearningBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Stream Learning"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 100,
              ),
              _ShowNumber(),
              _ShowButtonBar()
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowNumber extends StatefulWidget {
  @override
  __ShowNumberState createState() => __ShowNumberState();
}

class __ShowNumberState extends State<_ShowNumber> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamlearningBloc, StreamlearningState>(
        builder: (x, state) {
      return Container(
        alignment: Alignment.center,
        child: Center(
          child: Text(
            "${state.value}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}

class _ShowButtonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StreamlearningBloc _bloc =
        BlocProvider.of<StreamlearningBloc>(context);
    return Align(
      alignment: FractionalOffset(0.5, 1),
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () {
                  _bloc.add(StreamlearningStartEvent());
                },
                child: Text("Start"),
                color: Colors.deepOrange,
              ),
              FlatButton(
                  onPressed: () {
                    _bloc.add(StreamlearningPauseEvent());
                  },
                  child: Text(
                    "Pause",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.deepOrange),
              FlatButton(
                  onPressed: () {
                    _bloc.add(StreamlearningResumeEvent());
                  },
                  child: Text("Resume"),
                  color: Colors.deepOrange),
              FlatButton(
                  onPressed: () {
                    _bloc.add(StreamlearningCancelEvent());
                  },
                  child: Text("Cancel"),
                  color: Colors.deepOrange),
            ],
          ),
        ),
      ),
    );
  }
}
