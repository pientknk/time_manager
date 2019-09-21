import 'package:flutter/material.dart';
import 'dart:io';

abstract class Data {
  bool save();
  T read<T>();
  bool update();
  bool delete();

  Future<int> sqlLiteInsert();
  Future<T> sqlLiteSelect<T>();
  Future<List<T>> sqlLiteSelectAll<T>();
  Future<int> sqlLiteUpdate();
  Future<int> sqlLiteDelete();
}


