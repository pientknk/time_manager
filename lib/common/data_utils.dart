import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/model/data_samples.dart';

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

/// returns a [Color] converted from the given hexadecimal code representation
Color hexToColor(String code){
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

/// Formats the given [Duration] to a String representation of hh:mm
String shortDurationFormat(Duration duration){
  String durationInHours = _ensureTwoDigits(duration.inHours);
  String durationInMinutes = _ensureTwoDigits(duration.inMinutes % 60);

  return '$durationInHours:$durationInMinutes';
}

String longDurationFormat(Duration duration){
  String durationInHours = _ensureTwoDigits(duration.inHours);
  String durationInMinutes = _ensureTwoDigits(duration.inMinutes % 60);
  String durationInSeconds = _ensureTwoDigits(duration.inSeconds % 60);

  return '$durationInHours:$durationInMinutes:$durationInSeconds';
}

String _ensureTwoDigits(int amount){
  return amount >= 10 ? '$amount' : '0$amount';
}
