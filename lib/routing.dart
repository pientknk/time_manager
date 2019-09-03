import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/widgets.dart';

class Routing {
  static final Router _router = Router();

  static const projectEditRoute = "/project/edit";
  static const projectDetailRoute = "/project/detail";
  static const projectAddRoute = "/project/add";
  static const settingsRoute = "/settings";
  static void initRoutes() {
    _router.define("$projectDetailRoute/:id", handler: projectDetailHandler);
    _router.define("$projectEditRoute/:id", handler: projectEditHandler);
    _router.define("$projectAddRoute/:applicationId", handler: projectAddHandler);
    _router.define(settingsRoute, handler: settingsHandler);
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

  static void navigateTo(context, String route, {TransitionType transition}){
    _router.navigateTo(context, route, transition: transition);
  }

  static void pop(BuildContext context){
    bool didPop = _router.pop(context);
    if(!didPop){
      //handle this in some way? or report it? or maybe try to return to home screen?
    }
  }
}