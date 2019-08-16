import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_manager/tab_pages.dart';
import 'package:time_manager/data.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> with TickerProviderStateMixin{
  Widget _tabBodyWidget = _homeTabWidget;

  void _selectedTab(int index) {
    setState(() {
      _setTabBody(index);
    });
  }

  void _setTabBody(int index){
    switch(index){
      case 0:
        _tabBodyWidget = _homeTabWidget;
        break;
      case 1:
        _tabBodyWidget = Container(
          child: HistoryTabPage(),
          color: Colors.white,
        );
        break;
      default:
        _tabBodyWidget = null;
        break;
    }
  }

  static Widget _homeTabWidget = Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Center(
        child: TextFormField(
          decoration: InputDecoration(
              labelText: "Input Label",
              icon: Icon(Icons.input),
              fillColor: Colors.white,
              border: new OutlineInputBorder()
          ),
          validator: (val){
            if(val.length == 0){
              return "Error";
            }else{
              return null;
            }
          },
        ),
      )
  );

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBarWidget(
        color: Colors.grey[300],
        selectedColor: Colors.green[600],
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          BottomAppBarTab(icon: Icons.home, text: 'HOME'),
          BottomAppBarTab(icon: Icons.history, text: 'HISTORY'),
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
    assert(this.items.length == 2); //want to enforce there to be 2 tabs
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
            )
          )
        ),
      )
    );
  }
}
