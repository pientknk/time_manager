import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_manager/tab_pages.dart';

class FloatingActionButtonWidget extends StatefulWidget {
  //combine this with a bottom navigation bar is a bottomAppBar for a notch in the bottom bar
  final floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked;
  @override
  _FloatingActionButtonWidgetState createState() => _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState extends State<FloatingActionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => setState(() {
        //push add view
      }),
      tooltip: 'Add a new Work Item',
      child: Icon(Icons.add),
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
            return Container(
              child: HistoryTabPage(),
              color: Colors.grey[200],
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
