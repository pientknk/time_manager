import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ThemeColors{
  const ThemeColors();

  static const Color appMain = const Color(0xFF1F1F1F);
  static const Color card = const Color(0xFF333333);
  static const Color mainText = const Color(0xFFEBEBEB);
  static const Color headerText = const Color(0xFFE0E0E0);
  static const Color highlightedData = const Color(0xFF3B9F3F);
  static const Color labelText = const Color(0xFFCFCFCF);
  static const Color lineSeparator = const Color(0xFFC9AC1A);
  static const Color unselectedButtonColor = const Color(0xFFD9D9D9);
}

class ThemeTextStyles{
  const ThemeTextStyles();

  static const String mainFont = 'Roboto Condensed';
  static const String dataFont = 'Roboto';

  static const TextStyle labelText = const TextStyle(
    fontFamily: mainFont,
    fontSize: 19,
    fontWeight: FontWeight.bold,
    color: ThemeColors.labelText,
  );

  static const TextStyle highlightedDataText = const TextStyle(
    fontFamily: dataFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ThemeColors.highlightedData,
  );

  static const TextStyle mainText = const TextStyle(
    fontFamily: mainFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ThemeColors.mainText,
  );

  static const TextStyle headerText = const TextStyle(
    fontFamily: mainFont,
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: ThemeColors.headerText,
  );
}

class ThemeText {
  const ThemeText();

  static AutoSizeText headerText(String text) {
    return AutoSizeText(text,
      style: ThemeTextStyles.headerText,
      maxLines: 2,
      minFontSize: 18,
      textAlign: TextAlign.left,
      semanticsLabel: 'n/a',
      overflow: TextOverflow.ellipsis,
    );
  }

  static AutoSizeText labelText(String text) {
    return AutoSizeText(text,
      style: ThemeTextStyles.labelText,
      maxLines: 2,
      minFontSize: 14,
      textAlign: TextAlign.center,
      semanticsLabel: 'n/a',
      overflow: TextOverflow.ellipsis,
    );
  }

  static AutoSizeText highlightedText(String text) {
    return AutoSizeText(text,
      style: ThemeTextStyles.highlightedDataText,
      maxLines: 2,
      minFontSize: 14,
      textAlign: TextAlign.center,
      semanticsLabel: 'n/a',
      overflow: TextOverflow.ellipsis,
    );
  }
}