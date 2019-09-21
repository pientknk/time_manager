import 'package:flutter/material.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/model/data_samples.dart';
import 'dart:async';
import 'package:time_manager/common/data_utils.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/routing.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/common/more_options_popup_menu.dart';

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
    workItem = WorkItem.newWorkItem(projectId: widget.project.projectId);
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
            child: WorkItemForm(
              workItem: workItem,
              formKey: _formKey,
              endTimeController: endTimeController,
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
    project = DataSamples.getProjectById(widget.workItem.projectId);
    super.initState();
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
            child: WorkItemForm(
              workItem: widget.workItem,
              formKey: _formKey,
              enabled: false,
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    project = DataSamples.getProjectById(widget.workItem.projectId);
    return AppScaffold(
      appBarTitle: ThemeText.appBarText('Work Item Details'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.edit,
          onPressedFunc: () {
            Routing.navigateTo(context, "${Routing.workItemEditRoute}/${widget.workItem.workItemId}");
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
    project = DataSamples.getProjectById(widget.workItem.projectId);
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
            child: WorkItemForm(
              workItem: widget.workItem,
              formKey: _formKey,
            ),
          )
        ]
      ),
    );
  }
}

class WorkItemCard extends StatelessWidget{
  WorkItemCard({Key key, this.workItem}) : super(key: key);

  final WorkItem workItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
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
      ///TODO: try using inkwell instead with transparency so that it hopefully gets the ink splash on press an hold
      child: FlatButton(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        onPressed: () {
          Routing.navigateTo(context, "${Routing.workItemDetailRoute}/${workItem.workItemId}");
        },
        child: _buildCardContents(context),
      ),
    );
  }

  Widget _buildCardContents(BuildContext context){
    return Container(
      //color: Colors.orange,
      constraints: BoxConstraints.expand(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ThemeText.highlightedText(shortDurationFormat(workItem.duration)),
                            //color: Colors.blue[500],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Container(
                            child: ThemeText.commonText("${detailedDateFormat24WithSecondsHour(workItem.startTime)} - ${shortHoursOnly24HourFormat(workItem.endTime)}"),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            //color: Colors.blue[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: ThemeText.commonHeaderText(workItem.summary),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            //color: Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: MoreOptionsPopupMenu(
                idFieldValue: workItem.workItemId,
                detailRouteName: Routing.workItemDetailRoute,
                editRouteName: Routing.workItemEditRoute,
                deleteWhat: workItem.summary,
              )
            ),
          ),
        ],
      ),
    );
  }
}

class WorkItemForm extends StatefulWidget {
  WorkItemForm({@required this.workItem, @required this.formKey, this.endTimeController, this.enabled = true});

  final GlobalKey<FormState> formKey;
  final bool enabled;
  final WorkItem workItem;
  final TextEditingController endTimeController;

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
    return SafeArea(
      top: false,
      bottom: false,
      child: _buildWorkItemForm(
        context: context,
        enabled: widget.enabled,
      ),
    );
  }

  Widget _buildWorkItemForm({BuildContext context, bool enabled}){
    return ThemeForm.buildForm(
      formKey: widget.formKey,
      listViewChildren: <Widget>[
        ThemeInput.textFormField(
          enabled: widget.enabled,
          label: 'Summary',
          initialValue: widget.workItem.summary,
        ),
        ThemeInput.textFormField(
          enabled: widget.enabled,
          label: 'Details',
          initialValue: widget.workItem.details,
          maxLines: 2,
        ),
        ThemeInput.dateTimeField(
          enabled: widget.enabled,
          context: context,
          format: DateFormat(detailedDateFormatWithSecondsString),
          label: 'started',
          originalValue: widget.workItem.startTime,
        ),
        ThemeInput.dateTimeField(
          textEditingController: widget.endTimeController,
          enabled: widget.enabled,
          context: context,
          format: DateFormat(detailedDateFormatWithSecondsString),
          label: 'completed',
          originalValue: widget.workItem.endTime,
        ),
      ]
    );
  }
}