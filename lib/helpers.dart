import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


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
