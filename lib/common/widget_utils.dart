import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/common/theme.dart';

class DropdownTextField extends StatefulWidget {
  final String label;
  DropdownTextField({Key key, this.label}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DropdownTextFieldState();
}

class DropdownTextFieldState extends State<DropdownTextField> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  Widget buildDropdownTextField() {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextFormField(

            ),
          ),
          /*Expanded(
            flex: 4,
            child: ThemeInput.textFormField(
              enabled: true,
              context: ,
              currentFocusNode: ,
              nextFocusNode: ,
              textInputAction: ,
              initialValue: ,
              label: null,
              textInputType: ,
            ),
          ),*/
          /*Expanded(
            flex: 1,
            child: ,
          ),*/
        ],
      ),
    );
  }
}