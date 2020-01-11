import 'package:flutter/material.dart';
import 'package:time_manager/common/notification_factory.dart';
import 'package:time_manager/common/data_access_layer/data_samples.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/data_utils.dart';
import 'package:time_manager/common/routing.dart';
import 'package:fluro/fluro.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flushbar/flushbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:time_manager/view/work_item_page.dart';
import 'package:time_manager/common/more_options_popup_menu.dart';

import '../model/model.dart';
import '../tools/data_tools.dart';

class ProjectAddPage extends StatefulWidget {
  final Project project;

  ProjectAddPage(String applicationID):
    project = Project();

  _ProjectAddPageState createState() => _ProjectAddPageState();
}

class _ProjectAddPageState extends State<ProjectAddPage> {
  TextEditingController _priorityController;
  TextEditingController _applicationController;
  TextEditingController _statusController;
  TextEditingController _nameController;
  TextEditingController _detailsController;
  TextEditingController _startedTimeController;
  TextEditingController _completedTimeController;

  @override
  void initState() {
    _priorityController = TextEditingController(
      text: ensureValue(
        value: widget.project.priority?.toString(), defaultValue: "0")
    );

    _applicationController = TextEditingController();
    widget.project.getApplication().then((app){
      _applicationController.text = app.name;
    });

    _statusController = TextEditingController();
    widget.project.getStatusType().then((st){
      _statusController.text = st.name;
    });

    _nameController = TextEditingController(
      text: ensureValue(
        value: widget.project.name)
    );
    _detailsController = TextEditingController(
      text: ensureValue(
        value: widget.project.description)
    );
    _startedTimeController = TextEditingController(
      text: ensureValue(
        value: detailedDateFormatWithSeconds(widget.project.startedTime))
    );
    _completedTimeController = TextEditingController(
      text: ensureValue(
        value: detailedDateFormatWithSeconds(widget.project.completedTime))
    );

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppScaffoldBottomSheet appScaffoldBottomSheet = AppScaffoldBottomSheet(
      iconData: Icons.add,
      iconText: 'add',
      onTapFunc: () {
        save(context);
      }
    );

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
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? appScaffoldBottomSheet.getHeight() : 0),
        child: ProjectForm(
          formKey: _formKey,
          project: widget.project,
          enabled: true,
          priorityController: _priorityController,
          applicationController: _applicationController,
          statusController: _statusController,
          nameController: _nameController,
          detailsController: _detailsController,
          startedTimeController: _startedTimeController,
          completedTimeController: _completedTimeController,
        ),
      ),
      persistentBottomSheet: appScaffoldBottomSheet
    );
  }

  void save(BuildContext context){
    if(_formKey.currentState != null && _formKey.currentState.validate()){
      widget.project.priority = int.parse(_priorityController.text);
      widget.project.getApplication().
      widget.project.applicationId = ApplicationNames.options.entries.firstWhere((mapEntry) => mapEntry.key == _applicationController.text).value;
      widget.project.statusTypeId = StatusTypes.options.entries.firstWhere((mapEntry) => mapEntry.key == _statusController.text).value;
      widget.project.name = _nameController.text;
      widget.project.description = _detailsController.text;
      widget.project.startedTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_startedTimeController.text));
      widget.project.completedTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_completedTimeController.text));

      Helpers.projectHelper.create(widget.project).then((result){
        if(result){
          Navigator.push(context, NotificationFactory.successNotification(context: context));
          //Navigator.pop(context);
        }
        else{
          print("Error saving project: ${widget.project.toString()}");
        }
      });
    }
    else{
      print("Error validating project: ${widget.project.toString()}");
    }
  }
}

class ProjectDetailPage extends StatefulWidget {
  final int projectId;

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();

