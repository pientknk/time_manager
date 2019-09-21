import 'package:flutter/material.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/model/data_samples.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/data_utils.dart';
import 'package:time_manager/common/routing.dart';
import 'package:fluro/fluro.dart';
import 'package:time_manager/common/modal_route.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flushbar/flushbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:time_manager/view/work_item_page.dart';
import 'package:time_manager/common/more_options_popup_menu.dart';

class ProjectAddPage extends StatefulWidget {
  final Project project;

  ProjectAddPage(String applicationID):
      project = Project.newProject(applicationId: int.parse(applicationID));

  _ProjectAddPageState createState() => _ProjectAddPageState();
}

class _ProjectAddPageState extends State<ProjectAddPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

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
      body: ProjectForm(
        formKey: _formKey,
        project: widget.project,
      ),
      persistentBottomSheet: AppScaffoldBottomSheet(
        iconData: Icons.add,
        iconText: 'add',
        onTapFunc: () {

        }
      )
    );
  }
}

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  ProjectDetailPage(String id) :
      project = DataSamples.getProjectByIdString(id);

  final _formKey = GlobalKey<FormState>();

  Widget getFlushBar(BuildContext context){
    return Flushbar<List<String>>(
      userInputForm: Form(
        key: _formKey,
        child: ListView.builder(
          itemExtent: 50,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index){
            return Container(color: Colors.blue[300], child: Text('item $index'));
          }
        ),
      ),
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: 'hi im a title',
      icon: Icon(Icons.map),
      onTap: null,
    )..show(context);
  }

  Widget _floatingCollapsed({@required int numWorkItems}){
    return _floatingHeader(numWorkItems: numWorkItems);
  }

  Widget _floatingHeader({@required int numWorkItems}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ThemeIcon.lightIcon(iconData: Icons.drag_handle),
              ThemeIcon.lightIcon(iconData: Icons.drag_handle),
              ThemeIcon.lightIcon(iconData: Icons.drag_handle),
            ],
          ),
          Center(
            child: ThemeText.headerText("Work Items ($numWorkItems)"),
          ),
        ],
      )
    );
  }

  Widget _floatingPanel(List<WorkItem> workItems){
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          _floatingHeader(numWorkItems: workItems.length),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: workItems.length,
                itemBuilder: (BuildContext context, int i){
                  return WorkItemCard(workItem: workItems[i]);
                },
              ),
            )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<WorkItem> _workItems = DataSamples.getAllWorkItemsForProject(project.projectId);

    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Project Details'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.edit,
          onPressedFunc: () {
            Routing.navigateTo(context, "${Routing.projectEditRoute}/${project.projectId}");
          }
        ),
        ThemeIconButtons.buildIconButton(
          iconData: Icons.delete_forever,
          onPressedFunc: () {
            Navigator.pop(context);
            //delete it I guess?
          }
        ),
      ],
      body: SlidingUpPanel(
        maxHeight: 600,
        backdropEnabled: true,
        backdropOpacity: 0.35,
        renderPanelSheet: false,
        panel: _floatingPanel(_workItems),
        collapsed: _floatingCollapsed(numWorkItems: _workItems.length),
        body: ProjectForm(
          formKey: _formKey,
          project: project,
        ),
      ),
      floatingActionButton: AppScaffoldFAB(
        route: "${Routing.workItemAddRoute}/${project.projectId}",
        tooltip: 'Add a Work Item',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ProjectEditPage extends StatefulWidget {
  final Project project;

  ProjectEditPage(String id) :
      project = DataSamples.getProjectByIdString(id);

  _ProjectEditPageState createState() => _ProjectEditPageState();
}

class _ProjectEditPageState extends State<ProjectEditPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Edit Project'),
      appBarActions: <Widget>[
        IconButton(
          padding: const EdgeInsets.all(5),
          icon: Icon(Icons.delete_forever),
          iconSize: 30,
          color: Colors.white,
          splashColor: ThemeColors.highlightedData,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
      body: ProjectForm(
        formKey: _formKey,
        project: widget.project,
        enabled: true,
      ),
    );
  }
}

class ProjectForm extends StatefulWidget{
  ProjectForm({@required this.formKey, @required this.project, this.enabled = false});

  final Project project;
  final GlobalKey<FormState> formKey;
  ///false by default to ensure readonly fields
  final bool enabled;

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildProjectForm(
      context: context,
      enabled: widget.enabled,
    );
  }

  Widget _buildProjectForm({BuildContext context, bool enabled}) {
    return ThemeForm.buildForm(
      formKey: widget.formKey,
      listViewChildren: <Widget>[
        ThemeInput.intFormField(
          enabled: widget.enabled,
          label: 'priority',
          initialValue: widget.project.priority?.toString() ?? "9999",
        ),
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeForm.buildFormFieldDropdown(
              enabled: enabled,
              labelText: 'application',
              value: widget.project.applicationId?.toString() ?? "n/a",
              options: ApplicationNames.options,
            ),
            ThemeForm.buildFormFieldDropdown(
              enabled: enabled,
              labelText: 'status',
              value: widget.project.status ?? "n/a",
              options: StatusTypes.options,
            ),
          ]
        ),
        ThemeInput.textFormField(
          enabled: enabled,
          label: 'Name',
          initialValue: widget.project.name ?? "n/a",
        ),
        ThemeInput.textFormField(
          enabled: enabled,
          label: 'Details',
          initialValue: widget.project.details ?? "n/a",
          maxLines: 2,
        ),
        ThemeInput.dateTimeField(
          enabled: enabled,
          context: context,
          label: 'started',
          originalValue: widget.project.startedTime,
          format: DateFormat(detailedDateFormatWithSecondsString),
        ),
        ThemeInput.dateTimeField(
          enabled: enabled,
          context: context,
          label: 'completed',
          originalValue: widget.project.completedTime,
          format: DateFormat(detailedDateFormatWithSecondsString),
        ),
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeInput.intFormField(
              initialValue: widget.project.workItemCount?.toString() ?? "0",
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
}

class ProjectCard extends StatelessWidget{
  final Project project;

  ProjectCard({Key key, this.project}) : super(key: key);

  Widget _buildHeader(String text){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ThemeText.headerText(text)
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
          height: 2,
          color: ThemeColors.lineSeparator,
        )
      ],
    );
  }

  Widget _buildLabelAndData(String label, String dataText){
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ThemeText.labelText(label)
            ),
            Expanded(
              flex: 1,
              child: ThemeText.highlightedText(dataText)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(){
    return Container(
      margin: const EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildLabelAndData('Hours', shortDurationFormat(project.totalHours)),
          _buildLabelAndData('Items', project.workItemCount.toString()),
          _buildLabelAndData('Started', veryShortDateFormat(project.startedTime ?? DateTime.now())),
        ],
      )
    );
  }

  Widget _buildCardRow(BuildContext context){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: _buildHeader(project.name),
              ),
              Expanded(
                flex: 3,
                child: _buildBody(),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 6),
            child: Column(
              children: <Widget>[
                MoreOptionsPopupMenu(
                  idFieldValue: project.projectId,
                  detailRouteName: Routing.projectDetailRoute,
                  editRouteName: Routing.projectEditRoute,
                  deleteWhat: project.name,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCardContents(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 2,
            //offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints.expand(),
        child: _buildCardRow(context)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: FlatButton(
        onPressed: () {
          Routing.navigateTo(context, "${Routing.projectDetailRoute}/${project.projectId}", transition: TransitionType.fadeIn);
        },
        child: _buildCardContents(context),
      ),
    );
  }
}