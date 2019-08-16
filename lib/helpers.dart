import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String shortDateFormat(DateTime dateTime){
  return DateFormat("MM/dd/yyyy hh:mm").format(dateTime);
}

Color hexToColor(String code){
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
