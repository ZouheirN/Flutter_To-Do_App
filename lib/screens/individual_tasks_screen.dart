import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';
import 'package:todo_app/services/individual_tasks_crud.dart';

import '../services/http_requests.dart';
import '../widgets/card.dart';
import '../widgets/dialogbox.dart';
import '../widgets/global_snackbar.dart';
import '../widgets/skeleton_shimmer.dart';

class IndividualTasksScreen extends StatefulWidget {
  final bool isFirstTimeLoggingIn;

  const IndividualTasksScreen({
    super.key, required this.isFirstTimeLoggingIn,
  });

  @override
  State<IndividualTasksScreen> createState() => _IndividualTasksScreenState();
}

class _IndividualTasksScreenState extends State<IndividualTasksScreen> {
  bool _isFabVisible = true;
  late bool _isLoading;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final _individualTasksBox = Hive.box('individualTasks');
  final IndividualTasksCRUD _individualTasksCRUD = IndividualTasksCRUD();

  // dialog box variables
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController();
  final _priorityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onRefresh() async {
    dynamic tasks = await getTasksFromDB();

    print(tasks);

    if (tasks == ReturnTypes.invalidToken) {
      invalidTokenResponse(context);
      return;
    }

    if (tasks == ReturnTypes.error || tasks == ReturnTypes.fail) {
      showGlobalSnackBar('Error getting tasks. Please try again.');
      _refreshController.refreshFailed();
      return;
    }

    tasks = tasks as List<dynamic>;

    if (tasks.isEmpty) {
      showGlobalSnackBar('No tasks found.');
      _refreshController.refreshFailed();
      return;
    }

    _individualTasksCRUD.deleteAllIndividualTasks();

    for (var task in tasks) {
      _individualTasksCRUD.individualTasks.add({
        'id': task['_id'],
        'title': task['title'],
        'description': task['description'],
        'color': task['color'],
        'priority': task['priority'],
        'status': task['status'],
        'creationDate': task['createdAt'],
      });
    }

    _individualTasksCRUD.updateIndividualTasks();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void getData() async {
    if (_individualTasksBox.get('IndividualTasksList') == null) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } else {
      _individualTasksCRUD.loadIndividualTasks();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void getDataFromDB() async {
    dynamic tasks = await getTasksFromDB();

    print(tasks);

    if (tasks == ReturnTypes.invalidToken) {
      invalidTokenResponse(context);
      return;
    }

    if (tasks == ReturnTypes.error || tasks == ReturnTypes.fail) {
      showGlobalSnackBar('Error getting tasks. Please try again.');
      return;
    }

    tasks = tasks as List<dynamic>;

    _individualTasksCRUD.deleteAllIndividualTasks();

    for (var task in tasks) {
      _individualTasksCRUD.individualTasks.add({
        'id': task['_id'],
        'title': task['title'],
        'description': task['description'],
        'color': task['color'],
        'priority': task['priority'],
        'status': task['status'],
        'creationDate': task['createdAt'],
      });
    }

    _individualTasksCRUD.updateIndividualTasks();
    setState(() {
      _isLoading = false;
    });
  }

  Future<FutureOr<void>> statusChanged(int? value, int index) async {
    String status = 'Unfinished';
    if (value == 1) status = 'In Progress';
    if (value == 2) status = 'Finished';

    //todo send it to db
    await Future.delayed(const Duration(seconds: 1));
    //todo wait for response

    setState(() {
      _individualTasksCRUD.individualTasks[index]['status'] = status;
    });
    _individualTasksCRUD.updateIndividualTasks();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        nameController: _nameController,
        descriptionController: _descriptionController,
        colorController: _colorController,
        priorityController: _priorityController,
        formKey: _formKey,
        onAdd: () => addNewTask(context),
        onCancel: () => onCancel(context),
      ),
    );
  }

  void onCancel(BuildContext context) {
    Navigator.pop(context);
    _nameController.clear();
    _descriptionController.clear();
    _colorController.clear();
    _priorityController.clear();
  }

