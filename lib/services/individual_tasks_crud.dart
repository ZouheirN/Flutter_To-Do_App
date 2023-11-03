import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class IndividualTasksCRUD {
  final _individualTasksBox = Hive.box('individualTasks');

  List individualTasks = [];

  // void addIndividualTask(String taskName, String taskDetails, Color color) {
  //   individualTasks.add({
  //     'taskName': taskName,
  //     'taskDetails': taskDetails,
  //     'color': color.value,
  //     'taskCompleted': false,
  //   });
  //   print('TASKS: $individualTasks');
  //   //todo send to db
  // }

  void loadIndividualTasks() {
    individualTasks = _individualTasksBox.get("IndividualTasksList");
  }

  void updateIndividualTasks() {
    _individualTasksBox.put("IndividualTasksList", individualTasks);

    //todo send it to db
  }

// List getAllIndividualTasks() {
//   return _individualTasksBox.values.toList();
// }

// void deleteIndividualTask(int taskId) {
//   _individualTasksBox.deleteAt(taskId);
//
//   //todo delete from db
// }
}
