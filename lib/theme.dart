import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ThemeColors{
  const ThemeColors();

  static const Color appMain = const Color(0xFF0F0F0F);
  static const Color card = const Color(0xFF333333);
  static const Color cardAccent = const Color(0xFF7A7A7A);
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

  static const TextStyle formText = const TextStyle(
    fontFamily: mainFont,
    fontSize: 18,
    fontWeight: FontWeight.w500,
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

  static Text appBarText(String text) {
    return Text(text.toUpperCase(),
      maxLines: 2,
    );
  }

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

class ThemeInput {
  const ThemeInput();

  static Container dropdownButtonHideUnderline({@required String originalValue, @required List<String> items, ValueChanged<String> onChangedFunc}){
    final List<DropdownMenuItem<String>> _dropDownMenuItems = List.generate(items.length, (index) {
      return DropdownMenuItem<String>(
        value: items[index],
        child: Text(items[index])
      ) ;
    });

    return Container(
      margin: const EdgeInsets.all(3),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: originalValue,
          items: _dropDownMenuItems,
          onChanged: onChangedFunc,
          elevation: 4,
          isDense: true,
          style: ThemeTextStyles.formText,
        ),
      ),
    );
  }

  static Container textFormField({@required String label, String initialValue, FormFieldValidator<String> validatorFunc, bool enabled = true}) {
    final _outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.unselectedButtonColor)
    );
    return Container(
      margin: const EdgeInsets.all(3),
      child: TextFormField(
        style: ThemeTextStyles.formText,
        initialValue: initialValue,
        validator: validatorFunc,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label.toUpperCase(),
          enabledBorder: _outlineInputBorder,
          border: _outlineInputBorder
        ),
      ),
    );
  }

  static SwitchListTile switchTileList({@required String label, @required bool value, @required ValueChanged<bool> onChangedFunc}){
    return SwitchListTile(
      title: Text(label),
      activeColor: Colors.green,
      value: value,
      onChanged: onChangedFunc,
    );
  }

  static CheckboxListTile checkboxListTile({@required String label, @required bool value, @required ValueChanged<bool> onChangedFunc}){
    return CheckboxListTile(
      title: Text(label),
      activeColor: Colors.green,
      value: value,
      onChanged: onChangedFunc,
    );
  }

  static RaisedButton raisedButton({@required String label, @required VoidCallback onPressedFunc}){
    return RaisedButton(
      onPressed: onPressedFunc,
      color: Colors.teal,
      child: Text(label),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
    );
  }
}

class ThemeSnackBar {
  const ThemeSnackBar();

  static void showSnackBar({@required BuildContext context, @required Widget contents}){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: contents,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8))
        ),
      )
    );
  }
}