  ProjectDetailPage(String id) :
      projectId = int.parse(id);
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _priorityController;
  TextEditingController _applicationController;
  TextEditingController _statusController;
  TextEditingController _nameController;
  TextEditingController _detailsController;
  TextEditingController _startedTimeController;
  TextEditingController _completedTimeController;
  Project project;

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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
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
            child: ThemeText.headerText(text: "Work Items ($numWorkItems)"),
          ),
        ],
      )
    );
  }

  Widget _floatingPanel(List<WorkItem> workItems){
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
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
  void initState() {
    Helpers.projectHelper.read(widget.projectId).then((pr){
      project = pr;
    });
    assignControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _allFields = List<String>();
    tableProject.fields.forEach((sqfEntityField){
      _allFields.add(sqfEntityField.fieldName);
    });
    Future<List<WorkItem>> workItemsF = project.getWorkItems(columnsToSelect: _allFields).toList();
    List<WorkItem> _workItems = List<WorkItem>();
    workItemsF.then((workItems){
      _workItems = workItems;
    });

    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Project'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.edit,
          onPressedFunc: () {
            Routing.navigateTo(context, "${Routing.projectEditRoute}/${project.id}")..whenComplete((){
              refresh();
            });
          }
        ),
        ThemeIconButtons.buildIconButton(
          iconData: Icons.delete_forever,
          onPressedFunc: () {
            DataSamples.deleteProject(project.id);
            Navigator.pop(context);
            //delete it I guess?
          }
        ),
      ],
      body: SlidingUpPanel(
        maxHeight: 600,
        minHeight: 85,
        backdropEnabled: true,
        backdropOpacity: 0.35,
        renderPanelSheet: false,
        panel: _floatingPanel(_workItems),
        collapsed: _floatingCollapsed(numWorkItems: _workItems.length),
        body: ProjectForm(
          formKey: _formKey,
          project: project,
          priorityController: _priorityController,
          applicationController: _applicationController,
          statusController: _statusController,
          nameController: _nameController,
          detailsController: _detailsController,
          startedTimeController: _startedTimeController,
          completedTimeController: _completedTimeController,
        ),
      ),
      floatingActionButton: AppScaffoldFAB(
        route: "${Routing.workItemAddRoute}/${project.id}",
        tooltip: 'Add a Work Item',
        notifyParent: refresh,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void refresh(){
    setState(() {
      Helpers.projectHelper.read(widget.projectId).then((pr){
        project = pr;
      });

      assignControllers();
    });
  }

  void assignControllers(){
    _priorityController = ProjectHelper.getPriorityController(project);
    _applicationController = ProjectHelper.getApplicationController(project);
    _statusController = ProjectHelper.getStatusController(project);
    _nameController = ProjectHelper.getNameController(project);
    _detailsController = ProjectHelper.getDetailsController(project);
    _startedTimeController = ProjectHelper.getStartedTimeController(project);
    _completedTimeController = ProjectHelper.getCompletedTimeController(project);
  }
}

class ProjectEditPage extends StatefulWidget {
  final int projectId;

  ProjectEditPage(String id) :
      projectId = int.parse(id);

  _ProjectEditPageState createState() => _ProjectEditPageState();
}

class _ProjectEditPageState extends State<ProjectEditPage> {
  Project project;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _priorityController;
  TextEditingController _applicationController;
  TextEditingController _statusController;
  TextEditingController _nameController;
  TextEditingController _detailsController;
  TextEditingController _startedTimeController;
  TextEditingController _completedTimeController;

  @override
  void initState() {
    Helpers.projectHelper.read(widget.projectId).then((pr){
      project = pr;
    });
    assignControllers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppScaffoldBottomSheet appScaffoldBottomSheet = AppScaffoldBottomSheet(
      iconData: Icons.add,
      iconText: 'update',
      onTapFunc: () {
        update(context);
      }
    );

    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Edit Project'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.delete_forever,
          onPressedFunc: (){
            Helpers.projectHelper.delete(project);
            Navigator.pop(context);
          }
        ),
        //TODO: make save button change color to green when a field is changed
        ThemeIconButtons.buildIconButton(
          iconData: Icons.save,
          onPressedFunc: (){
            update(context);
          }
        )
      ],
      body: ProjectForm(
        formKey: _formKey,
        project: project,
        enabled: true,
        priorityController: _priorityController,
        applicationController: _applicationController,
        statusController: _statusController,
        nameController: _nameController,
        detailsController: _detailsController,
        startedTimeController: _startedTimeController,
        completedTimeController: _completedTimeController,
      ),
      persistentBottomSheet: appScaffoldBottomSheet,
    );
  }

  void update(BuildContext context){
    if(_formKey.currentState != null && _formKey.currentState.validate()){
      project.priority = int.parse(_priorityController.text);
      project.applicationId = ApplicationNames.options.entries.firstWhere((mapEntry) => mapEntry.key == _applicationController.text).value;
      project.statusTypeId = StatusTypes.options.entries.firstWhere((mapEntry) => mapEntry.key == _statusController.text).value;
      project.name = _nameController.text;
      project.description = _detailsController.text;
      project.startedTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_startedTimeController.text));
      project.completedTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_completedTimeController.text));

      Helpers.projectHelper.update(project).then((result){
        if(result){
          Navigator.pop(context);
        }
        else{
          print("Error updating project $project");
        }
      });
    }
    else{
      print("Error validating project: ${project.toString()}");
    }
  }

  void assignControllers(){
    _priorityController = ProjectHelper.getPriorityController(project);
    _applicationController = ProjectHelper.getApplicationController(project);
    _statusController = ProjectHelper.getStatusController(project);
    _nameController = ProjectHelper.getNameController(project);
    _detailsController = ProjectHelper.getDetailsController(project);
    _startedTimeController = ProjectHelper.getStartedTimeController(project);
    _completedTimeController = ProjectHelper.getCompletedTimeController(project);
  }
}

class ProjectForm extends StatefulWidget{
  ProjectForm({@required this.formKey, @required this.project, this.enabled = false,
    this.priorityController, this.applicationController, this.statusController, this.nameController,
    this.detailsController, this.startedTimeController, this.completedTimeController});

