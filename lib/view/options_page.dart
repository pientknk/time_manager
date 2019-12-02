import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/model/common/abstracts.dart';

class OptionsPage extends StatefulWidget {
  final String title;
  final List<Options> options;
  final Options selectedOption;

  OptionsPage({Key key, this.options, this.title, this.selectedOption});

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText(widget.title),
      appBarActions: <Widget>[
        IconButton(
          padding: const EdgeInsets.all(5),
          icon: Icon(Icons.add_box),
          iconSize: 30,
          splashColor: ThemeColors.highlightedData,
          color: Colors.white,
          onPressed: (){
            //add a new one?
          },
        )
      ],
      body: Container(
        child: ListView.builder(
          itemCount: widget.options.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
            Options option = widget.options.elementAt(index);
            return Card(
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(51, 51, 51, .9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 10, top: 5, right: 0, bottom: 5),
                  /*leading: Container(
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(width: 1, color: Colors.lightBlue[400]))),
                    child: Icon(Icons.description, color: Colors.white70,),
                  ),*/
                  title: ThemeText.headerText(text: option.name ?? "No Name", color: ThemeColors.highlightedData),
                  subtitle: ThemeText.commonTextMultiline(option.description ?? "No Description"),
                  isThreeLine: true,
                  trailing: ThemeIconButtons.buildIconButton(
                    iconData: Icons.delete,
                    color: Colors.redAccent,
                    iconSize: 25,
                    onPressedFunc: (){
                      //delete it i guess and refresh list?
                    }
                  ),
                  onTap: (){
                    widget.selectedOption.name = option.name;
                    widget.selectedOption.description = option.description;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        )
      ),
      persistentBottomSheet: appScaffoldBottomSheet(context),
    );
  }

  AppScaffoldBottomSheet appScaffoldBottomSheet(BuildContext context){
    return AppScaffoldBottomSheet(
      iconData: Icons.arrow_back,
      iconText: 'BACK',
      onTapFunc: ()
      {
        Navigator.of(context).pop();
      }
    );
  }
}