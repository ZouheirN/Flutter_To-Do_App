import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndividualTasksCRUD {
  final _individualTasksBox = Hive.box('individualTasks');

  List individualTasks = [];

  void loadIndividualTasks() {
    individualTasks = _individualTasksBox.get("IndividualTasksList");
  }

  void updateIndividualTasks() {
    _individualTasksBox.put("IndividualTasksList", individualTasks);
  }

  void deleteAllIndividualTasks() {
    _individualTasksBox.delete("IndividualTasksList");
  }
}
