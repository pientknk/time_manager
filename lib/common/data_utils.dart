import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const String shortDateFormatString = "MM/dd/yyyy hh:mm";
///Formats the given DateTime into a string consisting of MM/dd/yyyy hh:mm.
/// See [DateFormat]
String shortDateFormat(DateTime dateTime){
  return DateFormat(shortDateFormatString).format(dateTime);
}

const String detailedDateFormatString = "MM/dd/yyyy hh:mm a";
///Formats the given DateTime into a string consisting of MM/dd/yyyy hh:mm a.
/// See [DateFormat]
String detailedDateFormat(DateTime dateTime) {
  return DateFormat(detailedDateFormatString).format(dateTime);
}

const String detailedDateFormatWithSecondsString = "MM/dd/yyyy hh:mm:ss a";
String detailedDateFormatWithSeconds(DateTime dateTime) {
  return DateFormat(detailedDateFormatWithSecondsString).format(dateTime);
}

String reformatDetailedDateFormatWithSecondsString(String input){
  String month = input.substring(0, 2);
  String day = input.substring(3 ,5);
  String year = input.substring(6, 10);

  String hour = input.substring(11, 13);
  String minute = input.substring(14, 16);
  String second = input.substring(17, 19);

  String time = input.substring(20, 22);


  if(time == "PM"){
    int hourVal = int.parse(hour);
    hourVal += 12;

    hour = hourVal.toString();
  }

  String reformattedString = "$year-$month-$day $hour:$minute:$second";

  return reformattedString;
}

const String detailedDateFormat24HourWithSecondsString = "MM/dd/yyyy HH:mm:ss";
String detailedDateFormat24WithSecondsHour(DateTime dateTime) {
  return DateFormat(detailedDateFormat24HourWithSecondsString).format(dateTime);
}

const String longDetailedDateFormatString = "EEEE, MMMM dd, yyyy hh:mm a";
/// Formats the given DateTime into a string consisting of EEEE, MMMM dd, yyyy hh:mm a.
///   See [DateFormat]
String longDetailDateFormat(DateTime dateTime){
  return DateFormat(longDetailedDateFormatString).format(dateTime);
}

const String veryShortDateFormatString = "MM/dd/yyyy";
/// Formats the given DateTime into a string consisting of MM/dd/yyyy.
///   See [DateFormat]
String veryShortDateFormat(DateTime dateTime){
  return DateFormat(veryShortDateFormatString).format(dateTime);
}

const String shortHoursOnly24HourFormatString = "HH:mm:ss";
/// Formats the given DateTime into a string consisting of HH:mm:ss.
///   See [DateFormat]
String shortHoursOnly24HourFormat(DateTime dateTime){
  return DateFormat(shortHoursOnly24HourFormatString).format(dateTime);
}

/// returns a [Color] converted from the given hexadecimal code representation
Color hexToColor(String code){
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

/// Formats the given [Duration] to a String representation of hh:mm
String shortDurationFormat(Duration duration){
  if(duration == null){
    return '00:00';
  }

  String durationInHours = _ensureTwoDigits(duration.inHours);
  String durationInMinutes = _ensureTwoDigits(duration.inMinutes % 60);

  return '$durationInHours:$durationInMinutes';
}

String longDurationFormat(Duration duration){
  if(duration == null){
    return '00:00:00';
  }

  String durationInHours = _ensureTwoDigits(duration.inHours);
  String durationInMinutes = _ensureTwoDigits(duration.inMinutes % 60);
  String durationInSeconds = _ensureTwoDigits(duration.inSeconds % 60);

  return '$durationInHours:$durationInMinutes:$durationInSeconds';
}

String _ensureTwoDigits(int amount){
  if(amount == null){
    amount = 0;
  }

  if(amount == 0 || amount < 10){
    return '0$amount';
  }else{
    return amount.toString();
  }
}

String baseValidatorLengthValidation({String val = '', String fieldName = '', int maxLength = 0}){
  if(val.isEmpty){
    return '$fieldName is required';
  }
  else if(maxLength != 0 && val.length > maxLength){
    return '$fieldName must be less than $maxLength characters';
  }
  else{
    return null;
  }
}

String baseValidatorDateTimeRequiredValidation({DateTime val, String fieldName = ''}){
  if(val == null){
    return '$fieldName is required';
  }
  else{
    return null;
  }
}

String ensureValue({@required String value, String defaultValue}){
  if(value != null){
    return value;
  }
  else if(defaultValue != null){
    return defaultValue;
  }
  else{
    return "";
  }
}

/// Adds a value to an existing enum from an enum.toString representation
/// ex. Options.delete -> parses out delete and add that to the Options enum
void addToEnum<T>(List<T> enumValues, String valueToAdd){
  if(valueToAdd != null){
    List<String> values = valueToAdd.split('.');
    if(values.length == 2){
      //enumValues.add(values[1]);
    }
  }
}

bool intResultToBool(int result, {int expectedResult = 1}){
  if(result == expectedResult){
    return true;
  }
  else{
    return false;
  }
}
