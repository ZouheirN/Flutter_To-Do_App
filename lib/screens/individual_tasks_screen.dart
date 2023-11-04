import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo_app/services/individual_tasks_crud.dart';

import '../widgets/card.dart';
import '../widgets/dialogbox.dart';
import '../widgets/skeleton_shimmer.dart';

class IndividualTasksScreen extends StatefulWidget {
  const IndividualTasksScreen({
    super.key,
  });

  @override
  State<IndividualTasksScreen> createState() => _IndividualTasksScreenState();
}

class _IndividualTasksScreenState extends State<IndividualTasksScreen> {
  bool isFabVisible = true;
  late bool _isLoading;

  final _individualTasksBox = Hive.box('individualTasks');
  final IndividualTasksCRUD _individualTasksCRUD = IndividualTasksCRUD();

  // dialog box variables
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController();
  final _priorityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void getData() async {
    // todo get data from db

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
    await Future.delayed(const Duration(seconds: 5));

    // final taskID = await addTaskToDB(
    //     _nameController.text,
    //     _descriptionController.text,
    //     _priorityController.text,
    //     _colorController.text);

    String taskID = "1";

    setState(() {
      _individualTasksCRUD.individualTasks.add({
        'id': taskID,
        'title': _nameController.text,
        'description': _descriptionController.text,
        'color': _colorController.text,
        'priority':
            _priorityController.text == '' ? 'Low' : _priorityController.text,
        'status': 'Unfinished',
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

  void deleteTask(int index) {
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isFabVisible
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
                          if (!isFabVisible) {
                            setState(() => isFabVisible = true);
                          }
                        } else if (notification.direction ==
                            ScrollDirection.reverse) {
                          if (isFabVisible) {
                            setState(() => isFabVisible = false);
                          }
                        }

                        return true;
                      },
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
                            taskId: _individualTasksCRUD.individualTasks[index]
                                ['id'],
                            onChanged: (value) => statusChanged(value, index),
                            deleteFunction: (context) => deleteTask(index),
                          );
                        },
                        itemCount: _individualTasksCRUD.individualTasks.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
