import 'package:flutter/material.dart';
import 'package:time_manager/common/routing.dart';
import 'package:time_manager/view/main_page.dart';
import 'package:time_manager/model/data_samples.dart';
import 'package:time_manager/common/debug.dart';
import 'package:flutter/services.dart';

void main() {
  //setup before running the app
  Routing.initRoutes();
  bool isDataSetup = DataSamples.initData();
  if(!isDataSetup){
    Debug.debugPrintMessage('Error setting up sample data');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Time Manager',
      theme: ThemeData(
        cursorColor: Colors.green,
        fontFamily: 'Livvic',
      ),
      ///can't have an InitialRoute and a home property
      home: MainPage(title: 'Time Manager')
    );
  }
}
