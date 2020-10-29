import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
