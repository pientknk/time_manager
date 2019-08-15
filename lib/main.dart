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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Time Manager'),
          backgroundColor: Colors.black,
        ),
        body: TabBarWidget(),

        floatingActionButton: FloatingActionButtonWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      )
    );
  }
}

class WorkItem {
  DateTime StartDate;
  DateTime EndDate;
  int ProjectID;
  int WorkItemID;
  String Summary;
  String Details;


  WorkItem(DateTime startDate, DateTime endDate, int projectID, int workItemID, String summary, String details) {
    this.StartDate = startDate;
    this.EndDate = endDate;
    this.ProjectID = projectID;
    this.WorkItemID = workItemID;
    this.Summary = summary;
    this.Details = details;
  }
}

class HistoryTabPage extends StatefulWidget {
  @override
  _HistoryTabPageState createState() => _HistoryTabPageState();
}

class _HistoryTabPageState extends State<HistoryTabPage> {
  final _workItems = <WorkItem>[
    new WorkItem(DateTime.now(), DateTime.now(), 1, 1, 'testing', 'testing a work item'),
    new WorkItem(DateTime.now(), DateTime.now(), 2, 2, 'testing2', 'testing a work item 2'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return _buildHistoryList();
  }

  Widget _buildHistoryList(){
    return
      ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i){
        if(i <= _workItems.length){
          if(i.isOdd){
            return Divider();
          }

          final index = i ~/ 2; //divides i by 2 and returns an integer result

          return _buildTile(_workItems[index]);
        }
        else{
          return null;
        }
      },
    );
  }

  Widget _buildTile(WorkItem workItem){
    return ListTile(
      title: Text('${workItem.StartDate} - ${workItem.EndDate} (${workItem.ProjectID}, ${workItem.WorkItemID})'),
      subtitle: Text('${workItem.Summary} \n${workItem.Details}'),
      isThreeLine: true,
      onTap: _openWorkItemDetails,
      trailing: Icon(Icons.edit),
    );
  }

  void _openWorkItemDetails(){
    print('this will eventually push the details view');
  }
}

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
            return HistoryTabPage();
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
