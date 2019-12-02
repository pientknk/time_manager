import 'package:flutter/material.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/model/data_samples.dart';
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
import 'package:time_manager/model/common/abstracts.dart';

class ProjectAddPage extends StatefulWidget {
  final Project project;

  ProjectAddPage(String applicationID):
      project = Project.newProject(applicationId: int.parse(applicationID));

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
    _applicationController = TextEditingController(
      text: ensureValue(
        value: ApplicationNames.options.entries.firstWhere((mapEntry) => mapEntry.value == widget.project.applicationId).key)
    );
    _statusController = TextEditingController(
      text: ensureValue(
        value: StatusTypes.options.entries.firstWhere((mapEntry) => mapEntry.value == widget.project.statusTypeId).key)
    );
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
      widget.project.applicationId = ApplicationNames.options.entries.firstWhere((mapEntry) => mapEntry.key == _applicationController.text).value;
      widget.project.statusTypeId = StatusTypes.options.entries.firstWhere((mapEntry) => mapEntry.key == _statusController.text).value;
      widget.project.name = _nameController.text;
      widget.project.description = _detailsController.text;
      widget.project.startedTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_startedTimeController.text));
      widget.project.completedTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_completedTimeController.text));

      if(DataSamples.addProject(widget.project)){
        Navigator.pop(context);
      }
      else{
        print("Error saving project: ${widget.project.toString()}");
      }
    }
    else{
      print("Error validating project: ${widget.project.toString()}");
    }
  }
}

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();

  ProjectDetailPage(String id) :
      project = DataSamples.getProjectByIdString(id);
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
    _priorityController = TextEditingController(
      text: ensureValue(
        value: widget.project.priority?.toString(), defaultValue: "0")
    );
    _applicationController = TextEditingController(
      text: ensureValue(
        value: ApplicationNames.options.entries.firstWhere((mapEntry) => mapEntry.value == widget.project.applicationId).key)
    );
    _statusController = TextEditingController(
      text: ensureValue(
        value: StatusTypes.options.entries.firstWhere((mapEntry) => mapEntry.value == widget.project.statusTypeId).key)
    );
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

  @override
  Widget build(BuildContext context) {
    List<WorkItem> _workItems = DataSamples.getAllWorkItemsForProject(widget.project.projectId);

    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Project Details'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.edit,
          onPressedFunc: () {
            Routing.navigateTo(context, "${Routing.projectEditRoute}/${widget.project.projectId}");
          }
        ),
        ThemeIconButtons.buildIconButton(
          iconData: Icons.delete_forever,
          onPressedFunc: () {
            DataSamples.deleteProject(widget.project.projectId);
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
          project: widget.project,
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
        route: "${Routing.workItemAddRoute}/${widget.project.projectId}",
        tooltip: 'Add a Work Item',
        notifyParent: refresh,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void refresh(){
    setState(() {

    });
  }
}

class ProjectEditPage extends StatefulWidget {
  final Project project;

  ProjectEditPage(String id) :
      project = DataSamples.getProjectByIdString(id);

  _ProjectEditPageState createState() => _ProjectEditPageState();
}

class _ProjectEditPageState extends State<ProjectEditPage> {
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

    _priorityController = TextEditingController(
      text: ensureValue(
        value: widget.project.priority?.toString(), defaultValue: "0")
    );
    _applicationController = TextEditingController(
      text: ensureValue(
        value: ApplicationNames.options.entries.firstWhere((mapEntry) => mapEntry.value == widget.project.applicationId).key)
    );
    _statusController = TextEditingController(
      text: ensureValue(
        value: StatusTypes.options.entries.firstWhere((mapEntry) => mapEntry.value == widget.project.statusTypeId).key)
    );
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
            DataSamples.projects.removeWhere((proj) => proj.projectId == widget.project.projectId);
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
      persistentBottomSheet: appScaffoldBottomSheet,
    );
  }

  void update(BuildContext context){
    if(_formKey.currentState != null && _formKey.currentState.validate()){
      widget.project.priority = int.parse(_priorityController.text);
      widget.project.applicationId = ApplicationNames.options.entries.firstWhere((mapEntry) => mapEntry.key == _applicationController.text).value;
      widget.project.statusTypeId = StatusTypes.options.entries.firstWhere((mapEntry) => mapEntry.key == _statusController.text).value;
      widget.project.name = _nameController.text;
      widget.project.description = _detailsController.text;
      widget.project.startedTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_startedTimeController.text));
      widget.project.completedTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_completedTimeController.text));

      if(DataSamples.updateProject(widget.project)){
        Navigator.pop(context);
      }
      else{
        print("Error saving project: ${widget.project.toString()}");
      }
    }
    else{
      print("Error validating project: ${widget.project.toString()}");
    }
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
    return ThemeForm.buildForm(
      formKey: widget.formKey,
      listViewChildren: <Widget>[
        ThemeInput.intFormField(
          enabled: widget.enabled,
          controller: widget.priorityController,
          label: 'priority',
          textInputAction: TextInputAction.done,
          context: context,
          currentFocusNode: priorityNode,
        ),
        ThemeInput.optionsSelector<ApplicationNames>(
          controller: widget.applicationController,
          initialValue: DataSamples.getApplicationById(widget.project.applicationId),
          options: List<Options>.from(DataSamples.applications),
          context: context,
          label: "Application",
          title: "Applications",
        ),
//        ThemeForm.buildFormFieldDropdown(
//          enabled: enabled,
//          labelText: 'application',
//          value: widget.project.applicationId == null
//            ? ApplicationNames.options.entries.first
//            : ApplicationNames.options.entries.firstWhere((mapEntry) => mapEntry.value == widget.project.applicationId).key,
//          options: ApplicationNames.options.keys.toList(),
//          onChangedFunc: (String value) {
//            setState(() {
//              widget.project.applicationId = ApplicationNames.options[value];
//            });
//          }
//        ),
        ThemeInput.optionsSelector<StatusTypes>(
          controller: widget.statusController,
          initialValue: DataSamples.getStatusTypeById(widget.project.statusTypeId),
          options: List<Options>.from(DataSamples.statusTypes),
          context: context,
          label: "Status Type",
          title: "Status Types"
        ),
        /*ThemeForm.buildFormFieldDropdown(
          enabled: enabled,
          labelText: 'status',
          value: widget.project.statusTypeId == null
            ? StatusTypes.options.entries.first.key
            : StatusTypes.options.entries.firstWhere((mapEntry) => mapEntry.value == widget.project.statusTypeId).key,
          options: StatusTypes.options.keys.toList(),
          onChangedFunc: (String value) {
            setState(() {
              widget.project.statusTypeId = StatusTypes.options[value];
            });
          }
        ),*/
        ThemeInput.textFormField(
          enabled: enabled,
          label: 'Name',
          controller: widget.nameController,
          textInputAction: TextInputAction.next,
          currentFocusNode: nameNode,
          nextFocusNode: detailsNode,
          context: context,
        ),
        ThemeInput.textFormField(
          enabled: enabled,
          label: 'Details',
          controller: widget.detailsController,
          textInputAction: TextInputAction.next,
          currentFocusNode: detailsNode,
          nextFocusNode: startedTimeNode,
          context: context,
          maxLines: 2,
        ),
        ThemeInput.dateTimeField(
          textInputAction: TextInputAction.next,
          enabled: enabled,
          context: context,
          currentFocusNode: startedTimeNode,
          nextFocusNode: completedTimeNode,
          label: 'started',
          textEditingController: widget.startedTimeController,
          format: DateFormat(detailedDateFormatWithSecondsString),
        ),
        ThemeInput.dateTimeField(
          textInputAction: TextInputAction.done,
          enabled: enabled,
          context: context,
          currentFocusNode: completedTimeNode,
          label: 'completed',
          textEditingController: widget.completedTimeController,
          format: DateFormat(detailedDateFormatWithSecondsString),
        ),
        ThemeForm.buildFormRowFromFields(
          children: <Widget>[
            ThemeInput.intFormField(
              controller: TextEditingController(
                text: ensureValue(
                  value: widget.project.workItemCount?.toString(),
                  defaultValue: "0")
              ),
              enabled: false,
              label: 'work items',
            ),
            ThemeInput.textFormField(
              label: 'total hours',
              controller: TextEditingController(text: shortDurationFormat(widget.project.totalHours)),
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