import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/common/catcher_factory.dart';
import 'package:time_manager/common/routing.dart';
import 'package:time_manager/common/user_prefs.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/view/main_page.dart';
import 'package:time_manager/common/data_access_layer/data_samples.dart';
import 'package:time_manager/common/debug.dart';
import 'package:flutter/services.dart';

import 'model/model.dart';

void main() async {
  //setup before running the app
  Routing.initRoutes();
  bool isDataSetup = DataSamples.initData();
  if(!isDataSetup){
    Debug.debugPrintMessage('Error setting up sample data');
  }

  //initialize the save mode for testing
  //TODO: Eventually make this a setting to update in the app during testing
  SaveMode.state = SaveModeState.sqlLite;
  print(SaveModeState.sqlLite.toString());

  UserPrefs.init();

  CatcherFactory.standardCatcher(MyApp());

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

    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Time Manager',
        theme: ThemeData(
          cursorColor: Colors.green,
          fontFamily: 'Livvic',
        ),
        ///can't have an InitialRoute and a home property
        home: MainPage(title: 'Time Manager')
      ),
    );
  }
}
