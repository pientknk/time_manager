import 'package:time_manager/model/common/abstracts.dart';
import 'package:flutter/foundation.dart';

class WorkItem implements Data{
  int workItemID;
  DateTime createdTime;
  DateTime updatedTime;
  DateTime startTime;
  DateTime endTime;
  int projectID;
  String summary;
  String details;
  Duration duration;

  WorkItem.newWorkItem({@required this.projectID}){
    DateTime now = DateTime.now();
    this.createdTime = now;
    this.startTime = now;
    this.endTime = now;
  }

  WorkItem.create({@required this.workItemID, @required this.startTime, @required this.projectID, @required this.summary,
    @required this.details, this.endTime}) {
    this.createdTime = DateTime.now();
    this.updatedTime = this.createdTime;
    this.duration = this.endTime.difference(this.startTime);
  }

  WorkItem._({@required this.workItemID, @required this.startTime, @required this.projectID, @required this.summary,
    @required this.details, this.createdTime, this.updatedTime, this.endTime, this.duration});

  factory WorkItem(int workItemID, int projectID, String summary, String details){
    DateTime createdTime = DateTime.now();
    return WorkItem._(workItemID: 1, startTime: createdTime, projectID: 1, summary: summary, details: summary, createdTime: createdTime,
      updatedTime: createdTime, endTime: createdTime);
  }

  WorkItem.fromWorkItem(WorkItem workItem) :
    this.workItemID = workItem.workItemID,
    this.createdTime = workItem.createdTime,
    this.updatedTime = workItem.updatedTime,
    this.startTime = workItem.startTime,
    this.endTime = workItem.endTime,
    this.projectID = workItem.projectID,
    this.summary = workItem.summary,
    this.details = workItem.details,
    this.duration = workItem.duration;

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  bool save() {
    // TODO: implement save
    return null;
  }
}

class Project implements Data {
  int projectID;
  DateTime createdTime;
  DateTime updatedTime;
  int applicationID;
  String applicationName;
  String name;
  String details;
  int priority;
  String status;
  DateTime startedTime;
  DateTime completedTime;
  Duration totalHours;
  int workItemCount;

  Project.newProject({@required this.applicationID}){
    DateTime createdTime = DateTime.now();
    this.priority = 9999;
    this.createdTime = createdTime;
  }

  Project._({@required this.projectID, @required this.applicationID, @required this.name, @required this.details, @required this.status,
    this.createdTime, this.updatedTime, this.totalHours, this.workItemCount, this.startedTime, this.completedTime, this.applicationName, this.priority});

  factory Project(int projectID, int applicationId, String name, String details, {Duration totalHours = const Duration(hours: 11, minutes: 38),
    String status = StatusTypes.available, int workItems = 19, int priority = 999}){
    //TODO: retrieve info about application from the appID
    String appName = ApplicationNames.options[projectID];
    
    DateTime createdTime = DateTime.now();
    return Project._(projectID: projectID, applicationID: applicationId, createdTime: createdTime, updatedTime: createdTime,
      name: name, details: details, status: status, totalHours: totalHours, workItemCount: workItems, applicationName: appName, priority: priority
    );
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  bool save() {
    // TODO: implement save
    return null;
  }
}

class StatusTypes {
  static const String assigned = "Assigned";
  static const String available = "Available";
  static const String finished = "Finished";
  static const String voided = "Voided";
  static const options = ["Select an Option", assigned, available, finished, voided];
}

class ApplicationNames {
  static const String timeManager = "Time Manager";
  static const String jodeler = "Jodeler";
  static const String webScraper = "Web Scraper";
  static const String packageDrop = 'Package Drop';
  static const String liveItUp = "Live It Up";
  static const String dataStructures = "Data Structures";
  static const String workoutApp = "Workout App";
  static const options = ["Select an Option", timeManager, jodeler, webScraper, packageDrop, liveItUp, dataStructures, workoutApp];
}

class Filter implements Data {
  int filterID;
  DateTime createdTime;
  DateTime updatedTime;
  String filterXML; //might not need this if the various aspects of a filter can easily be defined in fields and won't change
  bool isDefault;
  bool isDescending;
  String name;
  String status;

  Filter._({@required this.filterID, @required this.isDefault, @required this.isDescending, @required this.name,
    this.createdTime, this.updatedTime, this.filterXML, this.status});

  factory Filter(int filterID, String name, bool isDefault, bool isDescending, {status = StatusTypes.available}){
    DateTime createdTime = DateTime.now();
    return Filter._(filterID: filterID, isDefault: isDefault, isDescending: isDescending, name: name, createdTime: createdTime,
      updatedTime: createdTime, filterXML: 'no filter xml', status: status);
  }

  Filter.fromFilter(Filter filter) :
    this.filterID = filter.filterID,
    this.createdTime = filter.createdTime,
    this.updatedTime = filter.updatedTime,
    this.filterXML = filter.filterXML,
    this.isDefault = filter.isDefault,
    this.isDescending = filter.isDescending,
    this.name = filter.name,
    this.status = filter.status;

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  bool save() {
    // TODO: implement save
    return null;
  }
}

class Application implements Data{
  int systemID;
  DateTime createdTime;
  DateTime updatedTime;
  String name;
  String description;
  String version;
  DateTime workStartedDate;
  Duration totalHours;
  Duration workItemsCount;

  Application._({@required this.systemID, @required this.name, @required this.description, this.createdTime,
    this.updatedTime, this.version, this.workStartedDate, this.totalHours, this.workItemsCount});

  factory Application(int systemID, String name, String description){
    String version = '0.1';
    DateTime createdTime = DateTime.now();
    return Application._(systemID: systemID, name: name, description: description, createdTime: createdTime, updatedTime: createdTime,
      version: version);
  }

  @override
  bool delete() {
    // TODO: implement delete
    return null;
  }

  @override
  bool save() {
    // TODO: implement save
    return null;
  }
}

///might not need this
class Settings {

}


