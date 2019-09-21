import 'package:time_manager/model/data.dart';

class DataSamples{
  const DataSamples();

  ///should be ran when the app starts to setup data for testing
  static bool initData(){
    bool isDataInitialized = false;

    projects.addAll(_getProjects());
    workItems.addAll(_getWorkItems());

    if(projects.isNotEmpty && workItems.isNotEmpty) {
      isDataInitialized = true;
    }

    return isDataInitialized;
  }

  static List<Project> projects = [];
  static Iterable<Project> _getProjects(){
    return [
      Project(projectId: 1, applicationId: 1, name: 'This is my first project yo', details: 'Since this is my first project I should probly do something',
        priority: 23, workItemCount: 23, totalHours: Duration(hours: 9, minutes: 23), status: StatusTypes.assigned,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 2, applicationId: 1, name: 'This is a second project so this is good', details: 'wow I can\'t believe this is my second project',
        priority: 12, workItemCount: 1, totalHours: Duration(hours: 1, minutes: 1), status: StatusTypes.assigned,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 3, applicationId: 1, name: 'Oof third project is a lot of work', details: 'Can I go home?',
        priority: 1, workItemCount: 15, totalHours: Duration(hours: 3, minutes: 0), status: StatusTypes.available,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 4, applicationId: 1, name: 'Now this is just a lot of work', details: 'Since this is a lot of work I must be making a lot of prorgress',
        priority: 3, workItemCount: 9, totalHours: Duration(hours: 2, minutes: 58), status: StatusTypes.finished,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 5, applicationId: 1, name: 'What if this was like the 5th project?', details: '5 projects is a lot man, what should i do now?',
        priority: 9, workItemCount: 123, totalHours: Duration(hours: 127, minutes: 59), status: StatusTypes.finished,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 6, applicationId: 1, name: 'Time manager should work', details: 'yeah lets make time manager work this time instead of bailing out',
        priority: 11, workItemCount: 12, totalHours: Duration(hours: 7, minutes: 59), status: StatusTypes.available,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
    ];
  }
  static bool addProject({int applicationId, String name, String details, String status = StatusTypes.available}){
    projects.sort((pr1, pr2) => pr1.projectId.compareTo(pr2.projectId));
    int highestId = projects.first.projectId;

    int projectLength = projects.length;
    projects.add(Project(projectId: ++highestId, applicationId: applicationId, name: name, details: details,
      workItemCount: 5, totalHours: Duration(hours: 12, minutes: 34), status: StatusTypes.assigned));

    if(projectLength != projects.length){
      return true;
    }

    return false;
  }
  static bool deleteProject(int projectID){
    int projectLength = projects.length;
    projects.removeWhere((project) => project.projectId == projectID);

    if(projectLength != projects.length){
      return true;
    }

    return false;
  }
  static bool updateProject(Project project){
    int projectLength = projects.length;
    projects.removeWhere((existingProject) => existingProject.projectId == project.projectId);
    projects.add(project);
    if(projectLength == projects.length){
      return true;
    }
    
    return false;
  }
  static Project getProjectById(int projectID){
    return projects.where((project) => project.projectId == projectID).first;
  }
  static Project getProjectByIdString(String id) {
    return DataSamples.getProjectById(int.parse(id));
  }

  static List<WorkItem> workItems = [];
  static Iterable<WorkItem> _getWorkItems(){
    return [
      WorkItem.create(workItemId: 1, startTime: DateTime(2019, 10, 9, 8, 2), endTime: DateTime(2019, 10, 9, 9, 19), projectId: 1,
        summary: 'I did some work today', details: 'The work was real good'),
      WorkItem.create(workItemId: 2, startTime: DateTime(2019, 11, 19, 12, 45), endTime: DateTime(2019, 11, 19, 16, 24), projectId: 1,
        summary: 'I did some more work today', details: 'I did some more work today on the same project'),
      WorkItem.create(workItemId: 3, startTime: DateTime(2019, 11, 20, 4, 51), endTime: DateTime(2019, 11, 20, 6, 20), projectId: 1,
        summary: 'I did some more work today', details: 'I did some more work today on the same project'),
      WorkItem.create(workItemId: 4, startTime: DateTime(2019, 11, 21, 5, 12), endTime: DateTime(2019, 11, 21, 8, 32), projectId: 1,
        summary: 'Now this is the 2nd project I worked on and I did the thing', details: 'I did some of this and some of that ya know?'),
    ];
  }
  static bool addWorkItem({int projectId, String summary, String details, DateTime startTime, DateTime endTime}){
    workItems.sort((wi1, wi2) => wi1.workItemId.compareTo(wi2.workItemId));
    int highestId = workItems.first.workItemId;

    int workItemsLength = workItems.length;
    workItems.add(WorkItem.create(workItemId: ++highestId, startTime: startTime, projectId: projectId, summary: summary, details: details));

    if(workItemsLength != workItems.length){
      return true;
    }

    return false;
  }
  static bool deleteWorkItem(int workItemId){
    int workItemLength = workItems.length;
    workItems.removeWhere((workItem) => workItem.workItemId == workItemId);

    if(workItemLength != workItems.length){
      return true;
    }

    return false;
  }
  static bool updateWorkItem(WorkItem workItem){
    int workItemLength = workItems.length;
    workItems.removeWhere((existingWorkItem) => existingWorkItem.workItemId == workItem.workItemId);
    workItems.add(workItem);
    if(workItemLength == workItems.length){
      return true;
    }

    return false;
  }
  static WorkItem getWorkItemById(int workItemId){
    return workItems.where((workItem) => workItem.workItemId == workItemId).first;
  }
  static WorkItem getWorkItemByIdString(String id) {
    return DataSamples.getWorkItemById(int.parse(id));
  }
  static Iterable<WorkItem> getAllWorkItemsForProject(int projectId){
    List<WorkItem> relatedWorkItems = [];

    workItems.forEach((workItem){
      if(workItem.projectId == projectId){
        relatedWorkItems.add(workItem);
      }
    });

    return relatedWorkItems;
  }

  static Iterable<Filter> getFilters(){
    return [
      Filter(filterId: 1, isDefault: true, isDescending: true, name: "Current Projects", status: StatusTypes.assigned),
      Filter(filterId: 2, isDefault: true, isDescending: true, name: "Available Projects", status: StatusTypes.available),
      Filter(filterId: 3, isDefault: true, isDescending: true, name: "Completed Projects", status: StatusTypes.finished),
    ];
  }


  static Iterable<Application> getApplications(){
    return [
      Application(applicationId: 1, name: 'Time Manager', description: 'A mobile app to manage time developing personal projects', version: "0.1"),
      Application(applicationId: 2, name: 'Jodeler', description: 'A mobile app to choose jodels to send to your friends', version: "0.0"),
      Application(applicationId: 3, name: 'Web Scraper/Crawler', description: 'A c# web app for web scraping from websites to gain information or to web crawl to gather info', version: "0.0"),
      Application(applicationId: 4, name: 'Live it UP', description: 'A party app containing music, drinks, and drinking games for all to have fun', version: "0.0"),
      Application(applicationId: 5, name: 'Package Drop', description: 'A unity game: strategy game that progressively gets difficult, the player must navigate packages to the goal', version: "0.0"),
      Application(applicationId: 6, name: 'CoOperation Breakout', description: 'A unity game:  2 player co op puzzle game where the players have to work together to get past the puzzles', version: "0.0"),
      Application(applicationId: 7, name: 'Data Structures', description: 'An application to test different data structures and experiment with them, possibly trying to make my own new types', version: "0.0"),
    ];
  }
}