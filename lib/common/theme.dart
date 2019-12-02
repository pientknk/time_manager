import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:time_manager/common/data_utils.dart';
import 'package:flutter/services.dart';
import 'package:time_manager/view/options_page.dart';
import 'package:time_manager/model/common/abstracts.dart';

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

  static TextStyle headerText(Color color){
    return TextStyle(
      fontFamily: mainFont,
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: color ?? ThemeColors.headerText,
    );
  }

  static const TextStyle commonText = const TextStyle(
    fontFamily: mainFont,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: ThemeColors.mainText,
  );

  static TextStyle commonBoldText(Color color){
    return TextStyle(
      fontFamily: mainFont,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color ?? ThemeColors.mainText,
    );
  }
}

class ThemeText {
  const ThemeText();

  static Text appBarText(String text) {
    return Text(text.toUpperCase(),
      maxLines: 2,
    );
  }

  static AutoSizeText headerText({@required String text, Color color}) {
    return AutoSizeText(text,
      style: ThemeTextStyles.headerText(color),
      maxLines: 2,
      minFontSize: 18,
      textAlign: TextAlign.left,
      semanticsLabel: 'n/a',
      overflow: TextOverflow.ellipsis,
    );
  }

  static AutoSizeText commonText(String text) {
    return AutoSizeText(text,
      style: ThemeTextStyles.commonText,
      maxLines: 1,
      minFontSize: 16,
      textAlign: TextAlign.left,
      semanticsLabel: 'n/a',
      overflow: TextOverflow.ellipsis,
    );
  }

  static Text commonTextMultiline(String text){
    return Text(text,
      style: ThemeTextStyles.commonText,
      maxLines: 2,
      textAlign: TextAlign.left,
      semanticsLabel: 'n/a',
      overflow: TextOverflow.ellipsis,
    );
  }

  static AutoSizeText commonHeaderText({@required String text, Color color}) {
    return AutoSizeText(text,
      style: ThemeTextStyles.commonBoldText(color),
      maxLines: 2,
      minFontSize: 16,
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

  static _fieldFocusChange(BuildContext context, FocusNode currentFocusNode,FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

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
    Function(DateTime) onChangedFunc, TextEditingController textEditingController, TextInputAction textInputAction, FocusNode currentFocusNode,
    FocusNode nextFocusNode, FormFieldValidator<DateTime> validatorFunc, FormFieldSetter<DateTime> onSavedFunc}) {
    return _inputContainer(
      child: DateTimeField(
        onSaved: onSavedFunc,
        focusNode: currentFocusNode,
        textInputAction: textInputAction,
        onFieldSubmitted: (_) {
          _fieldFocusChange(context, currentFocusNode, nextFocusNode);
        },
        validator: validatorFunc,
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

  static Container intFormField({String label, FormFieldValidator<String> validatorFunc, bool enabled = true,
    BuildContext context, FocusNode currentFocusNode, FocusNode nextFocusNode, TextInputAction textInputAction, TextInputType textInputType,
    TextEditingController controller}) {
    return _inputContainer(
      child: TextFormField(
        controller: controller,
        style: ThemeTextStyles.formText,
        textInputAction: textInputAction,
        validator: validatorFunc,
        focusNode: currentFocusNode,
        enabled: enabled,
        maxLines: 1,
        keyboardType: textInputType,
        cursorColor: ThemeColors.highlightedData,
        decoration: inputDecoration(label),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        onFieldSubmitted: (_) {
          _fieldFocusChange(context, currentFocusNode, nextFocusNode);
        },
      )
    );
  }
  
  static Container optionsSelector<T>({@required Options initialValue, String label, FormFieldValidator<String> validatorFunc,
    @required TextEditingController controller, @required BuildContext context, String title, List<Options> options}){
    OptionsPage optionsPage = OptionsPage(
      options: options,
      title: title,
      selectedOption: initialValue,
    );
    return _inputContainer(
      child: TextFormField(
        controller: controller,
        style: ThemeTextStyles.formText,
        validator: validatorFunc,
        enabled: true,
        maxLines: 1,
        cursorColor: ThemeColors.highlightedData,
        decoration: inputDecoration(label),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder:
            (context) => optionsPage
            )
          )..then((val){
            controller.text = optionsPage.selectedOption.name;
            //controller.text = initialValue == null ? "" : initialValue.name;
          });
        },
      ),

      /*Card(
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            leading: Container(
              padding: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(width: 1, color: Colors.white24))),
              child: Icon(Icons.description, color: ThemeColors.highlightedData,),
            ),
            title: Text("Option",
              style: ThemeTextStyles.commonText,
            ),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.linear_scale),
                Text("More info about this"),
              ],
            ),
            trailing: Icon(Icons.accessibility, color: ThemeColors.highlightedData,),
          ),
        ),
      )*/
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

  static Container textFormField({@required String label, String initialValue, FormFieldValidator<String> validatorFunc, bool enabled = true,
    int maxLines = 1, BuildContext context, FocusNode currentFocusNode, FocusNode nextFocusNode, TextInputAction textInputAction,
    TextInputType textInputType, TextEditingController controller}) {
    return _inputContainer(
      child: TextFormField(
        controller: controller,
        style: ThemeTextStyles.formText,
        initialValue: initialValue,
        validator: validatorFunc,
        enabled: enabled,
        maxLines: maxLines,
        cursorColor: ThemeColors.highlightedData,
        decoration: inputDecoration(label),
        textInputAction: textInputAction,
        focusNode: currentFocusNode,
        onFieldSubmitted: (_) {
          _fieldFocusChange(context, currentFocusNode, nextFocusNode);
        },
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

  static Widget buildFormFieldDropdown({String labelText, String value, ValueChanged<String> onChangedFunc, List<String> options,
    bool enabled = true}) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.unselectedButtonColor)
    );

    return FormField<String>(
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: ThemeColors.card,
      child: Form(
        key: formKey,
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
              return Divider(height: 6);
            },
            itemCount: listViewChildren.length,
          ),
        ),
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

class ThemeIconButtons {
  const ThemeIconButtons();

  static IconButton buildIconButton({@required IconData iconData, double iconSize = 30, Color color = ThemeColors.unselectedButtonColor,
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

class ThemeIcon {
  const ThemeIcon();

  static Icon lightIcon({@required IconData iconData, double size = 30}){
    return Icon(iconData,
      color: Colors.white,
      size: size,
    );
  }
}

///TODO: look into flushbar in the pub for a cool feature for notifications