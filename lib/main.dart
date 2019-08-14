import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabBarWidget(),
    );
  }
}

class TabBarWidget extends StatefulWidget {
  ///constructor?
  //final String title;

  @override
  _TabBarWidget createState() => _TabBarWidget();
}

class _TabBarWidget extends State<TabBarWidget> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('HOME'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('HISTORY')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('SETTINGS')
          )
        ],
      ),
      tabBuilder: (BuildContext context, int index){
        switch(index) {
          case 0:
            return new Container(
              color: Colors.red,
            );
            break;
          case 1:
            return new Container(
              color: Colors.blue,
            );
            break;
          case 2:
            return new Container(
              color: Colors.green,
            );
            break;
        }

        return null;
      },
    );
    /*return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
              Tab(icon: Icon(Icons.directions_boat))
            ],
          ),
          title: Text('Time Manager'),
        ),
        body: TabBarView(
          children: <Widget>[
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
            Icon(Icons.directions_boat)
          ],
        )
      )
    );*/
  }
}
