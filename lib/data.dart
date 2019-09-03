import 'package:time_manager/abstracts.dart';
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
  int projectID;
  DateTime createdTime;
  DateTime updatedTime;
  int applicationID;
  String applicationName;
  String name;
  String details;
  String status;
  DateTime startedTime;
  DateTime completedTime;
  Duration totalHours;
  int workItemCount;

  Project.newProject({@required this.applicationID}){
    DateTime createdTime = DateTime.now();
    this.createdTime = createdTime;
  }

  Project._({@required this.projectID, @required this.applicationID, @required this.name, @required this.details, @required this.status,
    this.createdTime, this.updatedTime, this.totalHours, this.workItemCount, this.startedTime, this.completedTime, this.applicationName});

  factory Project(int projectID, int systemID, String name, String details, {Duration totalHours = const Duration(hours: 11, minutes: 38),
    String status = StatusTypes.available, int workItems = 19}){
    //TODO: retrieve info about application from the appID
    String appName = ApplicationNames.options[projectID];
    
    DateTime createdTime = DateTime.now();
    return Project._(projectID: projectID, applicationID: systemID, createdTime: createdTime, updatedTime: createdTime,
      name: name, details: details, status: status, totalHours: totalHours, workItemCount: workItems, applicationName: appName
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

class GetData{
  const GetData();

  static Iterable<WorkItem> getWorkItems(){
    return [
      WorkItem(1, 1, 'I did some work today', 'The work was real good'),
      WorkItem(2, 1, 'I did some more work today', 'I did some more work today on the same project'),
      WorkItem(3, 1, 'Still working', 'holy cow I did even more work on this project'),
      WorkItem(4, 2, 'Now this is the 2nd project worked on', 'I did some of this and some of that ya know?')
    ];
  }

  static Iterable<Filter> getFilters(){
    return [
      Filter(1, 'Current', true, true, status: StatusTypes.assigned),
      Filter(2, 'Available', true, false, status: StatusTypes.available),
      Filter(3, 'Completed', true, true, status: StatusTypes.finished),
    ];
  }

  static Map<String, Project> getProjectsMap(){
    Map<String, Project> projectMap = Map<String, Project>();
    getProjects().forEach((proj) {
      projectMap[proj.projectID.toString()] = proj;
    });

    return projectMap;
  }

  static Iterable<Project> getProjects(){
    return [
      Project(1, 1, 'This is my first project yo', 'Since this is my first project I should probly do something',
          workItems: 23, totalHours: Duration(hours: 9, minutes: 23), status: StatusTypes.assigned),
      Project(2, 1, 'This is a second project so this is good', 'wow I can\'t believe this is my second project',
          workItems: 1, totalHours: Duration(hours: 1, minutes: 1)),
      Project(3, 1, 'Oof third project is a lot of work', 'Can I go home?',
          workItems: 15, totalHours: Duration(hours: 3, minutes: 0)),
      Project(4, 1, 'Now this is just a lot of work', 'Since this is a lot of work I must be making a lot of prorgress', workItems: 9),
      Project(5, 1, 'What if this was like the 5th project?', '5 projects is a lot man, what should i do now?',
          workItems: 123, totalHours: Duration(hours: 127, minutes: 59), status: StatusTypes.finished),
      Project(6, 1, 'Time manager should work', 'yeah lets make time manager work this time instead of bailing out',
          totalHours: Duration(hours: 7, minutes: 59)),
    ];
  }

  static Iterable<Application> getApplications(){
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
