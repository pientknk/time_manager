import 'package:flutter/cupertino.dart';
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
  final _formKey = GlobalKey<FormState>();

  WorkItem workItem;
  TextEditingController _endTimeController;
  TextEditingController _startTimeController;
  TextEditingController _summaryController;
  TextEditingController _detailsController;

  @override
  void initState() {
    workItem = WorkItem.newWorkItem(projectId: widget.project.projectId);
    _endTimeController = TextEditingController(text: detailedDateFormatWithSeconds(workItem.endTime));
    _startTimeController = TextEditingController(text: detailedDateFormatWithSeconds(workItem.startTime));
    _summaryController = TextEditingController(text: workItem.summary);
    _detailsController = TextEditingController(text: workItem.details);
    super.initState();
  }

  @override
  void dispose() {
    _endTimeController.dispose();
    _startTimeController.dispose();
    _summaryController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppScaffoldBottomSheet appScaffoldBottomSheet = AppScaffoldBottomSheet(
      iconData: Icons.add,
      iconText: 'add',
      onTapFunc: () {
        save(context);
      },
    );

    return AppScaffold(
      appBarTitle: ThemeText.appBarText('add work item'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.add_box,
          onPressedFunc: () {
            save(context);
          }
        ),
      ],
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? appScaffoldBottomSheet.getHeight() : 0),
        child: _buildContents(context),
      ),
      persistentBottomSheet: appScaffoldBottomSheet,
    );
  }

  Widget _buildContents(BuildContext context){
    return Column(
      children: <Widget>[
        WorkItemClock(
          workItem: workItem,
          endTimeController: _endTimeController,
        ),
        Container(
          height: 3,
          color: ThemeColors.highlightedData,
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: <Widget>[
              buildForm(),
            ],
          )
        ),
      ]
    );
  }

  Widget buildForm(){
    return Expanded(
      flex: 5,
      child: WorkItemForm(
        workItem: workItem,
        formKey: _formKey,
        endTimeController: _endTimeController,
        startTimeController: _startTimeController,
        summaryController: _summaryController,
        detailsController: _detailsController ,
      ),
    );
  }

  void save(BuildContext context){
    if(_formKey.currentState != null && _formKey.currentState.validate()){
      workItem.details = _detailsController.text;
      workItem.summary = _summaryController.text;
      workItem.startTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_startTimeController.text));
      workItem.endTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_endTimeController.text));
      if(DataSamples.addWorkItem(workItem)){
        Navigator.pop(context);
      }
      else{
        print("error saving work Item: $workItem");
        //something is wrong
      }
    }
    else{
      print("error saving work Item: $workItem");
      //something else is wrong
    }
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
  TextEditingController _endTimeController;
  TextEditingController _startTimeController;
  TextEditingController _summaryController;
  TextEditingController _detailsController;

  @override
  void initState() {
    project = DataSamples.getProjectById(widget.workItem.projectId);
    _endTimeController = TextEditingController(text: detailedDateFormatWithSeconds(widget.workItem.endTime));
    _startTimeController = TextEditingController(text: detailedDateFormatWithSeconds(widget.workItem.startTime));
    _summaryController = TextEditingController(text: widget.workItem.summary);
    _detailsController = TextEditingController(text: widget.workItem.details);
    super.initState();
  }

  @override
  void dispose() {
    _endTimeController.dispose();
    _startTimeController.dispose();
    _summaryController.dispose();
    _detailsController.dispose();
    super.dispose();
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
            Routing.navigateTo(context, "${Routing.workItemEditRoute}/${widget.workItem.workItemId}")..then((val){
              Navigator.pop(context);
            });
          }
        ),
        ThemeIconButtons.buildIconButton(
          iconData: Icons.delete_forever,
          onPressedFunc: () {
            DataSamples.deleteWorkItem(widget.workItem.workItemId);
            Navigator.pop(context);
          }
        ),
      ],
      body: _buildAppBody(context),
    );
  }

  Widget _buildAppBody(BuildContext context) {
    return Column(
      children: <Widget>[
        WorkItemClock(
          workItem: widget.workItem,
          endTimeController: _endTimeController,
          isCounting: false,
        ),
        Container(
          height: 3,
          color: ThemeColors.highlightedData,
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: <Widget>[
              buildForm(),
            ],
          )
        ),
      ]
    );
  }

  Widget buildForm(){
    return Expanded(
      flex: 5,
      child: WorkItemForm(
        formKey: _formKey,
        workItem: widget.workItem,
        enabled: false,
        endTimeController: _endTimeController,
        startTimeController: _startTimeController,
        summaryController: _summaryController,
        detailsController: _detailsController ,
      ),
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
  TextEditingController _endTimeController;
  TextEditingController _startTimeController;
  TextEditingController _summaryController;
  TextEditingController _detailsController;

  @override
  void initState() {
    project = DataSamples.getProjectById(widget.workItem.projectId);
    _endTimeController = TextEditingController(text: detailedDateFormatWithSeconds(widget.workItem.endTime));
    _startTimeController = TextEditingController(text: detailedDateFormatWithSeconds(widget.workItem.startTime));
    _summaryController = TextEditingController(text: widget.workItem.summary);
    _detailsController = TextEditingController(text: widget.workItem.details);
    super.initState();
  }

  @override
  void dispose() {
    _endTimeController.dispose();
    _startTimeController.dispose();
    _summaryController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppScaffoldBottomSheet appScaffoldBottomSheet = AppScaffoldBottomSheet(
      iconData: Icons.add,
      iconText: 'save',
      onTapFunc: () {
        update(context);
      },
    );

    return AppScaffold(
      appBarTitle: ThemeText.appBarText('edit work item'),
      appBarActions: <Widget>[
        ThemeIconButtons.buildIconButton(
          iconData: Icons.delete_forever,
          onPressedFunc: () {
            Navigator.pop(context);
            //delete it I guess?
          }
        ),
        ThemeIconButtons.buildIconButton(
          iconData: Icons.save,
          onPressedFunc: () {
            update(context);
          }
        ),
      ],
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? appScaffoldBottomSheet.getHeight() : 0),
        child: _buildContents(context),
      ),
      persistentBottomSheet: appScaffoldBottomSheet,
    );
  }

  Widget _buildContents(BuildContext context){
    return Column(
      children: <Widget>[
        WorkItemClock(
          workItem: widget.workItem,
          endTimeController: _endTimeController,
          isCounting: false,
        ),
        Container(
          height: 3,
          color: ThemeColors.highlightedData,
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: <Widget>[
              buildForm(),
            ],
          )
        ),
      ]
    );
  }

  Widget buildForm(){
    return Expanded(
      flex: 5,
      child: WorkItemForm(
        workItem: widget.workItem,
        formKey: _formKey,
        enabled: true,
        endTimeController: _endTimeController,
        startTimeController: _startTimeController,
        summaryController: _summaryController,
        detailsController: _detailsController ,
      ),
    );
  }

  void update(BuildContext context){
    if(_formKey.currentState != null && _formKey.currentState.validate()){
      widget.workItem.details = _detailsController.text;
      widget.workItem.summary = _summaryController.text;
      widget.workItem.startTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_startTimeController.text));
      widget.workItem.endTime = DateTime.parse(reformatDetailedDateFormatWithSecondsString(_endTimeController.text));
      if(DataSamples.updateWorkItem(widget.workItem)){
        //TODO: need to pop state but go back to the details screen after it saves rather than the project details
        Navigator.pop(context);
/*        setState(() {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }

          _endTimeController = TextEditingController(text: detailedDateFormatWithSeconds(widget.workItem.endTime));
          _startTimeController = TextEditingController(text: detailedDateFormatWithSeconds(widget.workItem.startTime));
          _summaryController = TextEditingController(text: widget.workItem.summary);
          _detailsController = TextEditingController(text: widget.workItem.details);

        });*/
      }
      else{
        print("error saving work Item: ${widget.workItem}");
        //something is wrong
      }
    }
    else{
      print("error saving work Item: ${widget.workItem}");
      //something else is wrong
    }
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
                            child: ThemeText.commonHeaderText(text: workItem.summary),
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
  WorkItemForm({@required this.workItem, @required this.formKey, this.endTimeController, this.enabled = true,
    this.startTimeController, this.summaryController, this.detailsController, this.duration});

  final GlobalKey<FormState> formKey;
  final bool enabled;
  final WorkItem workItem;
  final Duration duration;
  final TextEditingController endTimeController;
  final TextEditingController startTimeController;
  final TextEditingController summaryController;
  final TextEditingController detailsController;

  _WorkItemFormState createState() => _WorkItemFormState();
}

