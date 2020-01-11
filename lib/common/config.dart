import 'package:flutter/foundation.dart' as Foundation;
import 'package:time_manager/model/data.dart';

enum BuildMode { Debug, Profile, Release }

class Config {
  static BuildMode getBuildMode(){
    if(Foundation.kReleaseMode){
      return BuildMode.Release;
    }
    else if(Foundation.kDebugMode){
      return BuildMode.Debug;
    }
    else{
      return BuildMode.Profile;
    }
  }

  static void setupSettings(Settings settings){
    switch(getBuildMode()){
      case BuildMode.Debug:

      default:

    }
  }
}