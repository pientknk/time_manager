import 'package:flutter/material.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/model/data_samples.dart';
import 'dart:async';
import 'package:time_manager/common/data_utils.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/routing.dart';
import 'package:intl/intl.dart';

class WorkItemAddPage extends StatefulWidget {
  final Project project;

  WorkItemAddPage(String id) :
    project = DataSamples.getProjectById(int.parse(id));

  _WorkItemAddPageState createState() => _WorkItemAddPageState();
}

class _WorkItemAddPageState extends State<WorkItemAddPage> {
  WorkItem workItem;
  final _formKey = GlobalKey<FormState>();
  Timer _timer;
  Duration duration = Duration();
  TextEditingController endTimeController;

  @override
  void initState() {
    startTimer();
    workItem = WorkItem.newWorkItem(projectID: widget.project.projectID);
    endTimeController = TextEditingController(text: detailedDateFormatWithSeconds(workItem.endTime));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('add work item'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.add_box,
          onPressedFunc: () {
            Navigator.pop(context);
            //delete it I guess?
          }
        ),
      ],
      body: _buildContents(context),
      persistentBottomSheet: AppScaffoldBottomSheet(
        iconData: Icons.add,
        iconText: 'add',
      ),
    );
  }

  Widget _buildContents(BuildContext context){
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: ThemeColors.card,
              child: Center(
                child: Text(longDurationFormat(duration), //need to find way to stop text from moving around with different text inputs of various width
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 75,
                    fontFamily: ThemeTextStyles.mainFont
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ThemeForm.buildForm(
              formKey: _formKey,
              listViewChildren: <Widget>[
                ThemeInput.textFormField(
                  label: 'Project',
                  enabled: false,
                  initialValue: widget.project.name,
                  maxLines: 1
                ),
                ThemeInput.textFormField(
                  label: 'Summary',
                  validatorFunc: (val) {
                    return null;
                  },
                ),
                ThemeInput.textFormField(
                  label: 'Details',
                  maxLines: 2,
                  validatorFunc: (val) {
                    return null;
                  }
                ),
                ThemeInput.dateTimeField(
                  originalValue: workItem.startTime,
                  format: DateFormat(detailedDateFormatWithSecondsString),
                  enabled: false,
                  context: context,
                  label: 'started',
                ),
                ThemeInput.dateTimeField(
                  textEditingController: endTimeController,
                  format: DateFormat(detailedDateFormatWithSecondsString),
                  enabled: false,
                  context: context,
                  label: 'ended',
                ),
              ],
            ),
          )
        ]
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    endTimeController.dispose();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
        (Timer timer) => setState((){
        workItem.endTime = DateTime.now();
        endTimeController.text = detailedDateFormatWithSeconds(workItem.endTime);
        duration = workItem.endTime.difference(workItem.startTime);
      })
    );
  }
}

class WorkItemDetailPage extends StatefulWidget {
  final WorkItem workItem;

  WorkItemDetailPage(String id) :
      workItem = DataSamples.getWorkItemByIdString(id);

  _WorkItemDetailPageState createState() => _WorkItemDetailPageState();

}

class _WorkItemDetailPageState extends State<WorkItemDetailPage> {
  final _formKey = GlobalKey<FormState>();
  Project project;

  @override
  void initState() {
    project = DataSamples.getProjectById(widget.workItem.projectID);
    super.initState();
  }

  Widget _buildWorkItemForm(BuildContext context) {
    return ThemeForm.buildForm(
      formKey: _formKey,
      listViewChildren: <Widget>[
        ThemeInput.textFormField(
          label: 'Project',
          enabled: false,
          initialValue: project.name,
          maxLines: 1
        ),
        ThemeInput.textFormField(
          enabled: false,
          label: 'Summary',
          initialValue: widget.workItem.summary,
        ),
        ThemeInput.textFormField(
          enabled: false,
          label: 'Details',
          initialValue: widget.workItem.details,
          maxLines: 2,
        ),
        ThemeInput.dateTimeField(
          enabled: false,
          originalValue: widget.workItem.startTime,
          format: DateFormat(detailedDateFormatWithSecondsString),
          context: context,
          label: 'started',
        ),
        ThemeInput.dateTimeField(
          enabled: false,
          originalValue: widget.workItem.endTime,
          format: DateFormat(detailedDateFormatWithSecondsString),
          context: context,
          label: 'ended',
        ),
      ]
    );
  }