class _WorkItemFormState extends State<WorkItemForm> {
  final String summaryField = 'Summary';
  final String detailsField = 'Details';
  final String startedField = "Started";
  final String completedField = "Completed";
  //TODO: look into focus manager for managing focus of non text input fields
  final FocusNode summaryNode = new FocusNode();
  final FocusNode detailsNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    summaryNode.dispose();
    detailsNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWorkItemForm(
      context: context,
      enabled: widget.enabled,
    );
  }

  Widget _buildWorkItemForm({BuildContext context, bool enabled}){
    return ThemeForm.buildForm(
      formKey: widget.formKey,
      listViewChildren: <Widget>[
        ThemeInput.textFormField(
          currentFocusNode: summaryNode,
          nextFocusNode: detailsNode,
          controller: widget.summaryController,
          enabled: widget.enabled,
          label: summaryField,
          textInputAction: TextInputAction.next,
          //TODO: don't include initial value if controller value is null
          //initialValue: widget.summaryController.text,
          //TODO: just limit the amount of characters you an enter instead of doing this length validation
          validatorFunc: (val) {
            return baseValidatorLengthValidation(
              val: val,
              fieldName: summaryField,
              maxLength: 75,
            );
          },
          context: context,
        ),
        ThemeInput.textFormField(
          currentFocusNode: detailsNode,
          controller: widget.detailsController,
          enabled: widget.enabled,
          label: detailsField,
          //initialValue: widget.detailsController.text,
          maxLines: 2,
          textInputAction: TextInputAction.done,
          validatorFunc: (val) {
            return baseValidatorLengthValidation(
              val: val,
              fieldName: detailsField,
              maxLength: 250,
            );
          },
          context: context,
        ),
        ThemeInput.dateTimeField(
          textEditingController: widget.startTimeController,
          enabled: widget.enabled,
          context: context,
          format: DateFormat(detailedDateFormatWithSecondsString),
          label: startedField,
          originalValue: widget.workItem.startTime,
          validatorFunc: (val) {
            return baseValidatorDateTimeRequiredValidation(
              val: val,
              fieldName: startedField,
            );
          }
        ),
        ThemeInput.dateTimeField(
          textEditingController: widget.endTimeController,
          enabled: widget.enabled,
          context: context,
          format: DateFormat(detailedDateFormatWithSecondsString),
          label: completedField,
          originalValue: DateTime.parse(reformatDetailedDateFormatWithSecondsString(widget.endTimeController.text)),
          validatorFunc: (val) {
            return baseValidatorDateTimeRequiredValidation(
              val: val,
              fieldName: completedField,
            );
          },
        ),
      ]
    );
  }
}

