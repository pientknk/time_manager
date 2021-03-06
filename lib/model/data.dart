import 'package:time_manager/model/common/abstracts.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:time_manager/common/data_access_layer/lite_database.dart';
import 'package:time_manager/common/data_access_layer/data_samples.dart';
import 'package:time_manager/common/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'model.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

//run command 'flutter packages pub run build_runner build' to rebuild this file

enum SaveModeState {
  sqlLite,
  sqfEntity,
  firebase,
}

class SaveMode {
  const SaveMode();

  static SaveModeState state;
}

WorkItem workItemFromJson(String str) => WorkItem.fromJson(json.decode(str));
String workItemToJson(WorkItem data) => json.encode(data.toJson());

@JsonSerializable(nullable: false)
class WorkItem implements Data{
  int workItemId;
  DateTime createdTime;
  DateTime updatedTime;
  DateTime startTime;
  DateTime endTime;
  int projectId;
  String summary;
  String details;

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

  static WorkItem fromJson(Map<String, dynamic> json) => WorkItem(
    workItemId: json["workItemId"],
    createdTime: json["createdTime"],
    updatedTime: json["updatedTime"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    projectId: json["projectId"],
    summary: json["summary"],
    details: json["details"],
  );

  Map<String, dynamic> toJson() => {
    "workItemId": workItemId,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "startTime": startTime,
    "endTime": endTime,
    "projectId": projectId,
    "summary": summary,
    "details": details,
  };

  @override
  Future<bool> save<T>() async {
    return false;
  }

  @override
  T read<T>() {
    return null;
  }

  @override
  bool update(){
    return false;
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
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseUpdate(WorkItem, toJson(), workItemId, "workItemId");
  }

  @override
  Future<int> sqlLiteDelete() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseDelete(WorkItem, workItemId, "workItemId");
  }
}

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));
String categoryToJson(Category data) => json.encode(data.toJson());

class Category implements Data, Options {
  int categoryId;
  DateTime createdTime;
  DateTime updatedTime;
  @override
  String name;
  @override
  String description;

  Category({
    @required this.categoryId,
    @required this.name,
    @required this.description,
    this.createdTime,
    this.updatedTime,
  });

  @override
  Future<Iterable<String>> options() async {
    List<String> options = List<String>();
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        // TODO: Handle this case.
        break;
      case SaveModeState.sqfEntity:
        // TODO: Handle this case.
        break;
      case SaveModeState.firebase:
        // TODO: Handle this case.
        break;
      default:
        break;
    }

    return options;
  }

  static Category fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["categoryId"],
    createdTime: json["createdTime"],
    updatedTime: json["updatedTime"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "name": name,
    "description": description,
  };

  @override
  Future<bool> save<T>() async {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return false;
      case SaveModeState.sqfEntity:
        return false;
      case SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  T read<T>() {
    // TODO: implement read
    return null;
  }

  @override
  bool update() {
    // TODO: implement update
    return null;
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> sqlLiteInsert() {
    return LiteDBProvider.liteDB.sqlLiteBaseInsert(Category, toJson());
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelect(fromJson, Category, "categoryId = ?", [categoryId]);
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelectAll(fromJson, Category);
  }

  @override
  Future<int> sqlLiteUpdate() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseUpdate(Category, toJson(), categoryId, "categoryId");
  }

  @override
  Future<int> sqlLiteDelete() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseDelete(Category, categoryId, "categoryId");
  }
}

Project projectFromJson(String str) => Project.fromJson(json.decode(str));
String projectToJson(Project data) => json.encode(data.toJson());

class Project implements Data, Options {
  int projectId;
  DateTime createdTime;
  DateTime updatedTime;
  int applicationId;
  @override
  String name;
  @override
  String description;
  int priority;
  int statusTypeId;
  DateTime startedTime;
  DateTime completedTime;
  Duration totalHours;
  int workItemCount;
  int categoryId;
  int projectTypeId;
  List<String> comments; //??

  Project({
    this.projectId,
    this.applicationId,
    this.name,
    this.description,
    this.priority,
    this.statusTypeId,
    this.startedTime,
    this.completedTime,
    this.totalHours,
    this.workItemCount,
    this.categoryId,
    this.projectTypeId,
  });

