
import 'package:flutter/material.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:time_manager/common/data_access_layer/data_samples.dart';
import 'package:time_manager/common/data_access_layer/lite_database.dart';
import 'package:time_manager/common/data_utils.dart';
import 'package:time_manager/model/common/abstracts.dart';
import 'package:time_manager/model/data.dart' as modelData;
import 'package:time_manager/model/model.dart';

class Helpers {
  const Helpers();
  static WorkItemHelper workItemHelper = WorkItemHelper();
  static ProjectHelper projectHelper = ProjectHelper();
}

class WorkItemHelper implements DataHelper<WorkItem> {
  static Duration duration(WorkItem workItem){
    if(workItem.startTime != null && workItem.endTime != null){
      return workItem.endTime.difference(workItem.startTime);
    }
    else{
      print("Error calculating duration from workItem");
      return Duration();
    }
  }

  @override
  Future<bool> create(WorkItem workItem) async {
    switch (modelData.SaveMode.state){
      case modelData.SaveModeState.sqlLite:
        //DataSamples.addWorkItem(workItem);
        int result = await sqlLiteInsert(workItem);
        return intResultToBool(result);
      case modelData.SaveModeState.sqfEntity:
        //make sure id of this work item is null so that it inserts a new record
        int result = await workItem.saveAs();
        return intResultToBool(result);
      case modelData.SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<WorkItem> read(int id) async {
    switch (modelData.SaveMode.state){
      case modelData.SaveModeState.sqlLite:
        return await sqlLiteSelect(id);
      case modelData.SaveModeState.sqfEntity:
        return await WorkItem().getById(id);
      case modelData.SaveModeState.firebase:
        return null;
      default:
        return null;
    }
  }

  @override
  Future<bool> update(WorkItem workItem) async {
    switch (modelData.SaveMode.state){
      case modelData.SaveModeState.sqlLite:
      //DataSamples.addWorkItem(workItem);
        int result = await sqlLiteInsert(workItem);
        return intResultToBool(result);
      case modelData.SaveModeState.sqfEntity:
        int result = await workItem.save();
        return intResultToBool(result);
      case modelData.SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<bool> delete(WorkItem workItem) async {
    switch (modelData.SaveMode.state){
      case modelData.SaveModeState.sqlLite:
      //DataSamples.addWorkItem(workItem);
        int result = await sqlLiteDelete(workItem.id);
        return intResultToBool(result);
      case modelData.SaveModeState.sqfEntity:
        BoolResult result = await workItem.delete();
        return result.success;
      case modelData.SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<int> sqlLiteInsert(WorkItem workItem) {
    return LiteDBProvider.liteDB.sqlLiteBaseInsert(WorkItem, workItem.toMap());
  }

  @override
  Future<WorkItem> sqlLiteSelect(int id) async {
    Map<String, dynamic> result = await LiteDBProvider.liteDB.sqlLiteBaseSelect2(WorkItem, "workItemId = ?", [id]);
    if(result != null){
      return WorkItem.fromMap(result);
    }

    return null;
  }

  @override
  Future<int> sqlLiteUpdate(WorkItem workItem) {
    return LiteDBProvider.liteDB.sqlLiteBaseUpdate(WorkItem, workItem.toMap());
  }

  @override
  Future<int> sqlLiteDelete(int id) {
    return LiteDBProvider.liteDB.sqlLiteBaseDelete(WorkItem, id);
  }

  @override
  Future<List<WorkItem>> sqlLiteSelectAll() async {
    List<Map<String, dynamic>> results = await LiteDBProvider.liteDB.sqlLiteBaseSelectAll2(WorkItem);
    if(results != []){
      return results.map((t) => WorkItem.fromMap(t)).toList();
    }

    return null;
  }

  @override
  WorkItem createNew() {
    return WorkItem();
  }
}

class ProjectHelper implements DataHelper<Project> {
  static Duration totalHours(Project project){
    Duration totalHours = Duration();
    Future<List<WorkItem>> workItemsF = project.getWorkItems(columnsToSelect: ['startTime', 'endTime']).toList();
    workItemsF.then((workItems){
      for(WorkItem workItem in workItems){
        Duration duration = Helpers.workItemHelper.duration(workItem);
        totalHours += duration;
      }
    });

    return totalHours;
  }

  static int workItemCount(Project project){
    int count = 0;
    Future<List<WorkItem>> workItemsF = project.getWorkItems(columnsToSelect: ['id']).toList();
    workItemsF.then((workItems){
      count = workItems.length;
    });
    return count;
  }

  static TextEditingController getApplicationController(Project project){
    TextEditingController controller = TextEditingController();
    project.getApplication().then((app){
      controller.text = app.name;
    });

    return controller;
  }

  static TextEditingController getPriorityController(Project project){
    return TextEditingController(
      text: ensureValue(
        value: project.priority?.toString(), defaultValue: "0")
    );
  }

  static TextEditingController getStatusController(Project project){
    TextEditingController controller = TextEditingController();
    project.getStatusType().then((st){
      controller.text = st.name;
    });

    return controller;
  }

  static TextEditingController getNameController(Project project){
    return TextEditingController(
      text: ensureValue(
        value: project.name)
    );
  }

  static TextEditingController getDetailsController(Project project){
    return TextEditingController(
      text: ensureValue(
        value: project.description)
    );
  }

  static TextEditingController getStartedTimeController(Project project){
    return TextEditingController(
      text: ensureValue(
        value: detailedDateFormatWithSeconds(project.startedTime))
    );
  }

  static TextEditingController getCompletedTimeController(Project project){
    return TextEditingController(
      text: ensureValue(
        value: detailedDateFormatWithSeconds(project.completedTime))
    );
  }

  @override
  Future<bool> create(Project data) async {
    switch (modelData.SaveMode.state){
      case modelData.SaveModeState.sqlLite:
        int result = await sqlLiteInsert(data);
        return intResultToBool(result);
      case modelData.SaveModeState.sqfEntity:
        int result = await data.saveAs();
        return intResultToBool(result);
      case modelData.SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<Project> read(int id) async {
    switch (modelData.SaveMode.state){
      case modelData.SaveModeState.sqlLite:
        return await sqlLiteSelect(id);
      case modelData.SaveModeState.sqfEntity:
        return await Project().getById(id);
      case modelData.SaveModeState.firebase:
        return null;
      default:
        return null;
    }
  }

  @override
  Future<bool> update(Project data) async {
    switch (modelData.SaveMode.state){
      case modelData.SaveModeState.sqlLite:
        int result = await sqlLiteUpdate(data);
        return intResultToBool(result);
      case modelData.SaveModeState.sqfEntity:
        int result = await data.save();
        return intResultToBool(result);
      case modelData.SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<bool> delete(Project data) async {
    switch (modelData.SaveMode.state){
      case modelData.SaveModeState.sqlLite:
        int result = await sqlLiteDelete(data.id);
        return intResultToBool(result);
      case modelData.SaveModeState.sqfEntity:
        BoolResult result = await data.delete(true);
        return result.success;
      case modelData.SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<int> sqlLiteInsert(Project data) {
    return LiteDBProvider.liteDB.sqlLiteBaseInsert(Project, data.toMap());
  }

  @override
  Future<Project> sqlLiteSelect(int id) async {
    Map<String, dynamic> result = await LiteDBProvider.liteDB.sqlLiteBaseSelect2(Project, "projectId = ?", [id]);
    if(result != null){
      return Project.fromMap(result);
    }

    return null;
  }

  @override
  Future<int> sqlLiteUpdate(Project data) {
    return LiteDBProvider.liteDB.sqlLiteBaseUpdate(Project, data.toMap());
  }

  @override
  Future<int> sqlLiteDelete(int id) {
    return LiteDBProvider.liteDB.sqlLiteBaseDelete(Project, id);
  }

  @override
  Future<List<Project>> sqlLiteSelectAll() async {
    List<Map<String, dynamic>> results = await LiteDBProvider.liteDB.sqlLiteBaseSelectAll2(Project);
    if(results != []){
      return results.map((t) => Project.fromMap(t)).toList();
    }

    return null;
  }

  @override
  Project createNew() {
    return Project();
  }
}