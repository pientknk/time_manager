import 'package:flutter/material.dart';
import 'package:time_manager/model/common/abstracts.dart';

class OptionsFormInfo {
  TextEditingController controller;
  List<Options> options;
  int id;

  OptionsFormInfo({@required TextEditingController controller, List<Options> options, int id}){
    this.controller = controller;
    this.options = options;
    this.id = id;
  }
}