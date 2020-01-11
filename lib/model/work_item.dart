import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class WorkItem {
  int workItemId;
  DateTime createdTime;
  DateTime updatedTime;
  DateTime startTime;
  DateTime endTime;
  int projectId;
  //Project project;
  String summary;
  String details;

  static String tableName = 'WorkItem';

  Duration get duration{
    if(startTime != null && endTime != null){
      return endTime.difference(startTime);
    }
    else{
      return Duration();
    }
  }

  WorkItem({
    this.workItemId,
    this.createdTime,
    this.updatedTime,
    this.startTime,
    this.endTime,
    this.projectId,
    this.summary,
    this.details,
  });

  WorkItem.newWorkItem({@required this.projectId}){
    DateTime now = DateTime.now();
    this.createdTime = now;
    this.startTime = now;
    this.endTime = now;
  }

  WorkItem.create({@required this.workItemId, @required this.startTime, @required this.projectId, @required this.summary,
    @required this.details, @required this.endTime}) {
    this.createdTime = DateTime.now();
    this.updatedTime = this.createdTime;
  }

  WorkItem._({@required this.workItemId, @required this.startTime, @required this.projectId, @required this.summary,
    @required this.details, this.createdTime, this.updatedTime, this.endTime});

  /*factory WorkItem(int workItemID, int projectID, String summary, String details){
    DateTime createdTime = DateTime.now();
    return WorkItem._(workItemId: 1, startTime: createdTime, projectId: 1, summary: summary, details: summary, createdTime: createdTime,
      updatedTime: createdTime, endTime: createdTime);
  }*/

  WorkItem.fromWorkItem(WorkItem workItem) :
      this.workItemId = workItem.workItemId,
      this.createdTime = workItem.createdTime,
      this.updatedTime = workItem.updatedTime,
      this.startTime = workItem.startTime,
      this.endTime = workItem.endTime,
      this.projectId = workItem.projectId,
      this.summary = workItem.summary,
      this.details = workItem.details;

  /*@override
  Future<bool> save() async {
    switch(SaveMode.state){
      case SaveModeState.internal:
        return DataSamples.addWorkItem(this);
      case SaveModeState.sqlLite:
        int result = await sqlLiteInsert();
        return sqlLiteResultToBool(result: result);
      case SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<T> read<T>() {
    switch
    }

  @override
  Future<bool> update() async {
    switch(SaveMode.state){
      case SaveModeState.internal:
        return DataSamples.updateWorkItem(this);
      case SaveModeState.sqlLite:
        int result = await sqlLiteUpdate();
        return sqlLiteResultToBool(result: result);
      case SaveModeState.firebase:
        return null;
      default:
        return null;
    }
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> sqlLiteInsert() {
    return LiteDBProvider.liteDB.sqlLiteBaseInsert(WorkItem, toJson());
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelect(fromJson, WorkItem, "workItemId = ?", [workItemId]);
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelectAll(fromJson, WorkItem);
  }

  @override
  Future<int> sqlLiteUpdate() {
    return LiteDBProvider.liteDB.sqlLiteBaseUpdate(WorkItem, toJson(), workItemId, "workItemId");
  }

  @override
  Future<int> sqlLiteDelete() {
    return LiteDBProvider.liteDB.sqlLiteBaseDelete(WorkItem, workItemId, "workItemId");
  }*/
}