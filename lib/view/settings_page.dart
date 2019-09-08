import 'package:flutter/material.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/model/data.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Settings settings;
  @override
  void initState() {
    //TODO: set fields on settings
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Settings'),
      appBarActions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings_backup_restore),
          iconSize: 30,
          padding: const EdgeInsets.all(5),
          onPressed: () {
            //reset settings
          },
          color: Colors.white,
          tooltip: 'Restores Settings to default',
        )
      ],
      body: Container(
        color: Colors.black,
        height: 400,
      ),
    );
  }
}