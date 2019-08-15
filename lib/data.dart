class WorkItem {
  DateTime startDate;
  DateTime endDate;
  int projectID;
  int workItemID;
  String summary;
  String details;

  WorkItem(DateTime startDate, DateTime endDate, int projectID, int workItemID, String summary, String details) {
    this.startDate = startDate;
    this.endDate = endDate;
    this.projectID = projectID;
    this.workItemID = workItemID;
    this.summary = summary;
    this.details = details;
  }
}
