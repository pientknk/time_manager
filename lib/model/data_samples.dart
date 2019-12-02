import 'package:time_manager/model/data.dart';

class DataSamples{
  const DataSamples();

  ///should be ran when the app starts to setup data for testing
  static bool initData(){
    bool isDataInitialized = false;

    projects.addAll(_getProjects());
    workItems.addAll(_getWorkItems());
    statusTypes.addAll(_getStatusTypes());
    filters.addAll(_getFilters());
    applications.addAll(_getApplications());

    if(projects.isNotEmpty &&
      workItems.isNotEmpty &&
      statusTypes.isNotEmpty &&
      filters.isNotEmpty &&
      applications.isNotEmpty) {
      isDataInitialized = true;
    }

    return isDataInitialized;
  }

  static List<Project> projects = [];
  static Iterable<Project> _getProjects(){
    return [
      Project(projectId: 1, applicationId: 1, name: 'This is my first project yo', description: 'Since this is my first project I should probly do something',
        priority: 23, workItemCount: 23, totalHours: Duration(hours: 9, minutes: 23), statusTypeId: 1,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 2, applicationId: 1, name: 'This is a second project so this is good', description: 'wow I can\'t believe this is my second project',
        priority: 12, workItemCount: 1, totalHours: Duration(hours: 1, minutes: 1), statusTypeId: 1,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 3, applicationId: 1, name: 'Oof third project is a lot of work', description: 'Can I go home?',
        priority: 1, workItemCount: 15, totalHours: Duration(hours: 3, minutes: 0), statusTypeId: 2,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 4, applicationId: 1, name: 'Now this is just a lot of work', description: 'Since this is a lot of work I must be making a lot of prorgress',
        priority: 3, workItemCount: 9, totalHours: Duration(hours: 2, minutes: 58), statusTypeId: 3,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 5, applicationId: 1, name: 'What if this was like the 5th project?', description: '5 projects is a lot man, what should i do now?',
        priority: 9, workItemCount: 123, totalHours: Duration(hours: 127, minutes: 59), statusTypeId: 3,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
      Project(projectId: 6, applicationId: 1, name: 'Time manager should work', description: 'yeah lets make time manager work this time instead of bailing out',
        priority: 11, workItemCount: 12, totalHours: Duration(hours: 7, minutes: 59), statusTypeId: 2,
      startedTime: DateTime.now(), completedTime: DateTime(2999)),
    ];
  }
  static bool addProjectByFields({int applicationId, String name, String details, int statusTypeId, DateTime startTime, DateTime completeTime}){
    projects.sort((pr1, pr2) => pr1.projectId.compareTo(pr2.projectId));
    int highestId = projects.last.projectId;

    int projectLength = projects.length;
    projects.add(Project(projectId: ++highestId, applicationId: applicationId, name: name, description: details,
      workItemCount: 0, totalHours: Duration(hours: 0, minutes: 0), statusTypeId: statusTypeId, startedTime: startTime, completedTime: completeTime));

    if(projectLength != projects.length){
      return true;
    }

    return false;
  }
  static bool addProject(Project project){
    if(project.applicationId == null || project.name == null || project.description == null
      || project.startedTime == null || project.completedTime == null || project.statusTypeId == null){
      return false;
    }
    else{
      return addProjectByFields(
        applicationId: project.applicationId,
        name: project.name,
        details: project.description,
        statusTypeId: project.statusTypeId,
        startTime: project.startedTime,
        completeTime: project.completedTime,
      );
    }
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
    return projects.firstWhere((project) => project.projectId == projectID);
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
  static bool addWorkItemByProp({int projectId, String summary, String details, DateTime startTime, DateTime endTime}){
    workItems.sort((wi1, wi2) => wi1.workItemId.compareTo(wi2.workItemId));
    int highestId = workItems.last.workItemId;

    int workItemsLength = workItems.length;
    workItems.add(WorkItem.create(workItemId: ++highestId, startTime: startTime, endTime: endTime, projectId: projectId, summary: summary, details: details));

    if(workItemsLength != workItems.length){
      return true;
    }

    return false;
  }
  static bool addWorkItem(WorkItem workItem){
    if(workItem.projectId == null || workItem.summary == null || workItem.details == null || workItem.startTime == null || workItem.endTime == null){
      return false;
    }
    else{
      return addWorkItemByProp(
        projectId: workItem.projectId,
        summary: workItem.summary,
        details: workItem.details,
        startTime: workItem.startTime,
        endTime: workItem.endTime,
      );
    }
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
    return workItems.firstWhere((workItem) => workItem.workItemId == workItemId);
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

  static List<StatusType> statusTypes = [];
  static Iterable<StatusType> _getStatusTypes(){
    return [
      StatusType(statusTypeId: 1, name: "Assigned"),
      StatusType(statusTypeId: 2, name: "Available"),
      StatusType(statusTypeId: 3, name: "Finished"),
      StatusType(statusTypeId: 4, name: "Voided"),
      StatusType(statusTypeId: 5, name: "Dependent"),
    ];
  }
  static bool addStatusType({String name}){
    int highestId = statusTypes.last.statusTypeId;

    int statusTypeLength = statusTypes.length;
    statusTypes.add(StatusType(statusTypeId: ++highestId, name: name));

    if(statusTypeLength != statusTypes.length){
      return true;
    }

    return false;
  }
  static bool deleteStatusType(int statusTypeId){
    int statusTypeLength = statusTypes.length;
    statusTypes.removeWhere((statusType) => statusType.statusTypeId == statusTypeId);

    if(statusTypeLength != statusTypes.length){
      return true;
    }

    return false;
  }
  static bool updateStatusType(StatusType statusType){
    int statusTypeLength = statusTypes.length;
    statusTypes.removeWhere((existingStatusType) => existingStatusType.statusTypeId == statusType.statusTypeId);
    statusTypes.add(statusType);

    if(statusTypeLength == statusTypes.length){
      return true;
    }

    return false;
  }
  static StatusType getStatusTypeById(int statusTypeId){
    return statusTypes.firstWhere((statusType) => statusType.statusTypeId == statusTypeId);
  }
  static StatusType getStatusTypeByIdString(String statusTypeId){
    return DataSamples.getStatusTypeById(int.parse(statusTypeId));
  }

  static List<Filter> filters = [];
  static Iterable<Filter> _getFilters(){
    return [
      Filter(filterId: 1, isDefault: true, isDescending: true, name: "Current Projects", statusTypeId: 1),
      Filter(filterId: 2, isDefault: true, isDescending: true, name: "Available Projects", statusTypeId: 2),
      Filter(filterId: 3, isDefault: true, isDescending: true, name: "Completed Projects", statusTypeId: 3),
    ];
  }
  static bool addFilter({bool isDescending, String name, int statusTypeId}){
    int highestId = filters.last.filterId;
    int filterLength = filters.length;

    filters.add(Filter(filterId: ++highestId, isDefault: false, isDescending: isDescending, name: name, statusTypeId: statusTypeId));

    if(filterLength != filters.length){
      return true;
    }

    return false;
  }
  static bool deleteFilter(int filterId){
    int filterLength = filters.length;
    filters.removeWhere((filter) => filter.filterId == filterId);

    if(filterLength != filters.length){
      return true;
    }

    return false;
  }
  static bool updateFilter(Filter filter){
    int filterLength = filters.length;
    filters.removeWhere((existingFilter) => existingFilter.filterId == filter.filterId);
    filters.add(filter);
    
    if(filterLength == filters.length){
      return true;
    }
    
    return false;
  }
  static Filter getFilterById(int filterId){
    return filters.firstWhere((filter) => filter.filterId == filterId);
  }
  static Filter getFilterByIdString(String filterId){
    return DataSamples.getFilterById(int.parse(filterId));
  }

  static List<Application> applications = [];
  static Iterable<Application> _getApplications(){
    return [
      Application(applicationId: 1, name: 'Time Manager', description: 'A mobile app to manage time developing personal projects', version: "0.1"),
      Application(applicationId: 2, name: 'Jodeler', description: 'A mobile app to choose jodels to send to your friends', version: "0.0"),
      Application(applicationId: 3, name: 'Web Scraper/Crawler', description: 'A c# web app for web scraping from websites to gain information or to web crawl to gather info', version: "0.0"),
      Application(applicationId: 4, name: 'Live it UP', description: 'A party app containing music, drinks, and drinking games for all to have fun', version: "0.0"),
      Application(applicationId: 5, name: 'Package Drop', description: 'A unity game: strategy game that progressively gets difficult, the player must navigate packages to the goal', version: "0.0"),
      Application(applicationId: 6, name: 'CoOperation Breakout', description: 'A unity game:  2 player co op puzzle game where the players have to work together to get past the puzzles', version: "0.0"),
      Application(applicationId: 7, name: 'Data Structures', description: 'An application to test different data structures and experiment with them, possibly trying to make my own new types', version: "0.0"),
      Application(applicationId: 8, name: 'Workout App', description: 'An application to help workout by giving workouts and listing options based on equipment, etc', version: "0.0"),
    ];
  }
  static bool addApplication({String name, String description, String version = "0.0"}){
    int highestId = applications.last.applicationId;
    int applicationLength = applications.length;

    applications.add(Application(applicationId: ++highestId, name: name, description: description, version: version));

    if(applicationLength != applications.length){
      return true;
    }

    return false;
  }
  static bool deleteApplication(int applicationId){
    int applicationLength = applications.length;
    applications.removeWhere((app) => app.applicationId == applicationId);

    if(applicationLength != applications.length){
      return true;
    }

    return false;
  }
  static bool updateApplication(Application application){
    int applicationLength = applications.length;
    applications.removeWhere((app) => app.applicationId == application.applicationId);
    applications.add(application);

    if(applicationLength == applications.length){
      return true;
    }

    return false;
  }
  static Application getApplicationById(int applicationId){
    return applications.firstWhere((app) => app.applicationId == applicationId);
  }
  static Application getApplicationByIdString(String applicationId){
    return DataSamples.getApplicationById(int.parse(applicationId));
  }

  static List<ProjectType> projectTypes = [];
  static Iterable<ProjectType> _getProjectTypes(){
    return [
      ProjectType(projectTypeId: 1, name: "None", description: "Default value for project types"),
      ProjectType(projectTypeId: 2, name: "Enhancement", description: "An improvement in functionaliy or quality"),
      ProjectType(projectTypeId: 3, name: "Feature", description: "A piece of functionality that delivers business value"),
    ];
  }
}