import 'package:hive_flutter/hive_flutter.dart';

class IndividualTasksCRUD {
  final _individualTasksBox = Hive.box('individualTasks');

  void addIndividualTask(String taskName, String taskDetails) {
    //todo generate unique id

    // _individualTasksBox.add(IndividualTask()
    //   ..taskId = 1
    //   ..taskName = taskName
    //   ..taskDetails = taskDetails);

    //todo send to db
  }

  List getAllIndividualTasks() {
    return _individualTasksBox.values.toList();
  }

  void deleteIndividualTask(int taskId) {
    _individualTasksBox.deleteAt(taskId);

    //todo delete from db
  }
}
