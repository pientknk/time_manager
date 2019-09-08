import 'package:flutter/material.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/model/data_samples.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/routing.dart';
import 'package:fluro/fluro.dart';
import 'package:time_manager/common/data_utils.dart';
import 'package:time_manager/common/app_scaffold.dart';

class CurrentProjectsTab extends StatefulWidget {
  CurrentProjectsTab({
    Key key
  }) : super(key: key);

  _CurrentProjectsTabState createState() => _CurrentProjectsTabState();
}

class _CurrentProjectsTabState extends State<CurrentProjectsTab> {
  static final _projects = DataSamples.projects;
  static final _filters = DataSamples.getFilters().toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return TabWidgets.buildProjectListView(_projects, _filters[0]);
  }
}

class AvailableProjectsTab extends StatefulWidget {
  AvailableProjectsTab({Key key}) : super(key: key);

  _AvailableProjectsTabState createState() => _AvailableProjectsTabState();
}

class _AvailableProjectsTabState extends State<AvailableProjectsTab> {
  static final _projects = DataSamples.projects;
  static final _filters = DataSamples.getFilters().toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return TabWidgets.buildProjectListView(_projects, _filters[1]);
  }
}

class CompletedProjectsTab extends StatefulWidget {
  CompletedProjectsTab({Key key}) : super(key: key);
  
  _CompletedProjectsTabState createState() => _CompletedProjectsTabState();
}

class _CompletedProjectsTabState extends State<CompletedProjectsTab> {
  static final _projects = DataSamples.projects;
  static final _filters = DataSamples.getFilters().toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return TabWidgets.buildProjectListView(_projects, _filters[2]);
  }
}

class TabWidgets{
  const TabWidgets();

  static Widget buildProjectListView(List<Project> projects, Filter filter){
    projects.sort((pr1, pr2) =>
      filter.isDescending
          ? pr1.name.compareTo(pr2.name)
          : pr2.name.compareTo(pr1.name));

    final filteredProjects = projects.where((pr) => pr.status == filter.status).toList(growable: false);

    if(filteredProjects.isEmpty){
      return Container(
        color: ThemeColors.appMain,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ThemeText.headerText('No Records'),
            )
          ],
        ),
      );
    }else{
      return Column(
        children: <Widget>[
          Flexible(
            child: Container(
              color: ThemeColors.appMain,
              child: ListView.builder(
                itemExtent: 160,
                itemCount: filteredProjects.length,
                itemBuilder: (_, index) => CardRow(project: filteredProjects[index]),
              ),
            )
          )
        ],
      );
    }
  }
}

class CardRow extends StatelessWidget{
  final Project project;

  CardRow({Key key, this.project}) : super(key: key);

  Widget _buildHeader(String text){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ThemeText.headerText(text)
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
          height: 2,
          color: ThemeColors.lineSeparator,
        )
      ],
    );
  }

  Widget _buildLabelAndData(String label, String dataText){
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ThemeText.labelText(label)
            ),
            Expanded(
              flex: 1,
              child: ThemeText.highlightedText(dataText)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(){
    return Container(
      margin: const EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildLabelAndData('Hours', shortDurationFormat(project.totalHours)),
          _buildLabelAndData('Items', project.workItemCount.toString()),
          _buildLabelAndData('Started', veryShortDateFormat(project.startedTime ?? DateTime.now())),
        ],
      )
    );
  }

  Widget _buildPopupMenuItemContents(int value, IconData iconData, String label){
    return PopupMenuItem(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Icon(iconData, color: Colors.white,),
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

  Widget _buildProjectPopUpMenu(BuildContext context){
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: ThemeColors.card,
      ),
      child: PopupMenuButton<int>(
        elevation: 4,
        icon: Icon(Icons.more_vert, color: ThemeColors.mainText,),
        onSelected: (value) {
          switch(value){
            case 1:
              Routing.navigateTo(context, "${Routing.projectDetailRoute}/${project.projectID}", transition: TransitionType.fadeIn);
              break;
            case 2:
              Routing.navigateTo(context, "${Routing.projectEditRoute}/${project.projectID}", transition: TransitionType.fadeIn);
              break;
            case 3:
              ShowPopup(
                title: 'testing',
                buildContext: context,
                widget: Container(
                  child: Row(
                    children: <Widget>[
                      _buildRowButtonDismissPopup(
                        buttonContents: AppScaffoldBottomAppBarTab(text: 'Delete', icon: Icons.delete_forever),
                        onTapFunc: () {
                          print('deleting project at some point');
                          Navigator.pop(context);
                        }
                      ),
                      _buildRowButtonDismissPopup(
                        buttonContents: AppScaffoldBottomAppBarTab(text: 'Cancel', icon: Icons.cancel),
                        onTapFunc: () {
                          print('cancelling the delete');
                          Navigator.pop(context);
                        }
                      )
                    ],
                  ),
                )
              );
          }
        },
        itemBuilder: (context) => [
          _buildPopupMenuItemContents(1, Icons.details, 'details'),
          PopupMenuDivider(height: 3),
          _buildPopupMenuItemContents(2, Icons.edit, 'edit'),
          PopupMenuDivider(height: 3),
          _buildPopupMenuItemContents(3, Icons.delete_forever, 'delete'),
        ],
      ),
    );
  }

  Expanded _buildRowButtonDismissPopup(
    {double height = 60,
      Color color = ThemeColors.appMain,
      @required AppScaffoldBottomAppBarTab buttonContents,
      GestureTapCallback onTapFunc}) {
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
                Icon(buttonContents.icon, color: color, size: 30),
                Text(
                  buttonContents.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          )),
      ));
  }

  Widget _buildCardRow(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: _buildHeader(project.name),
              ),
              Expanded(
                flex: 3,
                child: _buildBody(),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 6),
            child: Column(
              children: <Widget>[
                _buildProjectPopUpMenu(context)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCardContents(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          constraints: BoxConstraints.expand(),
          child: _buildCardRow(context)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: FlatButton(
        onPressed: () {
          Routing.navigateTo(context, "${Routing.projectDetailRoute}/${project.projectID}", transition: TransitionType.fadeIn);
        },
        child: _buildCardContents(context),
      ),
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

class PopupContent extends StatefulWidget {
  final Widget content;

  PopupContent({
    Key key,
    this.content
  }) : super(key: key);

  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
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
        child: PopupContent(
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