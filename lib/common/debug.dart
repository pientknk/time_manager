import 'package:flutter/foundation.dart' as Foundation;

class Debug{
  const Debug();

  ///if running in debug mode, this method will print to flutter logs, this might have to be avoided and check manually everytime
  ///so that this code be treeshaked out when in release mode
  static void debugPrintMessage(String message){
    if(Foundation.kDebugMode){
      Foundation.debugPrint(message);
    }
  }
}