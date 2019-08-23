import 'package:time_manager/abstracts.dart';
import 'package:flutter/foundation.dart';

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
  final Duration duration;

  WorkItem._({@required this.workItemID, @required this.startTime, @required this.projectID, @required this.summary,
    @required this.details, this.createdTime, this.updatedTime, this.endTime, this.duration});

  factory WorkItem(int workItemID, int projectID, String summary, String details){
    DateTime createdTime = DateTime.now();
    Duration duration = Duration(hours: 2, minutes: 12);
    DateTime endTime = createdTime.add(duration);
    return WorkItem._(workItemID: 1, startTime: createdTime, projectID: 1, summary: summary, details: summary, createdTime: createdTime,
      updatedTime: createdTime, duration: duration, endTime: endTime);
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
  final String details;
  final StatusTypes status;
  final DateTime startedTime;
  final DateTime completedTime;
  final Duration totalHours;
  final int workItems;

  Project._({@required this.projectID, @required this.systemID, @required this.name, @required this.details, @required this.status,
    this.createdTime, this.updatedTime, this.totalHours, this.workItems, this.startedTime, this.completedTime});

  factory Project(int projectID, int systemID, String name, String details, {StatusTypes status = StatusTypes.available}){
    Duration totalHours = Duration(hours: 11, minutes: 38);
    DateTime createdTime = DateTime.now();
    int workItems = 19;
    return Project._(projectID: projectID, systemID: systemID, createdTime: createdTime, updatedTime: createdTime,
      name: name, details: details, status: status, totalHours: totalHours, workItems: workItems
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

enum StatusTypes {
  assigned,
  available,
  finished,
  voided
}

class Filter implements Data {
  final int filterID;
  final DateTime createdTime;
  final DateTime updatedTime;
  final String filterXML; //might not need this if the various aspects of a filter can easily be defined in fields and won't change
  final bool isDefault;
  final bool isDescending;
  final String name;

  Filter._({@required this.filterID, @required this.isDefault, @required this.isDescending, @required this.name,
    this.createdTime, this.updatedTime, this.filterXML,
  });

  factory Filter(int filterID, String name, bool isDefault, bool isDescending){
    DateTime createdTime = DateTime.now();
    return Filter._(filterID: filterID, isDefault: isDefault, isDescending: isDescending, name: name, createdTime: createdTime,
      updatedTime: createdTime, filterXML: 'no filter xml');
  }

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
  final Duration totalHours;
  final Duration totalWorkItems;

  Application._({@required this.systemID, @required this.name, @required this.description, this.createdTime,
    this.updatedTime, this.version, this.workStartedDate, this.totalHours, this.totalWorkItems});

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

class GetData{
  const GetData();

  static getFilters(){
    return [
      Filter(1, 'Current', true, true),
      Filter(2, 'Available', true, true),
      Filter(3, 'Completed', true, true),
    ];
  }

  static getProjects(){
    return [
      Project(1, 1, 'This is my first project yo', 'Since this is my first project I should probly do something'),
      Project(2, 1, 'This is a second project so this is good', 'wow I can\'t believe this is my second project'),
      Project(3, 1, 'Oof third project is a lot of work', 'Can I go home?'),
      Project(4, 1, 'Now this is just a lot of work', 'Since this is a lot of work I must be making a lot of prorgress'),
      Project(5, 1, 'What if this was like the 5th project?', '5 projects is a lot man, what should i do now?'),
      Project(6, 1, 'Time manager should work', 'yeah lets make time manager work this time instead of bailing out'),
    ];
  }

  static getApplications(){
    return [
      Application(1, 'Time Manager', 'A mobile app to manage time developing personal projects'),
      Application(2, 'Jodeler', 'A mobile app to choose jodels to send to your friends'),
      Application(3, 'Web Scraper/Crawler', 'A c# web app for web scraping from websites to gain information or to web crawl to gather info'),
      Application(4, 'Live it UP', 'A party app containing music, drinks, and drinking games for all to have fun'),
      Application(5, 'Package Drop', 'A unity game: strategy game that progressively gets difficult, the player must navigate packages to the goal'),
      Application(6, 'CoOperation Breakout', 'A unity game:  2 player co op puzzle game where the players have to work together to get past the puzzles'),
      Application(7, 'Data Structures', 'An application to test different data structures and experiment with them, possibly trying to make my own new types'),
    ];
  }
}
