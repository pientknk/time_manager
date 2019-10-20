import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/view/project_page.dart';
import 'package:time_manager/view/work_item_page.dart';
import 'package:time_manager/view/settings_page.dart';

class Routing {
  static final Router _router = Router();

  static const projectEditRoute = "/project/edit";
  static const projectDetailRoute = "/project/detail";
  static const projectAddRoute = "/project/add";
  static const settingsRoute = "/settings";
  static const workItemAddRoute = "/workItem/add";
  static const workItemDetailRoute = "/workItem/detail";
  static const workItemEditRoute = "/workItem/edit";

  static void initRoutes() {
    _router.define("$projectDetailRoute/:id", handler: projectDetailHandler);
    _router.define("$projectEditRoute/:id", handler: projectEditHandler);
    _router.define("$projectAddRoute/:applicationId", handler: projectAddHandler);
    _router.define(settingsRoute, handler: settingsHandler);
    _router.define("$workItemAddRoute/:projectId", handler: workItemAddHandler);
    _router.define("$workItemDetailRoute/:id", handler: workItemDetailHandler);
    _router.define("$workItemEditRoute/:id", handler: workItemEditHandler);
  }

  static Handler projectDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ProjectDetailPage(params["id"][0]);
    }
  );

  static Handler projectEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ProjectEditPage(params["id"][0]);
    }
  );

  static Handler projectAddHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ProjectAddPage(params["applicationId"][0]);
    }
  );

  static Handler settingsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SettingsPage();
    }
  );

  static Handler workItemAddHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return WorkItemAddPage(params["projectId"][0]);
    }
  );

  static Handler workItemDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return WorkItemDetailPage(params["id"][0]);
    }
  );

  static Handler workItemEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return WorkItemEditPage(params["id"][0]);
    }
  );

  static Future navigateTo(context, String route, {TransitionType transition}){
    return _router.navigateTo(context, route, transition: transition);
  }

  static void pop(BuildContext context){
    bool didPop = _router.pop(context);
    if(!didPop){
      //handle this in some way? or report it? or maybe try to return to home screen?
    }
  }
}