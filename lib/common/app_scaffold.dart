import 'package:flutter/material.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/routing.dart';
import 'package:fluro/fluro.dart';

class AppScaffold extends StatelessWidget {
  AppScaffold(
    {@required this.appBarTitle,
      @required this.body,
      this.appBarActions,
      this.appBarLeading,
      this.floatingActionButton,
      this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
      this.bottomNavigationBar,
      this.persistentBottomSheet,
      this.resizeToAvoidBottomInset = false});

  final Widget appBarTitle;
  final List<Widget> appBarActions;
  final Widget appBarLeading;
  final Widget body;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Widget bottomNavigationBar;
  final Widget persistentBottomSheet;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        leading: appBarLeading,
        backgroundColor: ThemeColors.appMain,
        actions: appBarActions,
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: persistentBottomSheet,
    );
  }
}

class AppScaffoldBottomSheet extends StatelessWidget {
  final IconData iconData;
  final String iconText;
  final double height;
  final GestureTapCallback onTapFunc;

  AppScaffoldBottomSheet({@required this.iconData, @required this.iconText, this.height = 70, this.onTapFunc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: height,
            child: Container(
              padding: const EdgeInsets.all(5),
              color: ThemeColors.appMain,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTapFunc,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(iconData, color: ThemeColors.highlightedData, size: 40),
                      Text(iconText.toUpperCase(),
                        style: TextStyle(
                          color: ThemeColors.highlightedData,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ],
                  ),
                )
              ),
            )
          ),
        )
      ],
    );
  }
}

class AppScaffoldFAB extends StatefulWidget {
  AppScaffoldFAB({Key key, @required this.route, this.tooltip}) : super(key: key);

  final String route;
  final String tooltip;

  //combine this with a bottom navigation bar in a bottomAppBar for a notch in the bottom bar
  final floatingActionButtonLocation =
    FloatingActionButtonLocation.centerDocked;

  @override
  _AppScaffoldFABState createState() =>
    _AppScaffoldFABState();
}

class _AppScaffoldFABState
  extends State<AppScaffoldFAB> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => setState(() {
        Routing.navigateTo(context, widget.route, transition: TransitionType.inFromRight);
      }),
      tooltip: widget.tooltip,
      child: Icon(
        Icons.add,
        size: 27,
      ),
      backgroundColor: ThemeColors.highlightedData,
      foregroundColor: ThemeColors.unselectedButtonColor,
    );
  }
}

class AppScaffoldBottomAppBar extends StatefulWidget {
  AppScaffoldBottomAppBar(
    {this.items,
      this.height: 60.0,
      this.iconSize: 25.0,
      this.backgroundColor,
      this.color,
      this.selectedColor,
      this.notchedShape,
      this.onTabSelected}) {
    assert(this.items.length == 3); //want to enforce there to be 3 tabs
  }

  final List<AppScaffoldBottomAppBarTab> items;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  State<StatefulWidget> createState() => _AppScaffoldBottomAppBarState();
}

class _AppScaffoldBottomAppBarState extends State<AppScaffoldBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
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
      ));
  }

  Widget _buildTabItem(
    {AppScaffoldBottomAppBarTab item, int index, ValueChanged<int> onPressed}) {
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
          )),
      ));
  }
}

class AppScaffoldBottomAppBarTab{
  AppScaffoldBottomAppBarTab({this.text, this.icon});

  IconData icon;
  String text;
}