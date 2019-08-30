import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_manager/tab_pages.dart';
import 'package:time_manager/material_data.dart';
import 'package:time_manager/data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/theme.dart';
import 'package:time_manager/data.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
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
        Container(
          padding: const EdgeInsets.all(5),
          child: Icon(Icons.settings),
        )
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
      {this.appBarTitle,
      this.appBarActions,
      this.body,
      this.floatingActionButton,
      this.bottomNavigationBar});

  final Widget appBarTitle;
  final List<Widget> appBarActions;
  final Widget body;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        backgroundColor: ThemeColors.appMain,
        actions: appBarActions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: bottomNavigationBar,
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
        //push add view
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

///TODO: this could probably be a stateless widget since nothing on it updates while the user is looking at this screen (for now)
class ProjectCard extends StatefulWidget {
  ProjectCard({
    Key key,
    this.project,
    //this.color,
    //this.splashColor,
    //this.textColor = Colors.white,
    //this.margin,
    //this.text
  }) : super(key: key);

  final Project project;

  //final Color color;
  //final Color splashColor;
  //final Color textColor;
  //final EdgeInsetsGeometry margin;
  //final String text;

  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final _headerTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  Widget _buildHeaderText(String text) {
    return Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.grey[900], width: 3))),
        child: Center(
          child: AutoSizeText(
            text,
            style: _headerTextStyle,
            maxLines: 2,
            minFontSize: 14,
            textAlign: TextAlign.center,
            semanticsLabel: 'n/a',
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }

  final _infoTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: Colors.grey[100],
  );

  Widget _buildInfoText(String text) {
    return Container(
      child: AutoSizeText(
        text,
        style: _infoTextStyle,
        minFontSize: 11,
        maxLines: 4,
        textAlign: TextAlign.center,
        semanticsLabel: 'n/a',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  final _labelTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  Widget _buildLabelText(String text) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: AutoSizeText(
        text.toUpperCase(),
        style: _labelTextStyle,
        minFontSize: 10,
        maxLines: 1,
        semanticsLabel: 'n/a',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  final _dataTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.green,
  );

  Widget _buildDataText(String text) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: AutoSizeText(
        text,
        style: _dataTextStyle,
        maxLines: 1,
        minFontSize: 11,
        semanticsLabel: 'n/a',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  //longest project name allowed: 50
  Widget _buildProjectName() {
    return Expanded(flex: 0, child: _buildHeaderText(widget.project.name));
  }

  Widget _buildProjectName2() {
    return Expanded(
        flex: 1,
        child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[900], width: 3))),
            child: Center(
              child: AutoSizeText(
                widget.project.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 3,
                minFontSize: 16,
                textAlign: TextAlign.center,
                semanticsLabel: 'n/a',
                overflow: TextOverflow.ellipsis,
              ),
            )));
  }

  //longest project description allowed: 120 chars
  Widget _buildProjectDescription() {
    return Expanded(flex: 0, child: _buildInfoText(widget.project.details));
  }

  Widget _buildHoursAndWorkItemsColumn() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Expanded(
            child: _buildProjectColumn(
                'Hours', shortDurationFormat(widget.project.totalHours)),
          ),
          Expanded(
            child: _buildProjectColumn(
                'Items', widget.project.workItemCount.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursAndWorkItemsColumn2() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: AutoSizeText(
                        'HOURS:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        minFontSize: 13,
                        maxLines: 1,
                        semanticsLabel: 'n/a',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: AutoSizeText(
                        shortDurationFormat(widget.project.totalHours),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                        maxLines: 1,
                        minFontSize: 14,
                        semanticsLabel: 'n/a',
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: AutoSizeText(
                        'ITEMS:',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        minFontSize: 13,
                        maxLines: 1,
                        semanticsLabel: 'n/a',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: AutoSizeText(
                        widget.project.workItemCount.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                        maxLines: 1,
                        minFontSize: 14,
                        semanticsLabel: 'n/a',
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectColumn(String label, String dataText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flex(
          direction: Axis.vertical,
          children: <Widget>[_buildLabelText(label), _buildDataText(dataText)],
        )
      ],
    );
  }

  Widget _buildProjectRow(String label, String dataText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            _buildLabelText('$label:'),
            _buildDataText(dataText),
          ],
        )
      ],
    );
  }

  Widget _buildProjectRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2),
              child: AutoSizeText(
                'STARTED:',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                minFontSize: 13,
                maxLines: 1,
                semanticsLabel: 'n/a',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              child: AutoSizeText(
                veryShortDateFormat(widget.project.startedTime),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
                maxLines: 1,
                minFontSize: 14,
                semanticsLabel: 'n/a',
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        )
      ],
    );
  }

  List<Widget> _getCard1() {
    return [
      _buildProjectName(),
      _buildProjectDescription(),
      _buildHoursAndWorkItemsColumn(),
      _buildProjectRow(
          'Started', veryShortDateFormat(widget.project.startedTime)),
      _buildProjectRow('Finished', veryShortDateFormat(DateTime(2019, 10, 27))),
    ];
  }

  List<Widget> _getCard2() {
    return [
      _buildProjectName2(),
      _buildHoursAndWorkItemsColumn2(),
      _buildProjectRow2(),
    ];
  }

  Widget _buildCard() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.min,
            children: _getCard2(),
          ),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          child: _buildCard(),
          //splashColor: widget.splashColor,
        ),
      ),
      color: Colors.grey[850],
      margin: const EdgeInsets.all(2.5),
      elevation: 5.0,
    );
  }
}

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  ProjectDetailScreen(this.project);

  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
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
              value: widget.project.applicationName,
              options: ApplicationNames.options,
              onChangedFunc: (String value) {
                setState(() {
                  widget.project.applicationName = value;
                });
              }
            ),
            ThemeForm.buildFormFieldDropdown(
              enabled: false,
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
          enabled: false,
          label: 'Name',
          initialValue: widget.project.name,
        ),
        ThemeInput.textFormField(
          enabled: false,
          label: 'Details',
          initialValue: widget.project.details,
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

class ProjectEditScreen extends StatefulWidget {
  ProjectEditScreen({Key key, this.project}) : super(key: key);

  final Project project;

  _ProjectEditScreenState createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends State<ProjectEditScreen> {
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
