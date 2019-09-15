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
