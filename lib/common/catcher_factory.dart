import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/widgets.dart';

import 'debug.dart';

class CatcherFactory {
  static Catcher standardCatcher(Widget rootWidget) {
    //debug configuration
    CatcherOptions debugOptions =
    CatcherOptions(DialogReportMode(), [ConsoleHandler()]);

    //release configuration
    CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
      EmailManualHandler(["pientagon@gmail.com"])
    ]);

    //profile configuration
    CatcherOptions profileOptions = CatcherOptions(
      NotificationReportMode(),
      [ConsoleHandler(), ToastHandler()],
      handlerTimeout: 10000,
      customParameters: {"example": "example_parameter"},
    );

    return Catcher(rootWidget,
      debugConfig: debugOptions,
      releaseConfig: releaseOptions,
      profileConfig: profileOptions);
  }
}