  final Project project;
  final GlobalKey<FormState> formKey;
  ///false by default to ensure readonly fields
  final bool enabled;
  final TextEditingController priorityController;
  final TextEditingController applicationController;
  final TextEditingController statusController;
  final TextEditingController nameController;
  final TextEditingController detailsController;
  final TextEditingController startedTimeController;
  final TextEditingController completedTimeController;

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> with SingleTickerProviderStateMixin{
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose(){
    priorityNode.dispose();
    applicationNode.dispose();
    statusNode.dispose();
    nameNode.dispose();
    detailsNode.dispose();
    startedTimeNode.dispose();
    completedTimeNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildProjectForm(
      context: context,
      enabled: widget.enabled,
    );
  }

  final FocusNode priorityNode = new FocusNode();
  final FocusNode applicationNode = new FocusNode();
  final FocusNode statusNode = new FocusNode();
  final FocusNode nameNode = new FocusNode();
  final FocusNode detailsNode = new FocusNode();
  final FocusNode startedTimeNode = new FocusNode();
  final FocusNode completedTimeNode = new FocusNode();

  Widget _buildProjectForm({BuildContext context, bool enabled}) {
    int applicationId;
    widget.project.getApplication().then((app){
      applicationId = app.id;
    });
    int statusTypeId;
    widget.project.getStatusType().then((st){
      statusTypeId = st.id;
    });
    return ThemeForm.buildForm(
      formKey: widget.formKey,
      listViewChildren: <Widget>[
        ThemeInput.intFormField(
          label: 'priority',
          enabled: widget.enabled,
          controller: widget.priorityController,
          textInputAction: TextInputAction.done,
          context: context,
          currentFocusNode: priorityNode,
          validatorFunc: (val) {
            return baseValidatorLengthValidation(
              val: val,
              fieldName: '',
              maxLength: 3,
            );
          },
        ),

        ThemeInput.optionsSelector(
          label: "Application",
          title: "Applications",
          controller: widget.applicationController,
          initialValue: DataSamples.getApplicationById(applicationId),
          options: DataSamples.applications,
          enabled: enabled,
          context: context,
        ),
        ThemeInput.optionsSelector(
          label: "Status Type",
          title: "Status Types",
          controller: widget.statusController,
          initialValue: DataSamples.getStatusTypeById(statusTypeId),
          options: DataSamples.statusTypes,
          enabled: enabled,
          context: context,
        ),
        ThemeInput.textFormField(
          label: 'Name*',
          enabled: enabled,
          controller: widget.nameController,
          textInputAction: TextInputAction.next,
          currentFocusNode: nameNode,
          nextFocusNode: detailsNode,
          context: context,
          validatorFunc: (val) {
            return baseValidatorLengthValidation(
              val: val,
              fieldName: '',
              maxLength: 75,
            );
          },
        ),
        ThemeInput.textFormField(
          label: 'Details*',
          enabled: enabled,
          controller: widget.detailsController,
          textInputAction: TextInputAction.next,
          currentFocusNode: detailsNode,
          nextFocusNode: startedTimeNode,
          context: context,
          maxLines: 2,
          validatorFunc: (val) {
            return baseValidatorLengthValidation(
              val: val,
              fieldName: '',
              maxLength: 225,
            );
          },
        ),
        ThemeInput.dateTimeField(
          label: 'started',
          textInputAction: TextInputAction.next,
          enabled: enabled,
          context: context,
          currentFocusNode: startedTimeNode,
          nextFocusNode: completedTimeNode,
          textEditingController: widget.startedTimeController,
          format: DateFormat(detailedDateFormatWithSecondsString),
          /*validatorFunc: (val) {
            return baseValidatorDateTimeRequiredValidation(
              val: val,
              fieldName: '',
            );
          }*/
        ),
        ThemeInput.dateTimeField(
          label: 'completed',
          textInputAction: TextInputAction.done,
          enabled: enabled,
          context: context,
          currentFocusNode: completedTimeNode,
          textEditingController: widget.completedTimeController,
          format: DateFormat(detailedDateFormatWithSecondsString),
        ),
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeInput.intFormField(
              label: 'work items',
              controller: TextEditingController(
                text: ensureValue(
                  value: ProjectHelper.workItemCount(widget.project).toString(),
                  defaultValue: "0")
              ),
              enabled: false,
            ),
            ThemeInput.textFormField(
              label: 'total hours',
              controller: TextEditingController(text: shortDurationFormat(ProjectHelper.totalHours(widget.project))),
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
          child: ThemeText.headerText(text: text)
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
          _buildLabelAndData('Hours', shortDurationFormat(ProjectHelper.totalHours(project))),
          _buildLabelAndData('Items', ProjectHelper.workItemCount(project).toString()),
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
                  idFieldValue: project.id,
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
          Routing.navigateTo(context, "${Routing.projectDetailRoute}/${project.id}", transition: TransitionType.fadeIn);
        },
        child: _buildCardContents(context),
      ),
    );
  }
}