  Project.newProject({@required this.applicationId}){
    DateTime createdTime = DateTime.now();
    this.startedTime = createdTime;
    this.completedTime = DateTime(2999);
    this.createdTime = createdTime;
    this.statusTypeId = 2;
    this.applicationId = applicationId;
    this.priority = 999;
  }

  Project._({@required this.projectId, @required this.applicationId, @required this.name, @required this.description, @required this.statusTypeId,
    this.createdTime, this.updatedTime, this.totalHours, this.workItemCount, this.startedTime, this.completedTime, this.priority, this.categoryId});

  /*factory Project(int projectId, int applicationId, String name, String details, {Duration totalHours = const Duration(hours: 11, minutes: 38),
    String status = StatusTypes.available, int workItems = 19, int priority = 999}){
    //TODO: retrieve info about application from the appID
    String appName = ApplicationNames.options[projectId];

    DateTime createdTime = DateTime.now();
    return Project._(projectId: projectId, applicationId: applicationId, createdTime: createdTime, updatedTime: createdTime,
      name: name, details: details, status: status, totalHours: totalHours, workItemCount: workItems, applicationName: appName, priority: priority
    );
  }*/

  @override
  Future<Iterable<String>> options() async {
    List<String> options = List<String>();
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        options = DataSamples.projects.map((project) => project.name);
        break;
      case SaveModeState.sqfEntity:
        List<Project> projects = await sqlLiteSelectAll();
        options = projects.map((project) => project.name);
        break;
      case SaveModeState.firebase:
        // TODO: Handle this case.
        break;
      default:
        break;
    }

    return options;
  }

  static Project fromJson(Map<String, dynamic> json) => Project(
    projectId: json["projectId"],
    applicationId: json["applicationId"],
    name: json["name"],
    description: json["details"],
    priority: json["priority"],
    statusTypeId: json["statusTypeId"],
    startedTime: json["startedTime"],
    completedTime: json["completedTime"],
    totalHours: json["totalHours"],
    workItemCount: json["workItemCount"],
    categoryId: json["categoryId"],
    projectTypeId: json["projectTypeId"],
  );

  void updateFromJson(Map<String, dynamic> json) => {
    this.projectId: json["projectId"],
    this.applicationId: json["applicationId"],
    this.name: json["name"],
    this.description: json["details"],
    this.priority: json["priority"],
    this.statusTypeId: json["statusTypeId"],
    this.startedTime: json["startedTime"],
    this.completedTime: json["completedTime"],
    this.totalHours: json["totalHours"],
    this.workItemCount: json["workItemCount"],
    this.categoryId: json["categoryId"],
    this.projectTypeId: json["projectTypeId"],
  };

  Map<String, dynamic> toJson() => {
    "projectId": projectId,
    "applicationId": applicationId,
    "name": name,
    "details": description,
    "priority": priority,
    "statusTypeId": statusTypeId,
    "startedTime": startedTime,
    "completedTime": completedTime,
    "totalHours": totalHours,
    "workItemCount": workItemCount,
    "categoryId": categoryId,
    "projectTypeId": projectTypeId,
  };

  @override
  Future<bool> save<T>() async {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return DataSamples.addProject(this);
      case SaveModeState.sqfEntity:
        int returnVal = await sqlLiteInsert();
        return returnVal == 1;
      case SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  T read<T>() {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return null;
      case SaveModeState.sqfEntity:
        return null;
      case SaveModeState.firebase:
        // TODO: Handle this case.
        return null;
      default:
        return null;
    }
  }

  @override
  bool update() {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return DataSamples.updateProject(this);
      case SaveModeState.sqfEntity:
        //int updateVal = await sqlLiteUpdate();
        //return updateVal == 1;
        return null;
      case SaveModeState.firebase:
        return null;
      default:
        return null;
    }
  }

  @override
  bool delete() {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return DataSamples.deleteProject(this.projectId);
      case SaveModeState.sqfEntity:
        //int deleteVal = await sqlLiteDelete();
        //return deleteVal == 1;
        return false;
      case SaveModeState.firebase:
        // TODO: Handle this case.
        break;
    }

    return false;
  }

  @override
  Future<int> sqlLiteInsert() {
    return LiteDBProvider.liteDB.sqlLiteBaseInsert(Project, toJson());
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelect<T>(fromJson, Project, "projectId = ?", [this.projectId]);
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelectAll<T>(fromJson, Project);
  }

  Future<List<Project>> sqlLiteSelectByStatusType(String statusType) async {
    return LiteDBProvider.liteDB.sqlLiteBaseSelect(fromJson, Project, "statusType = ?", [statusType]);
  }

  @override
  Future<int> sqlLiteUpdate() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseUpdate(Project, toJson(), projectId, "projectId");
  }

  @override
  Future<int> sqlLiteDelete() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseDelete<Project>(Project, projectId, "projectId");
  }
}