class WorkItemClock extends StatefulWidget {
  WorkItemClock({this.workItem, this.endTimeController, this.isCounting = true});

  final WorkItem workItem;
  final TextEditingController endTimeController;
  final bool isCounting;

  @override
  _WorkItemClockState createState() => _WorkItemClockState();

}

class _WorkItemClockState extends State<WorkItemClock> {
  Timer _timer;
  Duration _duration = Duration();

  @override
  void initState() {
    _duration = widget.workItem.duration ?? Duration();
    if(widget.isCounting){
      startTimer();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: ThemeColors.card,
      child: Center(
        child: Text(longDurationFormat(_duration), //need to find way to stop text from moving around with different text inputs of various width
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 75,
            fontFamily: ThemeTextStyles.mainFont
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if(_timer != null){
      _timer.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
        (Timer timer) =>
        setState(() {
          //_duration = new Duration(days: _duration.inDays, hours: _duration.inHours, seconds: _duration.inSeconds + 1);

          //setting the end date in setstate triggers the validator function - this was from a form validation set for any change not on submit
          widget.workItem.endTime = DateTime.now();
          widget.endTimeController.text =
            detailedDateFormatWithSeconds(widget.workItem.endTime);
          _duration =
            widget.workItem.endTime.difference(widget.workItem.startTime);
        })
    );
  }
}
