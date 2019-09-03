import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_manager/tab_pages.dart';
import 'package:time_manager/material_data.dart';
import 'package:time_manager/data.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/theme.dart';
import 'package:time_manager/routing.dart';
import 'package:fluro/fluro.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  Widget _tabBodyWidget = CurrentProjectsTab();

  void _selectedTab(int index) {
    setState(() {
      _setTabBody(index);
    });
  }

  void _setTabBody(int index) {
    switch (index) {
      case 0:
        _tabBodyWidget = CurrentProjectsTab();
        break;
      case 1:
        _tabBodyWidget = AvailableProjectsTab();
        break;
      case 2:
        _tabBodyWidget = CompletedProjectsTab();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Time Manager'),
      appBarActions: <Widget>[
        IconButton(
          padding: const EdgeInsets.all(5),
          icon: Icon(Icons.settings),
          iconSize: 30,
          onPressed: () {
            Routing.navigateTo(context, Routing.settingsRoute, transition: TransitionType.inFromRight);
          },
          splashColor: ThemeColors.highlightedData,
          color: Colors.white,

        ),
      ],
      body: _tabBodyWidget,
      floatingActionButton: FloatingActionButtonWidget(),
      bottomNavigationBar: BottomAppBarWidget(
        color: ThemeColors.unselectedButtonColor,
        selectedColor: ThemeColors.highlightedData,
        onTabSelected: _selectedTab,
        items: [
          BottomAppBarTab(icon: Icons.timelapse, text: 'ASSIGNED'),
          BottomAppBarTab(icon: Icons.event_available, text: 'AVAILABLE'),
          BottomAppBarTab(icon: Icons.history, text: 'COMPLETED'),
        ],
        //Tabs
        backgroundColor: ThemeColors.appMain,
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  AppScaffold(
      {@required this.appBarTitle,
      @required this.body,
      this.appBarActions,
        this.appBarLeading,
      this.floatingActionButton,
      this.bottomNavigationBar,
        this.persistentBottomSheet,
      this.resizeToAvoidBottomInset = false});

  final Widget appBarTitle;
  final List<Widget> appBarActions;
  final Widget appBarLeading;
  final Widget body;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final Widget persistentBottomSheet;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        leading: appBarLeading,
        backgroundColor: ThemeColors.appMain,
        actions: appBarActions,
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: persistentBottomSheet,
    );
  }
}

class FloatingActionButtonWidget extends StatefulWidget {
  FloatingActionButtonWidget({Key key}) : super(key: key);

  //combine this with a bottom navigation bar is a bottomAppBar for a notch in the bottom bar
  final floatingActionButtonLocation =
      FloatingActionButtonLocation.centerDocked;

  @override
  _FloatingActionButtonWidgetState createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState
    extends State<FloatingActionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => setState(() {
        Routing.navigateTo(context, "${Routing.projectAddRoute}/1", transition: TransitionType.inFromRight);
      }),
      tooltip: 'Add a new Work Item',
      child: Icon(
        Icons.add,
        size: 27,
      ),
      backgroundColor: ThemeColors.highlightedData,
      foregroundColor: ThemeColors.unselectedButtonColor,
    );
  }
}

class BottomAppBarWidget extends StatefulWidget {
  BottomAppBarWidget(
      {this.items,
      this.height: 60.0,
      this.iconSize: 25.0,
      this.backgroundColor,
      this.color,
      this.selectedColor,
      this.notchedShape,
      this.onTabSelected}) {
    assert(this.items.length == 3); //want to enforce there to be 3 tabs
  }

  final List<BottomAppBarTab> items;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  State<StatefulWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    return BottomAppBar(
        shape: widget.notchedShape,
        color: widget.backgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items,
        ));
  }

  Widget _buildTabItem(
      {BottomAppBarTab item, int index, ValueChanged<int> onPressed}) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
      height: widget.height,
      child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          )),
    ));
  }
}

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  ProjectDetailPage(String id) :
    project = getProjectByID(id);

  final _formKey = GlobalKey<FormState>();

  Widget _buildProjectForm(BuildContext context) {
    return ThemeForm.buildForm(
      formKey: _formKey,
      listViewChildren: <Widget>[
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeForm.buildFormFieldDropdown(
              enabled: false,
              labelText: 'application',
              value: project.applicationName,
              options: ApplicationNames.options,
            ),
            ThemeForm.buildFormFieldDropdown(
              enabled: false,
              labelText: 'status',
              value: project.status,
              options: StatusTypes.options,
            ),
          ]
        ),
        ThemeInput.textFormField(
          enabled: false,
          label: 'Name',
          initialValue: project.name,
        ),
        ThemeInput.textFormField(
          enabled: false,
          label: 'Details',
          initialValue: project.details,
          maxLines: 2,
        ),
        ThemeInput.dateTimeField(
          enabled: false,
          context: context,
          label: 'started',
        ),
        ThemeInput.dateTimeField(
          enabled: false,
          context: context,
          label: 'completed',
        ),
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeInput.intFormField(
              initialValue: project.workItemCount.toString(),
              enabled: false,
              label: 'work items',
            ),
            ThemeInput.textFormField(
              label: 'total hours',
              initialValue: shortDurationFormat(project.totalHours),
              enabled: false,
            ),
          ]
        ),
      ]
    );
  }

  Widget _buildAppBody(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: _buildProjectForm(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Project Details'),
      appBarActions: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          child: Icon(Icons.edit),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          child: Icon(Icons.delete_forever),
        ),
      ],
      body: _buildAppBody(context),
    );
  }
}

