import 'package:flutter/material.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/view/tab_pages.dart';
import 'package:time_manager/common/routing.dart';
import 'package:fluro/fluro.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
  with TickerProviderStateMixin {
  Widget _tabBodyWidget = CurrentProjectsTab();

  void _selectedTab(int index) {
    setState(() {
      _setTabBody(index);
    });
  }

  void _setTabBody(int index) {
    switch (index) {
      case 0:
        _tabBodyWidget = CurrentProjectsTab();
        break;
      case 1:
        _tabBodyWidget = AvailableProjectsTab();
        break;
      case 2:
        _tabBodyWidget = CompletedProjectsTab();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Time Manager'),
      appBarActions: <Widget>[
        IconButton(
          padding: const EdgeInsets.all(5),
          icon: Icon(Icons.settings),
          iconSize: 30,
          onPressed: () {
            Routing.navigateTo(context, Routing.settingsRoute, transition: TransitionType.inFromRight);
          },
          splashColor: ThemeColors.highlightedData,
          color: Colors.white,
        ),
      ],
      body: _tabBodyWidget,
      floatingActionButton: AppScaffoldFAB(
        route: "${Routing.projectAddRoute}/1",
        tooltip: 'Add a Project',
      ),
      bottomNavigationBar: AppScaffoldBottomAppBar(
        color: ThemeColors.unselectedButtonColor,
        selectedColor: ThemeColors.highlightedData,
        onTabSelected: _selectedTab,
        items: [
          AppScaffoldBottomAppBarTab(icon: Icons.timelapse, text: 'ASSIGNED'),
          AppScaffoldBottomAppBarTab(icon: Icons.event_available, text: 'AVAILABLE'),
          AppScaffoldBottomAppBarTab(icon: Icons.history, text: 'COMPLETED'),
        ],
        //Tabs
        backgroundColor: ThemeColors.appMain,
      ),
    );
  }
}