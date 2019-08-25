import 'package:flutter/material.dart';
import 'package:time_manager/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Manager',
      theme: ThemeData(
        cursorColor: Colors.green,
        fontFamily: 'Livvic',
      ),
      ///can't have an InitialRoute and a home property
      home: HomePageWidget(title: 'Time Manager')
    );
  }
}
