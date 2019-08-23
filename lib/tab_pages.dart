import 'package:flutter/material.dart';
import 'package:time_manager/data.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/widgets.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:time_manager/theme.dart';

class HistoryTabPage extends StatefulWidget {
  HistoryTabPage({
    Key key,
    this.containerColor,
    this.containerPadding}) : super(key: key);

  final Color containerColor;
  final EdgeInsetsGeometry containerPadding;

  @override
  _HistoryTabPageState createState() => _HistoryTabPageState();
}

class _HistoryTabPageState extends State<HistoryTabPage> {
  /*final _workItems = <WorkItem>[
    WorkItem(
      workItemID: 1,
      createdTime: DateTime.now(),
      updatedTime: DateTime.now(),
      projectID: 1,
      summary: 'Testing 1',
      details: 'This is a test',
      startTime: DateTime.now().subtract(Duration(hours: 1)),
      endTime: DateTime.now().subtract(Duration(minutes: 7))
    ),
    WorkItem(
        workItemID: 2,
        createdTime: DateTime.now(),
        updatedTime: DateTime.now(),
        projectID: 1,
        summary: 'Testing 2',
        details: 'This is another test because why not?',
        startTime: DateTime.now().subtract(Duration(hours: 2)),
        endTime: DateTime.now().subtract(Duration(minutes: 15))
    ),
  ];*/

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildHistoryList(),
      padding: widget.containerPadding,
      color: widget.containerColor,
    );
  }

  Widget _buildHistoryList(){
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i){
        return null;
        /*if(i <= _workItems.length){
          if(i.isOdd){
            return Divider();
          }

          final index = i ~/ 2; //divides i by 2 and returns an integer result

          return _buildTile(_workItems[index]);
        }
        else{
          return null;
        }*/
      },
    );
  }

  Widget _buildTile(WorkItem workItem){
    return ListTile(
      title: Text('${shortDateFormat(workItem.startTime)} - ${shortDateFormat(workItem.endTime)} (${workItem.projectID}, ${workItem.workItemID})'),
      subtitle: Text('${workItem.summary} \n${workItem.details}'),
      isThreeLine: true,
      onTap: _openWorkItemDetails,
    );
  }

  void _openWorkItemDetails(){
    print('this will eventually push the details view');
  }
}

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
  final _projectCards = <ProjectCard>[
    ProjectCard(),
    ProjectCard(),
    ProjectCard(),
    ProjectCard(),
    ProjectCard(),
    ProjectCard(),
    ProjectCard(),
    ProjectCard(),
  ];

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

    final _listViewOption = Column(
      children: <Widget>[
        Flexible(
            child: Container(
              color: Colors.black,
              child: ListView.builder(
                itemExtent: 160,
                itemCount: _projectCards.length,
                itemBuilder: (_, index) => CardRow(),
              ),
            )
        )
      ],
    );

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

class CardRow extends StatelessWidget{
  //final ProjectCard project;

  CardRow();

  Widget _buildHeader(String text){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: AutoSizeText(text,
            style: TextStyles.headerText,
            maxLines: 2,
            minFontSize: 18,
            textAlign: TextAlign.left,
            semanticsLabel: 'n/a',
            overflow: TextOverflow.ellipsis,
          ),
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
              child: AutoSizeText(label,
                style: TextStyles.labelText,
                maxLines: 2,
                minFontSize: 14,
                textAlign: TextAlign.center,
                semanticsLabel: 'n/a',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: AutoSizeText(dataText,
                style: TextStyles.highlightedDataText,
                maxLines: 2,
                minFontSize: 14,
                textAlign: TextAlign.center,
                semanticsLabel: 'n/a',
                overflow: TextOverflow.ellipsis,
              ),
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
          _buildLabelAndData('Hours', '10:39'),
          _buildLabelAndData('Items', '29'),
          _buildLabelAndData('Started', '10/25/2019'),
        ],
      )
    );
  }

  Widget _buildCardRowContents(){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: _buildHeader('wow this is a really long amount for a project wtf how?'),
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
                Icon(Icons.more_vert, color: Colors.white, size: 30,)
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainPart = Container(
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
        child: _buildCardRowContents()
      ),
    );

    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: FlatButton(
        onPressed: () => print('ya ya'),
        child: mainPart,
      ),
    );
  }
}