  Widget _buildAppBody(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: ThemeColors.card,
              child: Center(
                child: Text(longDurationFormat(widget.workItem.endTime.difference(widget.workItem.startTime)), //need to find way to stop text from moving around with different text inputs of various width
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 75,
                    fontFamily: ThemeTextStyles.mainFont
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: _buildWorkItemForm(context),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    project = DataSamples.getProjectById(widget.workItem.projectID);
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Work Item Details'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.edit,
          onPressedFunc: () {
            Routing.navigateTo(context, "${Routing.workItemEditRoute}/${widget.workItem.workItemID}");
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
      body: _buildAppBody(context),
    );
  }
}

class WorkItemEditPage extends StatefulWidget {
  final WorkItem workItem;

  WorkItemEditPage(String id) :
      workItem = DataSamples.getWorkItemByIdString(id);

  _WorkItemEditPageState createState() => _WorkItemEditPageState();
}

class _WorkItemEditPageState extends State<WorkItemEditPage> {
  final _formKey = GlobalKey<FormState>();
  Project project;
  Duration duration;

  @override
  void initState() {
    project = DataSamples.getProjectById(widget.workItem.projectID);
    duration = widget.workItem.endTime.difference(widget.workItem.startTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('add work item'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.delete_forever,
          onPressedFunc: () {
            Navigator.pop(context);
            //delete it I guess?
          }
        ),
      ],
      body: _buildContents(context),
      persistentBottomSheet: AppScaffoldBottomSheet(
        iconData: Icons.check_circle_outline,
        iconText: 'update',
      ),
    );
  }

  Widget _buildContents(BuildContext context){
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: ThemeColors.card,
              child: Center(
                child: Text(longDurationFormat(duration), //need to find way to stop text from moving around with different text inputs of various width
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 75,
                    fontFamily: ThemeTextStyles.mainFont
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ThemeForm.buildForm(
              formKey: _formKey,
              listViewChildren: <Widget>[
                ThemeInput.textFormField(
                  label: 'Project',
                  enabled: false,
                  initialValue: project.name,
                  maxLines: 1
                ),
                ThemeInput.textFormField(
                  label: 'Summary',
                  initialValue: widget.workItem.summary,
                  validatorFunc: (val) {
                    return null;
                  },
                ),
                ThemeInput.textFormField(
                  label: 'Details',
                  maxLines: 2,
                  initialValue: widget.workItem.details,
                  validatorFunc: (val) {
                    return null;
                  }
                ),
                ThemeInput.dateTimeField(
                  originalValue: widget.workItem.startTime,
                  format: DateFormat(detailedDateFormatWithSecondsString),
                  context: context,
                  label: 'started',
                ),
                ThemeInput.dateTimeField(
                  originalValue: widget.workItem.endTime,
                  format: DateFormat(detailedDateFormatWithSecondsString),
                  context: context,
                  label: 'ended',
                ),
              ],
            ),
          )
        ]
      ),
    );
  }
}

class WorkItemForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool enabled;
  final WorkItem workItem;

  WorkItemForm({@required this.workItem, @required this.formKey, this.enabled = true});

  _WorkItemFormState createState() => _WorkItemFormState();
}

class _WorkItemFormState extends State<WorkItemForm> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeForm.buildForm(
      formKey: widget.formKey,
      listViewChildren: <Widget>[
        ThemeInput.textFormField(
          enabled: widget.enabled,
          label: 'Summary',
          initialValue: widget.workItem.summary,
        ),
        ThemeInput.textFormField(
          enabled: false,
          label: 'Details',
          initialValue: widget.workItem.details,
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
      ]
    );
  }
}