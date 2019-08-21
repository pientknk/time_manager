import 'package:time_manager/abstracts.dart';

class WorkItem implements Data{

  ///the id for the object
  final int workItemID;
  final DateTime createdTime;
  final DateTime updatedTime;
  final DateTime startTime;
  final DateTime endTime;
  final int projectID;
  final String summary;
  final String details;
  Duration duration;

  WorkItem({
    this.workItemID,
    this.createdTime,
    this.updatedTime,
    this.startTime,
    this.endTime,
    this.projectID,
    this.summary,
    this.details
  }) {
    this.duration = Duration(
      hours: 3,
      minutes: 13,
      seconds: 52
    );
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
  final int projectID;
  final DateTime createdTime;
  final DateTime updatedTime;
  final int systemID;
  final String name;
  final String description;
  final StatusTypes status;
  double totalHours;
  int workItems;

  Project({
    this.projectID,
    this.createdTime,
    this.updatedTime,
    this.systemID,
    this.name,
    this.description,
    this.status,
  }) {
    this.totalHours = 10;
    this.workItems = 3;
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

enum StatusTypes {
  assigned,
  available,
  finished
}

class Filter implements Data {
  final int filterID;
  final DateTime createdTime;
  final DateTime updatedTime;
  final String filterXML; //might not need this if the various aspected of a filter can easily be defined in fields and won't change
  final bool isDefault;
  final bool isDescending;
  final String name;

  Filter({
    this.filterID,
    this.createdTime,
    this.updatedTime,
    this.filterXML,
    this.isDefault,
    this.isDescending,
    this.name
  });

  Filter.fromFilter(Filter filter) :
    this.filterID = filter.filterID,
    this.createdTime = filter.createdTime,
    this.updatedTime = filter.updatedTime,
    this.filterXML = filter.filterXML,
    this.isDefault = filter.isDefault,
    this.isDescending = filter.isDescending,
    this.name = filter.name;

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
  final int systemID;
  final DateTime createdTime;
  final DateTime updatedTime;
  final String name;
  final String description;
  final String version;
  final DateTime workStartedDate;

  Application({
    this.systemID,
    this.createdTime,
    this.updatedTime,
    this.name,
    this.description,
    this.version,
    this.workStartedDate
  });

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
