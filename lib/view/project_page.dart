import 'package:flutter/material.dart';
import 'package:time_manager/model/data.dart';
import 'package:time_manager/model/data_samples.dart';
import 'package:time_manager/common/app_scaffold.dart';
import 'package:time_manager/common/theme.dart';
import 'package:time_manager/common/data_utils.dart';
import 'package:time_manager/common/routing.dart';


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
        ThemeIconButtons.buildIconButton(
          iconData: Icons.edit,
          onPressedFunc: () {
            Routing.navigateTo(context, "${Routing.projectEditRoute}/${project.projectID}");
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
      floatingActionButton: AppScaffoldFAB(
        route: "${Routing.workItemAddRoute}/${project.projectID}",
        tooltip: 'Add a Work Item',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
      body: _buildContents(context),
    );
  }
}

//modal route stuff