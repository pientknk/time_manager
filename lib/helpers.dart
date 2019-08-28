import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';

///Formats the given DateTime into a string consisting of MM/dd/yyyy hh:mm.
/// See [DateFormat]
String shortDateFormat(DateTime dateTime){
  return DateFormat("MM/dd/yyyy hh:mm").format(dateTime);
}

/// Formats the given DateTime into a string consisting of MM/dd/yyyy.
///   See [DateFormat]
String veryShortDateFormat(DateTime dateTime){
  return DateFormat('MM/dd/yyyy').format(dateTime);
}

/// returns a [Color] converted from the given hexadecimal code representation
Color hexToColor(String code){
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

/// Formats the given [Duration] to a String representation of hh:mm
String shortDurationFormat(Duration duration){
  String _ensureTwoDigits(int amount){
    return amount > 10 ? '$amount' : '0$amount';
  }

  String durationInHours = _ensureTwoDigits(duration.inHours);
  String durationInMinutes = _ensureTwoDigits(duration.inMinutes % 60);
  return '$durationInHours:$durationInMinutes';
}
