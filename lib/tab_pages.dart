import 'package:flutter/material.dart';
import 'package:time_manager/data.dart';
import 'package:time_manager/helpers.dart';
import 'dart:async';

class HistoryTabPage extends StatefulWidget {
  HistoryTabPage({Key key}) : super(key: key);

  @override
  _HistoryTabPageState createState() => _HistoryTabPageState();
}

class _HistoryTabPageState extends State<HistoryTabPage> {
  final _workItems = <WorkItem>[
    WorkItem(DateTime.now(), DateTime.now(), 1, 1, 'testing', 'testing a work item'),
    WorkItem(DateTime.now(), DateTime.now(), 2, 2, 'testing2', 'testing a work item 2'),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildHistoryList();
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
      title: Text('${shortDateFormat(workItem.startDate)} - ${shortDateFormat(workItem.endDate)} (${workItem.projectID}, ${workItem.workItemID})'),
      subtitle: Text('${workItem.summary} \n${workItem.details}'),
      isThreeLine: true,
      onTap: _openWorkItemDetails,
    );
  }

  void _openWorkItemDetails(){
    print('this will eventually push the details view');
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
