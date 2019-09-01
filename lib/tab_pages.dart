import 'package:flutter/material.dart';
import 'package:time_manager/data.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/widgets.dart';
import 'dart:async';
import 'package:time_manager/theme.dart';
import 'package:time_manager/material_data.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({
    Key key,
    this.containerColor,
    this.containerPadding
  }) : super(key: key);

  final Color containerColor;
  final EdgeInsetsGeometry containerPadding;

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.containerPadding,
      color: widget.containerColor,
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
  }
}

class WorkItemFormPage extends StatefulWidget {
  WorkItemFormPage({Key key}) : super(key: key);

  @override
  _WorkItemFormPageState createState() => _WorkItemFormPageState();
}

class _WorkItemFormPageState extends State<WorkItemFormPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
          ),
          TextFormField(

          ),
        ],
      )
    );
  }
}

class CurrentProjectsTab extends StatefulWidget {
  CurrentProjectsTab({
    Key key
  }) : super(key: key);

  _CurrentProjectsTabState createState() => _CurrentProjectsTabState();
}

class _CurrentProjectsTabState extends State<CurrentProjectsTab> {
  static Iterable<ProjectCard> _createProjectCards(Iterable<Project> projects) sync* {
    for(Project project in projects){
      yield ProjectCard(project: project);
    }
  }

  static final _projects = GetData.getProjects().toList(growable: false);
  static final _filters = GetData.getFilters().toList(growable: false);

  static final _projectCards = _createProjectCards(_projects).toList(growable: false);

  //eventually i will care that we are loading all cards right away, need to update to load a set number and then add more dynamically
  Widget _buildProjectCards() {
    final _gridViewOption = Container(
      color: ThemeColors.appMain,
      child: SafeArea(
        top: true,
        bottom: true,
        child: GridView.builder(
          itemCount: _projectCards.length,
          padding: const EdgeInsets.all(4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4
          ),
          itemBuilder: (BuildContext context, int index){
//        final i = index ~/ 2; //2 cards per row so don't load more unless we hit past this
//        if(i > _projectCards.length){
//          _projectCards.addAll()
//        }
            return new GestureDetector(
              child: _projectCards[index],
              onTap: () {
                print("I've been tapped");
              },
            );
          },
        ),
      ),
    );

    final _listViewOption = TabWidgets.buildProjectListView(_projects, _filters[0]);

    //TODO: update this to change the card theme for now, but this should be easier to do in the application at some point
    int index = 1;
    if(index == 0){
      return _gridViewOption;
    } else{
      return _listViewOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildProjectCards();
  }
}

class AvailableProjectsTab extends StatefulWidget {
  AvailableProjectsTab({Key key}) : super(key: key);

  _AvailableProjectsTabState createState() => _AvailableProjectsTabState();
}

class _AvailableProjectsTabState extends State<AvailableProjectsTab> {
  static final _projects = GetData.getProjects().toList(growable: false);
  static final _filters = GetData.getFilters().toList(growable: false);

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
  static final _projects = GetData.getProjects().toList(growable: false);
  static final _filters = GetData.getFilters().toList(growable: false);

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
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailScreen(project)));
              break;
            case 2:
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => ProjectEditScreen(project: project)));
              break;
            case 3:
              ShowPopup(
                title: 'testing',
                buildContext: context,
                widget: Container(
                  child: Row(
                    children: <Widget>[
                      _buildRowButtonDismissPopup(
                        context: context,
                        buttonContents: BottomAppBarTab(text: 'Delete', icon: Icons.delete_forever),
                      ),
                      _buildRowButtonDismissPopup(
                        context: context,
                        buttonContents: BottomAppBarTab(text: 'Cancel', icon: Icons.cancel),
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
    {@required BuildContext context,
      double height = 60,
      Color color = ThemeColors.appMain,
      @required BottomAppBarTab buttonContents}) {
    return Expanded(
      child: SizedBox(
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
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
                /*GestureDetector(
                  child: Icon(Icons.more_vert, color: Colors.white, size: 26),
                  onTap: () => _buildProjectPopUpMenu(context)
                      //Navigator.push(context,
                      //MaterialPageRoute(
                       //   builder: (context) => AppScaffold(appBarTitle: Text('hi'), body: Container(), ))),
                ),*/
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
        onPressed: () =>
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => ProjectDetailScreen(project))),
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
              child: widget,
            ),
          ),
        ),
      )
    );
  }
}