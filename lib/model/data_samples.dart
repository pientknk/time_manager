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
      Project(1, 1, 'This is my first project yo', 'Since this is my first project I should probly do something',
        workItems: 23, totalHours: Duration(hours: 9, minutes: 23), status: StatusTypes.assigned),
      Project(2, 1, 'This is a second project so this is good', 'wow I can\'t believe this is my second project',
        workItems: 1, totalHours: Duration(hours: 1, minutes: 1)),
      Project(3, 1, 'Oof third project is a lot of work', 'Can I go home?',
        workItems: 15, totalHours: Duration(hours: 3, minutes: 0)),
      Project(4, 1, 'Now this is just a lot of work', 'Since this is a lot of work I must be making a lot of prorgress',
        workItems: 9, totalHours: Duration(hours: 2, minutes: 58)),
      Project(5, 1, 'What if this was like the 5th project?', '5 projects is a lot man, what should i do now?',
        workItems: 123, totalHours: Duration(hours: 127, minutes: 59), status: StatusTypes.finished),
      Project(6, 1, 'Time manager should work', 'yeah lets make time manager work this time instead of bailing out',
        totalHours: Duration(hours: 7, minutes: 59)),
    ];
  }
  static bool addProject({int applicationId, String name, String details, String status = StatusTypes.available}){
    projects.sort((pr1, pr2) => pr1.projectID.compareTo(pr2.projectID));
    int highestId = projects.first.projectID;

    int projectLength = projects.length;
    projects.add(Project(++highestId, applicationId, name, details, status: status));

    if(projectLength != projects.length){
      return true;
    }

    return false;
  }
  static bool deleteProject(int projectID){
    int projectLength = projects.length;
    projects.removeWhere((project) => project.projectID == projectID);

    if(projectLength != projects.length){
      return true;
    }

    return false;
  }
  static bool updateProject(Project project){
    int projectLength = projects.length;
    projects.removeWhere((existingProject) => existingProject.projectID == project.projectID);
    projects.add(project);
    if(projectLength == projects.length){
      return true;
    }
    
    return false;
  }
  static Project getProjectById(int projectID){
    return projects.where((project) => project.projectID == projectID).first;
  }
  static Project getProjectByIdString(String id) {
    return DataSamples.getProjectById(int.parse(id));
  }

  static List<WorkItem> workItems = [];
  static Iterable<WorkItem> _getWorkItems(){
    return [
      WorkItem.create(workItemID: 1, startTime: DateTime(2019, 10, 9, 8, 2), endTime: DateTime(2019, 10, 9, 9, 19), projectID: 1,
        summary: 'I did some work today', details: 'The work was real good'),
      WorkItem.create(workItemID: 2, startTime: DateTime(2019, 11, 19, 12, 45), endTime: DateTime(2019, 11, 19, 16, 24), projectID: 1,
        summary: 'I did some more work today', details: 'I did some more work today on the same project'),
      WorkItem.create(workItemID: 3, startTime: DateTime(2019, 11, 20, 4, 51), endTime: DateTime(2019, 11, 20, 6, 20), projectID: 1,
        summary: 'I did some more work today', details: 'I did some more work today on the same project'),
      WorkItem.create(workItemID: 4, startTime: DateTime(2019, 11, 21, 5, 12), endTime: DateTime(2019, 11, 21, 8, 32), projectID: 1,
        summary: 'Now this is the 2nd project I worked on and I did the thing', details: 'I did some of this and some of that ya know?'),
    ];
  }
  static bool addWorkItem({int projectId, String summary, String details, DateTime startTime, DateTime endTime}){
    workItems.sort((wi1, wi2) => wi1.workItemID.compareTo(wi2.workItemID));
    int highestId = workItems.first.workItemID;

    int workItemsLength = workItems.length;
    workItems.add(WorkItem.create(workItemID: ++highestId, startTime: startTime, projectID: projectId, summary: summary, details: details));

    if(workItemsLength != workItems.length){
      return true;
    }

    return false;
  }
  static bool deleteWorkItem(int workItemId){
    int workItemLength = workItems.length;
    workItems.removeWhere((workItem) => workItem.workItemID == workItemId);

    if(workItemLength != workItems.length){
      return true;
    }

    return false;
  }
  static bool updateWorkItem(WorkItem workItem){
    int workItemLength = workItems.length;
    workItems.removeWhere((existingWorkItem) => existingWorkItem.workItemID == workItem.workItemID);
    workItems.add(workItem);
    if(workItemLength == workItems.length){
      return true;
    }

    return false;
  }
  static WorkItem getWorkItemById(int workItemId){
    return workItems.where((workItem) => workItem.workItemID == workItemId).first;
  }
  static WorkItem getWorkItemByIdString(String id) {
    return DataSamples.getWorkItemById(int.parse(id));
  }
  static Iterable<WorkItem> getAllWorkItemsForProject(int projectId){
    List<WorkItem> relatedWorkItems = [];

    workItems.forEach((workItem){
      if(workItem.projectID == projectId){
        relatedWorkItems.add(workItem);
      }
    });

    return relatedWorkItems;
  }

  static Iterable<Filter> getFilters(){
    return [
      Filter(1, 'Current', true, true, status: StatusTypes.assigned),
      Filter(2, 'Available', true, false, status: StatusTypes.available),
      Filter(3, 'Completed', true, true, status: StatusTypes.finished),
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