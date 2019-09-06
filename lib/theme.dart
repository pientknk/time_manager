import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:time_manager/helpers.dart';

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

  static Container _inputContainer({Widget child}) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: child,
    );
  }

  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: ThemeColors.unselectedButtonColor)
  );

  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label.toUpperCase(),
      enabledBorder: outlineInputBorder,
      border: outlineInputBorder
    );
  }

  static Container datePickerFormField({BuildContext context}) {
    return _inputContainer(
      child: FlatButton(
        onPressed: () {
          DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(2000, 1, 1),
            maxTime: DateTime(2022, 12, 31),
          onChanged: (date) {
            print('change $date');
          },
          onConfirm: (date) {
            print('confirm $date');
          },
          currentTime: DateTime.now(), locale: LocaleType.en);},
        child: Text('Show DateTime Picker',)
      )
    );
  }

  static Container dateTimeFieldBasicDate({BuildContext context}) {
    return _inputContainer(
      child: DateTimeField(
        format: DateFormat(veryShortDateFormatString),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        },
      ),
    );
  }

  static Container dateTimeFieldBasicTime({BuildContext context}) {
    return _inputContainer(
      child: DateTimeField(
        format: DateFormat("hh:mm a"),
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
    );
  }

  static Container dateTimeField({BuildContext context, DateFormat format, DateTime originalValue, String label, bool enabled = true,
    Function(DateTime) onChangedFunc, TextEditingController textEditingController}) {
    return _inputContainer(
      child: DateTimeField(
        enabled: enabled,
        controller: textEditingController,
        style: ThemeTextStyles.formText,
        decoration: inputDecoration(label),
        initialValue: originalValue,
        format: format ?? DateFormat(detailedDateFormatString), //DateFormat(detailedDateFormatWithSecondsString),
        onChanged: onChangedFunc,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime(2019)),
            );
            DateTime combined = DateTimeField.combine(date, time);
            return combined;
          } else {
            return currentValue;
          }
        },
      ),
    );
  }

  static Container intFormField({String label, String initialValue, FormFieldValidator<String> validatorFunc, bool enabled = true}) {
    return _inputContainer(
      child: TextFormField(
        style: ThemeTextStyles.formText,
        initialValue: initialValue,
        validator: validatorFunc,
        enabled: enabled,
        maxLines: 1,
        cursorColor: ThemeColors.highlightedData,
        decoration: inputDecoration(label),
        keyboardType: TextInputType.number,
      )
    );
  }

  static Container dropdownButtonHideUnderline({@required String originalValue, @required List<String> items, ValueChanged<String> onChangedFunc, bool enabled = true}){
    final List<DropdownMenuItem<String>> _dropDownMenuItems = List.generate(items.length, (index) {
      return DropdownMenuItem<String>(
        value: items[index],
        child: Text(items[index]),
      ) ;
    });

    return _inputContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          iconDisabledColor: Colors.grey,
          disabledHint: Text(originalValue, style: ThemeTextStyles.formText),
          value: originalValue,
          items: enabled ? _dropDownMenuItems : null,
          onChanged: onChangedFunc,
          elevation: 4,
          isDense: true,
          style: ThemeTextStyles.formText,
        ),
      ),
    );
  }

  static Container textFormField({@required String label, String initialValue, FormFieldValidator<String> validatorFunc,
    bool enabled = true, int maxLines}) {
    return _inputContainer(
      child: TextFormField(
        style: ThemeTextStyles.formText,
        initialValue: initialValue ?? '',
        validator: validatorFunc,
        enabled: enabled,
        maxLines: maxLines ?? 1,
        cursorColor: ThemeColors.highlightedData,
        decoration: inputDecoration(label)
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

class ThemeForm {
  const ThemeForm();

  static Widget buildFormFieldDropdown({String labelText, String value, ValueChanged<String> onChangedFunc, List<String> options, bool enabled = true}) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.unselectedButtonColor));

    return FormField(
      enabled: enabled,
      builder: (FormFieldState state) {
        return Container(
          margin: const EdgeInsets.all(2),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText.toUpperCase(),
              labelStyle: enabled ? null : TextStyle(color: Colors.grey),
              isDense: true,
              enabledBorder: outlineInputBorder,
              border: outlineInputBorder),
            isEmpty: value == '',
            child: ThemeInput.dropdownButtonHideUnderline(
              originalValue: value,
              items: options,
              onChangedFunc: onChangedFunc,
              enabled: enabled
            )
          ),
        );
      },
    );
  }

  static Widget buildFormRowFromFields({Iterable<Widget> children}){
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children.map((childWidget){
          return Expanded(
            child: childWidget,
          );
        }).toList(),
      ),
    );
  }

  static Widget buildForm({@required GlobalKey<FormState> formKey, @required List<Widget> listViewChildren}){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: ThemeColors.card,
      child: Form(
        key: formKey,
        autovalidate: true,
        child: Theme(
          data: ThemeData(
            primaryColor: ThemeColors.highlightedData,
            hintColor: Colors.cyan[200],
            disabledColor: Colors.grey,
          ),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index){
              return listViewChildren[index];
            },
            separatorBuilder: (BuildContext context, int index){
              return Divider(height: 5);
            },
            itemCount: listViewChildren.length,
          ),
        )),
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

class ThemeIconButtons {
  const ThemeIconButtons();

  static IconButton buildIconButton({IconData iconData, double iconSize = 30, Color color = ThemeColors.unselectedButtonColor,
    Color splashColor = ThemeColors.highlightedData, VoidCallback onPressedFunc}) {
    return IconButton(
      padding: const EdgeInsets.all(5),
      icon: Icon(iconData),
      iconSize: iconSize,
      color: color,
      onPressed: onPressedFunc,
      splashColor: splashColor,
    );
  }
}