import 'package:flutter/material.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/app_scaffold.dart';

class ModalPopup{
  final BuildContext buildContext;
  final Widget contents;
  final String title;
  final BuildContext popupContext;

  ModalPopup({this.buildContext, this.popupContext, this.contents, this.title}) {
    ///TODO: try and use routing for navigation here
    //Routing.navigateTo(buildContext, route, transition: TransitionType.fadeIn);
    Navigator.push(
      buildContext,
      ConfirmationPopupLayout(
        top: 60,
        left: 40,
        right: 40,
        bottom: 60,
        child: _PopupContent(
          content: AppScaffold(
            appBarTitle: ThemeText.appBarText(title),
            appBarLeading: Builder(builder: (context) {
              return IconButton(
                color: Colors.white,
                icon: Icon(Icons.cancel),
                onPressed: () {
                  try {
                    Navigator.pop(context);
                  } catch (e) { print(e.toString()); }
                },
              );
            }),
            body: Container(
              color: ThemeColors.cardAccent,
              child: SizedBox.expand(
                child: contents,
              ),
            ),
          ),
        ),
      )
    );
  }
}

class ModalPopupDismissOption extends StatelessWidget{
  final AppScaffoldBottomAppBarTab appScaffoldBottomAppBarTab;
  final GestureTapCallback onTapFunc;
  final double height;
  final Color color;
  
  ModalPopupDismissOption({@required this.appScaffoldBottomAppBarTab, @required this.onTapFunc, this.height = 60, this.color = ThemeColors.appMain});
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashColor: ThemeColors.highlightedData,
            onTap: onTapFunc,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(appScaffoldBottomAppBarTab.icon, color: color, size: 30),
                Text(appScaffoldBottomAppBarTab.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          )),
      ));
  }
}

class ModalPopupMenuOptions{
  static Widget modalPopupMenuOption<T>({T value, IconData iconData, String label}){
    return PopupMenuItem<T>(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Icon(iconData, color: Colors.white),
            flex: 1,
          ),
          Expanded(
            child: Text(label.toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            flex: 2,
          ),
        ],
      ),
    );
  }
}

class ShowPopup {
  BuildContext buildContext;
  Widget widget;
  String title;
  BuildContext popupContext;

  ShowPopup({this.buildContext, this.widget, this.title, this.popupContext}) {
    ///TODO: try and use routing for navigation here
    //Routing.navigateTo(buildContext, route, transition: TransitionType.fadeIn);
    Navigator.push(
      buildContext,
      ConfirmationPopupLayout(
        top: 60,
        left: 40,
        right: 40,
        bottom: 60,
        child: _PopupContent(
          content: AppScaffold(
            appBarTitle: ThemeText.appBarText('Delete Project?'),
            appBarLeading: Builder(builder: (context) {
              return IconButton(
                color: Colors.white,
                icon: Icon(Icons.cancel),
                onPressed: () {
                  try {
                    Navigator.pop(context);
                  } catch (e) { print(e.toString()); }
                },
              );
            }),
            body: Container(
              color: ThemeColors.cardAccent,
              child: SizedBox.expand(
                child: widget,
              ),
            ),
          ),
        ),
      )
    );
  }
}

class ConfirmationPopupLayout extends ModalRoute<bool> {
  ConfirmationPopupLayout({@required this.child, this.bgColor, this.top = 10, this.right = 10, this.bottom = 10, this.left = 10});

  final Widget child;
  Color bgColor;
  double top;
  double right;
  double bottom;
  double left;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return GestureDetector(
      onTap: (){
        //SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: SizedBox(
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            bottom: true,
            child: _buildOverlayContent(context),
          ),
        ),
      )
    );
  }

  Widget _buildOverlayContent(BuildContext context){
    return Container(
      margin: EdgeInsets.only(left: this.left, top: this.top, right: this.right, bottom: this.bottom),
      child: child,
    );
  }
}

class _PopupContent extends StatefulWidget {
  final Widget content;

  _PopupContent({
    Key key,
    this.content
  }) : super(key: key);

  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<_PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: widget.content,
    );
  }
}

