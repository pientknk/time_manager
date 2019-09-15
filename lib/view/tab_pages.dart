import 'package:flutter/material.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/model/data_samples.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/view/project_page.dart';
import 'package:time_manager/common/routing.dart';
import 'package:fluro/fluro.dart';
import 'package:time_manager/common/data_utils.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/app_custom_scroll_view.dart';

class CurrentProjectsTab extends StatefulWidget {
  CurrentProjectsTab({
    Key key
  }) : super(key: key);

  _CurrentProjectsTabState createState() => _CurrentProjectsTabState();
}

class _CurrentProjectsTabState extends State<CurrentProjectsTab> {
  static final _projects = DataSamples.projects;
  static final _filters = DataSamples.getFilters().toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return TabWidgets.buildProjectListView(_projects, _filters[0]);
  }
}

class AvailableProjectsTab extends StatefulWidget {
  AvailableProjectsTab({Key key}) : super(key: key);

  _AvailableProjectsTabState createState() => _AvailableProjectsTabState();
}

class _AvailableProjectsTabState extends State<AvailableProjectsTab> {
  static final _projects = DataSamples.projects;
  static final _filters = DataSamples.getFilters().toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return TabWidgets.buildProjectListView(_projects, _filters[1]);
  }
}

class CompletedProjectsTab extends StatefulWidget {
  CompletedProjectsTab({Key key}) : super(key: key);
  
  _CompletedProjectsTabState createState() => _CompletedProjectsTabState();
}

class _CompletedProjectsTabState extends State<CompletedProjectsTab> {
  static final _projects = DataSamples.projects;
  static final _filters = DataSamples.getFilters().toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return TabWidgets.buildProjectListView(_projects, _filters[2]);
  }
}

class TestingTab extends StatefulWidget {
  TestingTab({Key key}) : super(key: key);

  @override
  _TestingTabState createState() => _TestingTabState();
}

class _TestingTabState extends State<TestingTab> {
  @override
  Widget build(BuildContext context) {
    return AppCustomScrollView();
    //return AppNestedScrollView();
  }
}

class TabWidgets{
  const TabWidgets();

  static Widget buildProjectListView(List<Project> projects, Filter filter){
    projects.sort((pr1, pr2) =>
      filter.isDescending
          ? pr1.name.compareTo(pr2.name)
          : pr2.name.compareTo(pr1.name));

    final filteredProjects = projects.where((pr) => pr.status == filter.status).toList(growable: false);

    if(filteredProjects.isEmpty){
      return Container(
        color: ThemeColors.appMain,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ThemeText.headerText('No Records'),
            )
          ],
        ),
      );
    }else{
      return Column(
        children: <Widget>[
          Flexible(
            child: Container(
              color: ThemeColors.appMain,
              child: ListView.builder(
                itemExtent: 160,
                itemCount: filteredProjects.length,
                itemBuilder: (_, index) => ProjectCard(project: filteredProjects[index]),
              ),
            )
          )
        ],
      );
    }
  }
}