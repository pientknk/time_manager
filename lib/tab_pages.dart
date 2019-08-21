import 'package:flutter/material.dart';
import 'package:time_manager/data.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/widgets.dart';
import 'dart:async';

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
  final _workItems = <WorkItem>[
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
  ];

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
          Padding(

          )
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
    return Container(
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
  }

  @override
  Widget build(BuildContext context) {
    return _buildProjectCards();
  }
}