class StatusTypes {
  static Map<String, int> options = Map.fromIterable(DataSamples.statusTypes,
    key: (st) => st.name,
    value: (st) => st.statusTypeId);

  static List<Options> optionsForPage = DataSamples.statusTypes;
}

class ApplicationNames{
  static Map<String, int> options = Map.fromIterable(DataSamples.applications,
    key: (app) => app.name,
    value: (app) => app.applicationId);
}

class ProjectTypes {
  static Map<String, int> options = Map.fromIterable(DataSamples.projectTypes,
    key: (pt) => pt.name,
    value: (pt) => pt.projectTypeId);
}

StatusType statusTypeFromJson(String str) => StatusType.fromJson(json.decode(str));
String statusTypeToJson(StatusType data) => json.encode(data.toJson());

class StatusType implements Data, Options {
  int statusTypeId;
  DateTime createdTime;
  DateTime updatedTime;
  @override
  String name;
  @override
  String description;

  StatusType({
    this.statusTypeId,
    this.createdTime,
    this.updatedTime,
    this.name,
    this.description
  });

  static StatusType fromJson(Map<String, dynamic> json) => StatusType(
    statusTypeId: json["statusTypeId"],
    createdTime: json["createdTime"],
    updatedTime: json["updatedTime"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "statusTypeId": statusTypeId,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "name": name,
    "description": description,
  };

  @override
  Future<bool> save<T>() async {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return false;
      case SaveModeState.sqfEntity:
        return false;
      case SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  T read<T>() {
    // TODO: implement read
    return null;
  }

  @override
  bool update() {
    // TODO: implement update
    return null;
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> sqlLiteInsert() {
    // TODO: implement sqlLiteInsert
    return null;
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    // TODO: implement sqlLiteSelect
    return null;
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    // TODO: implement sqlLiteSelectAll
    return null;
  }

  @override
  Future<int> sqlLiteUpdate() {
    // TODO: implement sqlLiteUpdate
    return null;
  }

  @override
  Future<int> sqlLiteDelete() {
    // TODO: implement sqlLiteDelete
    return null;
  }

  @override
  Future<Iterable<String>> options() {
    // TODO: implement options
    return null;
  }
}

Filter filterFromJson(String str) => Filter.fromJson(json.decode(str));
String filterToJson(Filter data) => json.encode(data.toJson());

class Filter implements Data, Options {
  int filterId;
  DateTime createdTime;
  DateTime updatedTime;
  String filterXml; //might not need this if the various aspects of a filter can easily be defined in fields and won't change
  bool isDefault;
  bool isDescending;
  @override
  String name;
  @override
  String description;
  int statusTypeId;

  Filter({
    this.filterId,
    this.createdTime,
    this.updatedTime,
    this.filterXml,
    this.isDefault,
    this.isDescending,
    this.name,
    this.description,
    this.statusTypeId,
  });

  Filter._({@required this.filterId, @required this.isDefault, @required this.isDescending, @required this.name, this.description,
    this.createdTime, this.updatedTime, this.filterXml, this.statusTypeId});

  /*factory Filter(int filterID, String name, bool isDefault, bool isDescending, {status = StatusTypes.available}){
    DateTime createdTime = DateTime.now();
    return Filter._(filterId: filterID, isDefault: isDefault, isDescending: isDescending, name: name, createdTime: createdTime,
      updatedTime: createdTime, filterXml: 'no filter xml', status: status);
  }*/

  static Filter fromJson(Map<String, dynamic> json) => Filter(
    filterId: json["filterId"],
    createdTime: json["createdTime"],
    updatedTime: json["updatedTime"],
    filterXml: json["filterXML"],
    isDefault: json["isDefault"],
    isDescending: json["isDescending"],
    name: json["name"],
    description: json['description'],
    statusTypeId: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "filterId": filterId,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "filterXML": filterXml,
    "isDefault": isDefault,
    "isDescending": isDescending,
    "name": name,
    "statusTypeId": statusTypeId,
    "description": description,
  };

  Filter.fromFilter(Filter filter) :
    this.filterId = filter.filterId,
    this.createdTime = filter.createdTime,
    this.updatedTime = filter.updatedTime,
    this.filterXml = filter.filterXml,
    this.isDefault = filter.isDefault,
    this.isDescending = filter.isDescending,
    this.name = filter.name,
    this.description = filter.description,
    this.statusTypeId = filter.statusTypeId;

  @override
  Future<bool> save<T>() async {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return false;
      case SaveModeState.sqfEntity:
        return false;
      case SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  T read<T>() {
    // TODO: implement read
    return null;
  }

  @override
  bool update() {
    // TODO: implement update
    return null;
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> sqlLiteInsert() {
    return LiteDBProvider.liteDB.sqlLiteBaseInsert(Filter, toJson());
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelect(fromJson, Filter, "filterId = ?", [filterId]);
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelectAll(fromJson, Filter);
  }

  @override
  Future<int> sqlLiteUpdate() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseUpdate(Filter, toJson(), filterId, "filterId");
  }

  @override
  Future<int> sqlLiteDelete() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseDelete(Filter, filterId, "filterId");
  }

  @override
  Future<Iterable<String>> options() {
    // TODO: implement options
    return null;
  }
}

Application applicationFromJson(String str) => Application.fromJson(json.decode(str));
String applicationToJson(Application data) => json.encode(data.toJson());

class Application implements Data, Options{
  int applicationId;
  int systemId;
  DateTime createdTime;
  DateTime updatedTime;
  @override
  String name;
  @override
  String description;
  String version;
  DateTime workStartedDate;
  Duration totalHours;
  Duration totalWorkItems;

  Application({
    this.applicationId,
    this.systemId,
    this.createdTime,
    this.updatedTime,
    this.name,
    this.description,
    this.version,
    this.workStartedDate,
  });

  Application._({@required this.systemId, @required this.name, @required this.description, this.createdTime,
    this.updatedTime, this.version, this.workStartedDate, this.totalHours, this.totalWorkItems});

  /*factory Application(int systemId, String name, String description){
    String version = '0.1';
    DateTime createdTime = DateTime.now();
    return Application._(systemId: systemId, name: name, description: description, createdTime: createdTime, updatedTime: createdTime,
      version: version);
  }*/

  static Application fromJson(Map<String, dynamic> json) => Application(
    applicationId: json["applicationId"],
    systemId: json["systemId"],
    createdTime: json["createdTime"],
    updatedTime: json["updatedTime"],
    name: json["name"],
    description: json["description"],
    version: json["version"],
    workStartedDate: json["workStartedDate"],
  );

  Map<String, dynamic> toJson() => {
    "applicationId": applicationId,
    "systemId": systemId,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "name": name,
    "description": description,
    "version": version,
    "workStartedDate": workStartedDate,
  };

  @override
  Future<bool> save<T>() async {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return false;
      case SaveModeState.sqfEntity:
        return false;
      case SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  T read<T>() {
    // TODO: implement read
    return null;
  }

  @override
  bool update() {
    // TODO: implement update
    return null;
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> sqlLiteDelete() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseDelete(Application, applicationId, "applicationId");
  }

  @override
  Future<int> sqlLiteInsert() {
    return LiteDBProvider.liteDB.sqlLiteBaseInsert(Application, toJson());
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelect(fromJson, Application, "applicationId = ?", [applicationId]);
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelectAll(fromJson, Application);
  }

  @override
  Future<int> sqlLiteUpdate() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseUpdate(Application, toJson(), applicationId, "applicationId");
  }

  @override
  Future<Iterable<String>> options() {
    // TODO: implement options
    return null;
  }
}

System systemFromJson(String str) => System.fromJson(json.decode(str));
String systemToJson(System data) => json.encode(data.toJson());

class System implements Data, Options {
  int systemId;
  DateTime createdTime;
  DateTime updatedTime;
  @override
  String name;
  @override
  String description;

  System({
    this.systemId,
    this.createdTime,
    this.updatedTime,
    this.name,
    this.description,
  });

  static System fromJson(Map<String, dynamic> json) => System(
    systemId: json["systemId"],
    createdTime: json["createdTime"],
    updatedTime: json["updatedTime"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "systemId": systemId,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "name": name,
    "description": description,
  };

  @override
  Future<bool> save<T>() async {
    switch(SaveMode.state){
      case SaveModeState.sqlLite:
        return false;
      case SaveModeState.sqfEntity:
        return false;
      case SaveModeState.firebase:
        return false;
      default:
        return false;
    }
  }

  @override
  T read<T>() {
    // TODO: implement read
    return null;
  }

  @override
  bool update() {
    // TODO: implement update
    return null;
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> sqlLiteInsert() {
    // TODO: implement sqlLiteInsert
    return null;
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    // TODO: implement sqlLiteSelect
    return null;
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    // TODO: implement sqlLiteSelectAll
    return null;
  }

  @override
  Future<int> sqlLiteUpdate() {
    // TODO: implement sqlLiteUpdate
    return null;
  }

  @override
  Future<int> sqlLiteDelete() {
    // TODO: implement sqlLiteDelete
    return null;
  }

  @override
  Future<Iterable<String>> options() {
    // TODO: implement options
    return null;
  }
}

Settings settingsFromJson(String str) => Settings.fromJson(json.decode(str));
String settingsToJson(Settings data) => json.encode(data.toJson());

class Settings implements Data {
  int settingsId;
  DateTime createdTime;
  DateTime updatedTime;

  Settings({
    this.settingsId,
    this.createdTime,
    this.updatedTime,
  });

  static Settings fromJson(Map<String, dynamic> json) => Settings(
    settingsId: json["settingsId"],
    createdTime: json["createdTime"],
    updatedTime: json["updatedTime"],
  );

  Map<String, dynamic> toJson() => {
    "settingsId": settingsId,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
  };

  @override
  Future<bool> save<T>() async {
    // TODO: implement save
    return null;
  }

  @override
  T read<T>() {
    // TODO: implement read
    return null;
  }

  @override
  bool update() {
    // TODO: implement update
    return null;
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> sqlLiteDelete() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseDelete(Settings, settingsId, "settingsId");
  }

  @override
  Future<int> sqlLiteInsert() {
    return LiteDBProvider.liteDB.sqlLiteBaseInsert(Settings, toJson());
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelect(fromJson, Settings, "settingsId", [settingsId]);
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    return LiteDBProvider.liteDB.sqlLiteBaseSelectAll(fromJson, Settings);
  }

  @override
  Future<int> sqlLiteUpdate() {
    return null;
    //return LiteDBProvider.liteDB.sqlLiteBaseUpdate(Settings, toJson(), settingsId, "settingsId");
  }
}

class ProjectType implements Data, Options{
  int projectTypeId;
  DateTime createdTime;
  DateTime updatedTime;
  @override
  String name;
  @override
  String description;
  List<int> projectIds; //get projects that currently have this project type

  ProjectType({
    this.projectTypeId,
    this.createdTime,
    this.updatedTime,
    this.name,
    this.description,
  });

  @override
  Future<bool> save<T>() async {
    // TODO: implement save
    return null;
  }

  @override
  T read<T>() {
    // TODO: implement read
    return null;
  }

  @override
  bool update() {
    // TODO: implement update
    return null;
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> sqlLiteInsert() {
    // TODO: implement sqlLiteInsert
    return null;
  }

  @override
  Future<T> sqlLiteSelect<T>() {
    // TODO: implement sqlLiteSelect
    return null;
  }

  @override
  Future<List<T>> sqlLiteSelectAll<T>() {
    // TODO: implement sqlLiteSelectAll
    return null;
  }

  @override
  Future<int> sqlLiteUpdate() {
    // TODO: implement sqlLiteUpdate
    return null;
  }

  @override
  Future<int> sqlLiteDelete() {
    // TODO: implement sqlLiteDelete
    return null;
  }

  @override
  Future<Iterable<String>> options() {
    // TODO: implement options
    return null;
  }
}
