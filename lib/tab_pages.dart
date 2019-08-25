import 'package:flutter/material.dart';
import 'package:time_manager/data.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/widgets.dart';
import 'dart:async';
import 'package:time_manager/theme.dart';

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
      color: Colors.black,
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
        color: Colors.black,
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
              color: Colors.black,
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

  Widget _buildCardRow(){
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
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Icon(Icons.more_vert, color: Colors.white, size: 26,)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCardContents(){
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
          child: _buildCardRow()
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
                    builder: (context) => ProjectDetail())),
        child: _buildCardContents(),
      ),
    );
  }
}