class ProjectEditPage extends StatefulWidget {
  final Project project;

  ProjectEditPage(String id) :
    project = getProjectByID(id);

  _ProjectEditPageState createState() => _ProjectEditPageState();
}

class _ProjectEditPageState extends State<ProjectEditPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Widget _getEditForm(BuildContext context) {
    return ThemeForm.buildForm(
      formKey: _formKey,
      listViewChildren: <Widget>[
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeForm.buildFormFieldDropdown(
              labelText: 'application',
              value: widget.project.applicationName,
              options: ApplicationNames.options,
              onChangedFunc: (String value) {
                setState(() {
                  widget.project.applicationName = value;
                });
              }
            ),
            ThemeForm.buildFormFieldDropdown(
              labelText: 'status',
              value: widget.project.status,
              options: StatusTypes.options,
              onChangedFunc: (String value){
                setState(() {
                  widget.project.status = value;
                });
              }
            ),
          ]
        ),
        ThemeInput.textFormField(
          label: 'Name',
          //initialValue: widget.project.name,
          validatorFunc: (val) {
            if (val.isEmpty) {
              return 'errors';
            } else {
              return null;
            }
          }),
        ThemeInput.textFormField(
          label: 'Details',
          initialValue: widget.project.details,
          maxLines: 2,
          validatorFunc: (val) {
            if (val.isEmpty) {
              return 'errors';
            } else {
              return null;
            }
          }),
        ThemeInput.dateTimeField(
          context: context,
          label: 'started',
        ),
        ThemeInput.dateTimeField(
          context: context,
          label: 'completed',
        ),
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeInput.intFormField(
              initialValue: widget.project.workItemCount.toString(),
              enabled: false,
              label: 'work items',
            ),
            ThemeInput.textFormField(
              label: 'total hours',
              initialValue: shortDurationFormat(widget.project.totalHours),
              enabled: false,
            ),
          ]
        ),
      ]
    );
  }

  Widget _buildContents(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: _getEditForm(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Edit Project'),
      appBarActions: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          child: Icon(Icons.delete_forever),
        )
      ],
      body: _buildContents(context),
    );
  }
}

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
        height: 200,
      ),
    );
  }
}

class ProjectAddPage extends StatefulWidget {
  final Project project;

  ProjectAddPage(String applicationID):
    project = Project.newProject(applicationID: 1);

  _ProjectAddPageState createState() => _ProjectAddPageState();
}

class _ProjectAddPageState extends State<ProjectAddPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Widget _getEditForm(BuildContext context) {
    return ThemeForm.buildForm(
      formKey: _formKey,
      listViewChildren: <Widget>[
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeForm.buildFormFieldDropdown(
              labelText: 'application',
              value: ApplicationNames.options[0],
              options: ApplicationNames.options,
              onChangedFunc: (String value) {
                setState(() {
                  widget.project.applicationName = value;
                });
              }
            ),
            ThemeForm.buildFormFieldDropdown(
              labelText: 'status',
              value: StatusTypes.options[0],
              options: StatusTypes.options,
              onChangedFunc: (String value){
                setState(() {
                  widget.project.status = value;
                });
              }
            ),
          ]
        ),
        ThemeInput.textFormField(
          label: 'Name',
          validatorFunc: (val) {
            return null;
          }
        ),
        ThemeInput.textFormField(
          label: 'Details',
          maxLines: 2,
          validatorFunc: (val) {
            return null;
          }),
        ThemeInput.dateTimeField(
          context: context,
          label: 'started',
        ),
        ThemeInput.dateTimeField(
          context: context,
          label: 'completed',
        ),
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeInput.intFormField(
              initialValue: "0",
              enabled: false,
              label: 'work items',
            ),
            ThemeInput.textFormField(
              label: 'total hours',
              initialValue: "0",
              enabled: false,
            ),
          ]
        ),
      ]
    );
  }

  Widget _buildContents(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: _getEditForm(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Add Project'),
      appBarActions: <Widget>[
        IconButton(
          padding: const EdgeInsets.all(5),
          icon: Icon(Icons.add_box),
          iconSize: 30,
          splashColor: ThemeColors.highlightedData,
          color: Colors.white,
          onPressed: (){
            //do something
          },
        )
      ],
      body: _buildContents(context),
      persistentBottomSheet: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 75,
              child: Container(
                padding: const EdgeInsets.all(5),
                color: ThemeColors.appMain,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {

                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: ThemeColors.highlightedData, size: 40),
                        Text('ADD',
                          style: TextStyle(
                            color: ThemeColors.highlightedData,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      ],
                    ),
                  )
                ),
              )
            ),
          )
        ],
      )
    );
  }
}
