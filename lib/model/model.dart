import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;

part 'model.g.dart';

const tableWorkItem = SqfEntityTable(
  tableName: 'WorkItem',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  primaryKeyName: 'id',
  useSoftDeleting: true,
  fields: [
    SqfEntityField('createdTime', DbType.datetime),
    SqfEntityField('updatedTime', DbType.datetime),
    SqfEntityField('startTime', DbType.datetime),
    SqfEntityField('endTime', DbType.datetime),
    SqfEntityFieldRelationship(
      parentTable: tableProject,
      deleteRule: DeleteRule.CASCADE,
      defaultValue: null,
    ),
    SqfEntityField('summary', DbType.text),
    SqfEntityField('details', DbType.text)
  ]
);

const tableProject = SqfEntityTable(
  tableName: 'Project',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  primaryKeyName: 'id',
  useSoftDeleting: true,
  fields: [
    SqfEntityField('createdTime', DbType.datetime),
    SqfEntityField('updatedTime', DbType.datetime),
    SqfEntityFieldRelationship(
      parentTable: tableApplication,
      deleteRule: DeleteRule.CASCADE,
      defaultValue: null,
    ),
    SqfEntityField('name', DbType.text),
    SqfEntityField('description', DbType.text),
    SqfEntityField('priority', DbType.integer),
    SqfEntityFieldRelationship(
      parentTable: tableStatusType,
      deleteRule: DeleteRule.SET_NULL,
      defaultValue: null,
    ),
    SqfEntityField('startedTime', DbType.datetime),
    SqfEntityField('completedTime', DbType.datetime),
    SqfEntityFieldRelationship(
      parentTable: tableProjectType,
      deleteRule: DeleteRule.SET_NULL,
      defaultValue: null,
    )
  ]
);

const tableStatusType = SqfEntityTable(
  tableName: 'StatusType',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  primaryKeyName: 'id',
  useSoftDeleting: true,
  fields: [
    SqfEntityField('createdTime', DbType.datetime),
    SqfEntityField('updatedTime', DbType.datetime),
    SqfEntityField('name', DbType.text),
    SqfEntityField('description', DbType.text),
  ]
);

const tableFilter = SqfEntityTable(
  tableName: 'Filter',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  primaryKeyName: 'id',
  useSoftDeleting: true,
  fields: [
    SqfEntityField('createdTime', DbType.datetime),
    SqfEntityField('updatedTime', DbType.datetime),
    SqfEntityField('filterXML', DbType.text),
    SqfEntityField('isDefault', DbType.bool),
    SqfEntityField('name', DbType.text),
    SqfEntityField('description', DbType.text),
  ]
);

const tableApplication = SqfEntityTable(
  tableName: 'Application',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  primaryKeyName: 'id',
  useSoftDeleting: true,
  fields: [
    SqfEntityField('createdTime', DbType.datetime),
    SqfEntityField('updatedTime', DbType.datetime),
    SqfEntityField('name', DbType.text),
    SqfEntityField('description', DbType.text),
    SqfEntityField('version', DbType.text),
    SqfEntityField('workStartedDate', DbType.datetime),
    SqfEntityField('workEndedDate', DbType.datetime),
  ]
);

const tableSettings = SqfEntityTable(
  tableName: 'Settings',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  primaryKeyName: 'id',
  useSoftDeleting: true,
  fields: [
    SqfEntityField('createdTime', DbType.datetime),
    SqfEntityField('updatedTime', DbType.datetime),
  ]
);

const tableProjectType = SqfEntityTable(
  tableName: "ProjectType",
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  primaryKeyName: 'id',
  useSoftDeleting: true,
  fields: [
    SqfEntityField('createdTime', DbType.datetime),
    SqfEntityField('updatedTime', DbType.datetime),
    SqfEntityField('name', DbType.text),
    SqfEntityField('description', DbType.text)
  ]
);

@SqfEntityBuilder(myDBModel)
const myDBModel = SqfEntityModel(
  modelName: 'TimeManager',
  databaseName: 'TimeManager.db',
  databaseTables: [ tableWorkItem, tableProject, tableApplication, tableFilter, tableProjectType, tableSettings, tableStatusType ],
  bundledDatabasePath: null,
);