  Future<void> addNewTask(BuildContext context) async {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adding', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          ],
        ),
      ),
    );

    final taskIdAndDate = await addTaskToDB(
      _nameController.text,
      _descriptionController.text,
      _priorityController.text,
      _colorController.text,
      context,
    );

    if (taskIdAndDate == ReturnTypes.invalidToken) {
      invalidTokenResponse(context);
      return;
    }

    setState(() {
      _individualTasksCRUD.individualTasks.add({
        'id': taskIdAndDate[0],
        'title': _nameController.text,
        'description': _descriptionController.text,
        'color': _colorController.text,
        'priority':
            _priorityController.text == '' ? 'Low' : _priorityController.text,
        'status': 'Unfinished',
        'creationDate': taskIdAndDate[1],
      });
      _nameController.clear();
      _descriptionController.clear();
      _colorController.clear();
      _priorityController.clear();
    });
    Navigator.pop(context);
    Navigator.pop(context);
    _individualTasksCRUD.updateIndividualTasks();
  }

  Future<void> deleteTask(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deleting Task', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          ],
        ),
      ),
    );

    final deleteResponse = await deleteTaskFromDB(
        _individualTasksCRUD.individualTasks[index]['id'], context);

    if (deleteResponse == ReturnTypes.invalidToken) {
      invalidTokenResponse(context);
      return;
    }

    Navigator.pop(context);

    if (deleteResponse != ReturnTypes.success) {
      showGlobalSnackBar('Error deleting task. Please try again.');
      return;
    }

    setState(() {
      _individualTasksCRUD.individualTasks.removeAt(index);
    });
    _individualTasksCRUD.updateIndividualTasks();
  }

  @override
  void initState() {
    _isLoading = true;
    // _individualTasksBox.delete('IndividualTasksList');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isFirstTimeLoggingIn) {
      getDataFromDB();
    }else {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              onPressed: () {
                createNewTask();
              },
              tooltip: 'Add Todo',
              hoverColor: const Color(0xFF096B67),
              focusColor: const Color(0xFF24A09B),
              splashColor: const Color(0xFF064E4B),
              child: const Icon(Icons.add),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: _isLoading
            ? ListView.separated(
                itemBuilder: (context, index) => Skeleton(
                  height: 140,
                  width: MediaQuery.sizeOf(context).width - 40,
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: 5,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(height: 20),
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Today',
                  //       style: TextStyle(
                  //         fontSize: 26,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  Expanded(
                    child: NotificationListener<UserScrollNotification>(
                      onNotification: (notification) {
                        if (notification.direction == ScrollDirection.forward) {
                          if (!_isFabVisible) {
                            setState(() => _isFabVisible = true);
                          }
                        } else if (notification.direction ==
                            ScrollDirection.reverse) {
                          if (_isFabVisible) {
                            setState(() => _isFabVisible = false);
                          }
                        }

                        return true;
                      },
                      child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        header: const ClassicHeader(),
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            int colorInt = int.parse(
                                _individualTasksCRUD.individualTasks[index]
                                    ['color'],
                                radix: 16);

                            return TaskCard(
                              taskName: _individualTasksCRUD
                                  .individualTasks[index]['title'],
                              taskDetails: _individualTasksCRUD
                                  .individualTasks[index]['description'],
                              color: colorInt,
                              taskStatus: _individualTasksCRUD
                                  .individualTasks[index]['status'],
                              priority: _individualTasksCRUD
                                  .individualTasks[index]['priority'],
                              taskId: _individualTasksCRUD
                                  .individualTasks[index]['id'],
                              creationDate: _individualTasksCRUD
                                  .individualTasks[index]['creationDate'],
                              onChanged: (value) => statusChanged(value, index),
                              deleteFunction: (context) => deleteTask(index),
                            );
                          },
                          itemCount:
                              _individualTasksCRUD.individualTasks.length,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
