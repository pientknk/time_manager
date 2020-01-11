library prefs;

import 'package:prefs/prefs.dart';
import 'package:time_manager/common/theme.dart';

//Used to determine the apps state upon startup
class UserPrefs {
  static String _use24Hour = 'is24Hour';
  static String _themeType = "themeType";

  static bool get is24Hour{
    return Prefs.getBool(_use24Hour);
  }

  static set is24Hour(bool value){
    Prefs.setBool(_use24Hour, value);
  }

  static ThemeType get themeType{
    return Prefs.get(_themeType);
  }

  static set themeType(ThemeType type){
    Prefs.setString(_themeType, type.toString());
  }

  static void init(){
    Prefs.init();
  }

  static void dispose(){
    Prefs.dispose();
  }
}