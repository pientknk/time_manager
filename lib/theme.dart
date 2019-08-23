import 'package:flutter/material.dart';

class ThemeColors{
  const ThemeColors();

  static const Color appMain = const Color(0xFF1F1F1F);
  static const Color card = const Color(0xFF333333);
  static const Color mainText = const Color(0xFFEBEBEB);
  static const Color headerText = const Color(0xFFE0E0E0);
  //static const Color highlightedData = const Color(0xFF0DA112);
  static const Color highlightedData = const Color(0xFF5bb36e);
  static const Color labelText = const Color(0xFFCFCFCF);
  static const Color lineSeparator = const Color(0xFFC9AC1A);
}

class TextStyles{
  const TextStyles();

  static const TextStyle labelText = const TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ThemeColors.labelText,
  );

  static const TextStyle highlightedDataText = const TextStyle(
    fontFamily: 'Poppins',
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: ThemeColors.highlightedData,
  );

  static const TextStyle mainText = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ThemeColors.mainText,
  );

  static const TextStyle headerText = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: ThemeColors.headerText,
  );
}