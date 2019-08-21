import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_manager/tab_pages.dart';
import 'package:time_manager/material_data.dart';
import 'package:time_manager/data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:time_manager/helpers.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> with TickerProviderStateMixin{
  Widget _tabBodyWidget = _getCurrentProjectsTab();

  void _selectedTab(int index) {
    setState(() {
      _setTabBody(index);
    });
  }

  void _setTabBody(int index){
    switch(index){
      case 0:
        _tabBodyWidget = _getCurrentProjectsTab();
        break;
      case 1:
        _tabBodyWidget = HistoryTabPage(
            containerColor: Colors.white,
            containerPadding: const EdgeInsets.all(10),
          );
        break;
      default:
        _tabBodyWidget = null;
        break;
    }
  }

  static Widget _getCurrentProjectsTab(){
//    return HomeTabPage(
//      containerColor: Colors.white,
//      containerPadding: const EdgeInsets.all(10),
//    );
    return CurrentProjectsTab();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            child: Icon(Icons.settings),
          )
        ],
      ),
      body: _tabBodyWidget,
      floatingActionButton: FloatingActionButtonWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBarWidget(
        color: Colors.grey[300],
        selectedColor: Colors.green[600],
        onTabSelected: _selectedTab,
        items: [
          BottomAppBarTab(icon: Icons.timelapse, text: 'CURRENT'),
          BottomAppBarTab(icon: Icons.event_available, text: 'AVAILABLE'),
          BottomAppBarTab(icon: Icons.history, text: 'COMPLETED'),
        ], //Tabs
        backgroundColor: Colors.black,
      ),
    );
  }
}

class FloatingActionButtonWidget extends StatefulWidget {
  FloatingActionButtonWidget({Key key}) : super(key: key);

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

class BottomAppBarWidget extends StatefulWidget {
  BottomAppBarWidget({
    this.items,
    this.height: 60.0,
    this.iconSize: 25.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected
  }) {
    assert(this.items.length == 3); //want to enforce there to be 3 tabs
  }

  final List<BottomAppBarTab> items;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  State<StatefulWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  int _selectedIndex = 0;

  _updateIndex(int index){
    widget.onTabSelected(index);
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index){
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    return BottomAppBar(
      shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      )
    );
  }

  Widget _buildTabItem({BottomAppBarTab item, int index, ValueChanged<int> onPressed}){
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          )
        ),
      )
    );
  }
}

class ProjectCard extends StatefulWidget {
  ProjectCard({
    Key key,
    //this.project,
    //this.color,
    //this.splashColor,
    //this.textColor = Colors.white,
    //this.margin,
    //this.text
  }) : super(key: key);

  //final Project project;
  //final Color color;
  //final Color splashColor;
  //final Color textColor;
  //final EdgeInsetsGeometry margin;
  //final String text;
  
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final _headerTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  Widget _buildHeaderText(String text){
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[900], width: 3)
        )
      ),
      child: Center(
        child: AutoSizeText(text,
          style: _headerTextStyle,
          maxLines: 2,
          minFontSize: 14,
          textAlign: TextAlign.center,
          semanticsLabel: 'n/a',
          overflow: TextOverflow.ellipsis,
        ),
      )
    );
  }

  final _infoTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: Colors.grey[100],
  );

  Widget _buildInfoText(String text){
    return Container(
      child: AutoSizeText(text,
        style: _infoTextStyle,
        minFontSize: 11,
        maxLines: 4,
        textAlign: TextAlign.center,
        semanticsLabel: 'n/a',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  final _labelTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  Widget _buildLabelText(String text){
    return Container(
      padding: const EdgeInsets.all(1),
      child: AutoSizeText(text.toUpperCase(),
        style: _labelTextStyle,
        minFontSize: 10,
        maxLines: 1,
        semanticsLabel: 'n/a',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  final _dataTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.green,
  );

  Widget _buildDataText(String text){
    return Container(
      padding: const EdgeInsets.all(1),
      child: AutoSizeText(text,
        style: _dataTextStyle,
        maxLines: 1,
        minFontSize: 11,
        semanticsLabel: 'n/a',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  //longest project name allowed: 50
  Widget _buildProjectName(){
    return Expanded(
      flex: 0,
      child: _buildHeaderText('wow this is a really long amount for a project wtf')
    );
  }

  //longest project description allowed: 120 chars
  Widget _buildProjectDescription(){
    return Expanded(
      flex: 0,
      child: _buildInfoText('well if this is not a project description then I don\'t know what is but it should contain some info that is useful ya ya')
    );
  }

  Widget _buildHoursAndWorkItemsColumn(){
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Expanded(
            child: _buildProjectColumn('Hours', '10:36'),
          ),
          Expanded(
            child: _buildProjectColumn('Items', '23'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectColumn(String label, String dataText){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flex(
          direction: Axis.vertical,
          children: <Widget>[
            _buildLabelText(label),
            _buildDataText(dataText)
          ],
        )
      ],
    );
  }

  Widget _buildProjectRow(String label, String dataText){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            _buildLabelText('$label:'),
            _buildDataText(dataText),
          ],
        )
      ],
    );
  }

  Widget _buildCard(){
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildProjectName(),
                _buildProjectDescription(),
                _buildHoursAndWorkItemsColumn(),
                _buildProjectRow('Started', veryShortDateFormat(DateTime(2019, 10, 23))),
                _buildProjectRow('Finished', veryShortDateFormat(DateTime(2019, 10, 27))),
              ],
            ),
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          child: _buildCard(),
          //splashColor: widget.splashColor,
        ),
      ),
      color: Colors.grey[850],
      margin: const EdgeInsets.all(2.5),
      elevation: 5.0,
    );
  }
}
