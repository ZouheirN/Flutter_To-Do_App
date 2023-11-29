import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';
import 'package:todo_app/services/individual_tasks_crud.dart';
import 'package:todo_app/widgets/dialogs.dart';

import '../services/http_requests.dart';
import '../services/notifications.dart';
import '../widgets/card.dart';
import '../widgets/dialogbox.dart';
import '../widgets/global_snackbar.dart';
import '../widgets/skeleton_shimmer.dart';

class IndividualTasksScreen extends StatefulWidget {
  const IndividualTasksScreen({
    super.key,
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
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onRefresh() async {
    dynamic tasks = await getTasksFromDB();

    if (tasks == ReturnTypes.invalidToken) {
      if (!mounted) return;
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
      // set tasks to empty
      if (!mounted) return;
      setState(() {
        _individualTasksCRUD.individualTasks = [];
      });
      _individualTasksCRUD.updateIndividualTasks();
      return;
    }

    _individualTasksCRUD.deleteAllIndividualTasks();

    // delete all notifications and set new ones
    NotificationService.cancelAllNotifications();

    for (var task in tasks) {
      // calculate time from now to estimated date
      final timeDifference =
          DateTime.parse(task['estimatedDate']).difference(DateTime.now());

      // set interval to interval - 1 day
      int interval = timeDifference.inSeconds - 86400;

      // set another interval for - 1 hour
      int interval2 = timeDifference.inSeconds - 3600;

      // set another interval at the same time of the eta date
      int interval3 = timeDifference.inSeconds;

      if (interval > 5 && task['status'] != 'Finished') {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(task['_id']),
          title: 'Task Reminder',
          body: 'Have you finished this task: ${task['title']}?',
          scheduled: true,
          interval: interval,
        );
      }

      if (interval2 > 5 && task['status'] != 'Finished') {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(task['_id']) + 1,
          title: 'Task Reminder',
          body: 'Have you finished this task: ${task['title']}?',
          scheduled: true,
          interval: interval2,
        );
      }

      if (interval3 > 5 && task['status'] != 'Finished') {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(task['_id']) + 2,
          title: 'Task Reminder',
          body: 'Have you finished this task: ${task['title']}?',
          scheduled: true,
          interval: interval3,
        );
      }
    }

    if (!mounted) return;
    setState(() {
      for (var task in tasks) {
        _individualTasksCRUD.individualTasks.add({
          'id': task['_id'],
          'title': task['title'],
          'description': task['description'],
          'color': task['color'],
          'priority': task['priority'],
          'status': task['status'],
          'creationDate': task['createdAt'],
          'estimatedDate': task['estimatedDate'],
        });
      }
    });

    _individualTasksCRUD.updateIndividualTasks();
    _refreshController.refreshCompleted();
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

    if (tasks == ReturnTypes.invalidToken) {
      if (!mounted) return;
      invalidTokenResponse(context);
      return;
    }

    if (tasks == ReturnTypes.error || tasks == ReturnTypes.fail) {
      showGlobalSnackBar('Error getting tasks. Please try again.');
      return;
    }

    tasks = tasks as List<dynamic>;

    _individualTasksCRUD.deleteAllIndividualTasks();

    // delete all notifications and set new ones
    NotificationService.cancelAllNotifications();

    for (var task in tasks) {
      // calculate time from now to estimated date
      final timeDifference =
          DateTime.parse(task['estimatedDate']).difference(DateTime.now());

      // set interval to interval - 1 day
      int interval = timeDifference.inSeconds - 86400;

      // set another interval for - 1 hour
      int interval2 = timeDifference.inSeconds - 3600;

      // set another interval at the same time of the eta date
      int interval3 = timeDifference.inSeconds;

      if (interval > 5 && task['status'] != 'Finished') {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(task['_id']),
          title: 'Task Reminder',
          body: 'Have you finished this task: ${task['title']}?',
          scheduled: true,
          interval: interval,
        );
      }

      if (interval2 > 5 && task['status'] != 'Finished') {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(task['_id']) + 1,
          title: 'Task Reminder',
          body: 'Have you finished this task: ${task['title']}?',
          scheduled: true,
          interval: interval2,
        );
      }

      if (interval3 > 5 && task['status'] != 'Finished') {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(task['_id']) + 2,
          title: 'Task Reminder',
          body: 'Have you finished this task: ${task['title']}?',
          scheduled: true,
          interval: interval3,
        );
      }
    }

    if (!mounted) return;
    setState(() {
      for (var task in tasks) {
        _individualTasksCRUD.individualTasks.add({
          'id': task['_id'],
          'title': task['title'],
          'description': task['description'],
          'color': task['color'],
          'priority': task['priority'],
          'status': task['status'],
          'creationDate': task['createdAt'],
          'estimatedDate': task['estimatedDate']
        });
      }
      _isLoading = false;
    });

    _individualTasksCRUD.updateIndividualTasks();
  }

  Future<FutureOr<void>?> statusChanged(int? value, int index) async {
    String status = 'Unfinished';
    if (value == 1) status = 'In Progress';
    if (value == 2) status = 'Finished';

    // send it to db
    final response = await editTaskStatusFromDB(
        _individualTasksCRUD.individualTasks[index]['id'], status);

    if (response == ReturnTypes.invalidToken) {
      if (!mounted) return null;
      invalidTokenResponse(context);
      return null;
    } else if (response == ReturnTypes.error || response == ReturnTypes.fail) {
      getDataFromDB();
      showGlobalSnackBar('Error changing task status. Auto-refreshing tasks.');
      return null;
    }

    if (status == 'Finished') {
      // Cancel -1 day notification
      NotificationService.cancelNotification(
          stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']));
      // Cancel -1 hour notification
      NotificationService.cancelNotification(
          stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']) +
              1);
      // Cancel same time notification
      NotificationService.cancelNotification(
          stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']) +
              2);
    }

    setState(() {
      _individualTasksCRUD.individualTasks[index]['status'] = status;
    });
    _individualTasksCRUD.updateIndividualTasks();
  }

  void createNewTask() {
    showGeneralDialog(
      context: context,
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;

        return Transform(
          transform: Matrix4.translationValues(0.0, -curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: DialogBox(
              nameController: _nameController,
              descriptionController: _descriptionController,
              colorController: _colorController,
              priorityController: _priorityController,
              dateController: _dateController,
              formKey: _formKey,
              onAdd: () => addNewTask(context),
              onCancel: () => onCancel(context),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return const Text('PAGE BUILDER');
      },
    );
  }

  void onCancel(BuildContext context) {
    Navigator.pop(context);
    _nameController.clear();
    _descriptionController.clear();
    _colorController.clear();
    _priorityController.clear();
    _dateController.clear();
  }

  String convertStringToIso8601(String dateString) {
    // Define the input format
    DateFormat inputFormat = DateFormat("E MMM d, y - HH:mm", "en_US");

    // Parse the input string
    DateTime dateTime = inputFormat.parse(dateString).toUtc();

    // Format the DateTime as ISO 8601 string
    String iso8601String = dateTime.toIso8601String();

    return iso8601String;
  }

  int stringToUniqueInt(String input) {
    int hashValue = input.hashCode;

    return hashValue.abs();
  }

  Future<void> addNewTask(BuildContext context) async {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;

    showLoadingDialog('Adding Task', context);

    final taskIdAndDate = await addTaskToDB(
      _nameController.text.trim(),
      _descriptionController.text.trim(),
      _priorityController.text.trim(),
      _colorController.text.trim(),
      convertStringToIso8601(_dateController.text.trim()),
    );

    if (taskIdAndDate == ReturnTypes.invalidToken) {
      if (!mounted) return;
      invalidTokenResponse(context);
      return;
    } else if (taskIdAndDate == ReturnTypes.fail ||
        taskIdAndDate == ReturnTypes.error) {
      showGlobalSnackBar('Error adding task. Please try again.');
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    // calculate time from now to estimated date
    final timeDifference =
        DateTime.parse(convertStringToIso8601(_dateController.text))
            .difference(DateTime.now());

    // set interval to interval - 1 day
    int interval = timeDifference.inSeconds - 86400;

    // set another interval for - 1 hour
    int interval2 = timeDifference.inSeconds - 3600;

    // set another interval at the same time of the eta date
    int interval3 = timeDifference.inSeconds;

    if (interval > 5) {
      // schedule notification
      await NotificationService.showNotification(
        id: stringToUniqueInt(taskIdAndDate[0]),
        title: 'Task Reminder',
        body: 'Have you finished this task: ${_nameController.text}?',
        scheduled: true,
        interval: interval,
      );
    }

    if (interval2 > 5) {
      // schedule notification
      await NotificationService.showNotification(
        id: stringToUniqueInt(taskIdAndDate[0]) + 1,
        title: 'Task Reminder',
        body: 'Have you finished this task: ${_nameController.text}?',
        scheduled: true,
        interval: interval2,
      );
    }

    if (interval3 > 5) {
      // schedule notification
      await NotificationService.showNotification(
        id: stringToUniqueInt(taskIdAndDate[0]) + 2,
        title: 'Task Reminder',
        body: 'Have you finished this task: ${_nameController.text}?',
        scheduled: true,
        interval: interval3,
      );
    }

    setState(() {
      _individualTasksCRUD.individualTasks.add({
        'id': taskIdAndDate[0],
        'title': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'color': _colorController.text.trim(),
        'priority': _priorityController.text.trim() == ''
            ? 'Low'
            : _priorityController.text.trim(),
        'status': 'Unfinished',
        'creationDate': taskIdAndDate[1],
        'estimatedDate': convertStringToIso8601(_dateController.text.trim()),
      });
      _nameController.clear();
      _descriptionController.clear();
      _colorController.clear();
      _priorityController.clear();
      _dateController.clear();
    });
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pop(context);
    _individualTasksCRUD.updateIndividualTasks();
  }

  Future<void> deleteTask(int index) async {
    showLoadingDialog('Deleting Task', context);

    final deleteResponse = await deleteTaskFromDB(
        _individualTasksCRUD.individualTasks[index]['id']);

    if (deleteResponse == ReturnTypes.invalidToken) {
      if (!mounted) return;
      invalidTokenResponse(context);
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);

    if (deleteResponse != ReturnTypes.success) {
      getDataFromDB();
      showGlobalSnackBar('Error deleting task. Auto-refreshing tasks.');
      return;
    }

    // Cancel -1 day notification
    NotificationService.cancelNotification(
        stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']));
    // Cancel -1 hour notification
    NotificationService.cancelNotification(
        stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']) +
            1);
    // Cancel same time notification
    NotificationService.cancelNotification(
        stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']) +
            2);

    setState(() {
      _individualTasksCRUD.individualTasks.removeAt(index);
    });
    _individualTasksCRUD.updateIndividualTasks();
  }

  String formatDateString(String inputString) {
    DateTime dateTime = DateTime.parse(inputString);

    // if (toLocal) {
    dateTime = dateTime.toLocal();
    // }
    return DateFormat('E MMM d, y - HH:mm').format(dateTime);
  }

  Future<void> editTask(int index) async {
    _nameController.text = _individualTasksCRUD.individualTasks[index]['title'];
    _descriptionController.text =
        _individualTasksCRUD.individualTasks[index]['description'];
    _colorController.text =
        _individualTasksCRUD.individualTasks[index]['color'];
    _priorityController.text =
        _individualTasksCRUD.individualTasks[index]['priority'];
    _dateController.text = formatDateString(
        _individualTasksCRUD.individualTasks[index]
            ['estimatedDate']); // convertISO8601ToReadableString

    showDialog(
      context: context,
      builder: (context) => DialogBox(
        nameController: _nameController,
        descriptionController: _descriptionController,
        colorController: _colorController,
        priorityController: _priorityController,
        dateController: _dateController,
        formKey: _formKey,
        onCancel: () => onCancel(context),
        onEdit: () => editTaskFromDialog(index, context),
      ),
    );
  }

  Future<void> editTaskFromDialog(int index, BuildContext context) async {
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) return;

    showLoadingDialog('Editing Task', context);

    final editResponse = await editTaskFromDB(
      _individualTasksCRUD.individualTasks[index]['id'],
      _nameController.text.trim(),
      _descriptionController.text.trim(),
      _priorityController.text.trim(),
      convertStringToIso8601(_dateController.text.trim()),
      _colorController.text.trim(),
    );

    if (editResponse == ReturnTypes.invalidToken) {
      if (!mounted) return;
      invalidTokenResponse(context);
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);

    if (editResponse != ReturnTypes.success) {
      getDataFromDB();
      showGlobalSnackBar('Error editing task. Auto-refreshing tasks.');
      return;
    }

    // check if estimated date is changed, and if it is, cancel all notifications and set new ones
    if (_individualTasksCRUD.individualTasks[index]['estimatedDate'] !=
        convertStringToIso8601(_dateController.text.trim())) {
      // Cancel -1 day notification
      NotificationService.cancelNotification(
          stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']));
      // Cancel -1 hour notification
      NotificationService.cancelNotification(
          stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']) +
              1);
      // Cancel same time notification
      NotificationService.cancelNotification(
          stringToUniqueInt(_individualTasksCRUD.individualTasks[index]['id']) +
              2);

      // calculate time from now to estimated date
      final timeDifference =
          DateTime.parse(convertStringToIso8601(_dateController.text))
              .difference(DateTime.now());

      // set interval to interval - 1 day
      int interval = timeDifference.inSeconds - 86400;

      // set another interval for - 1 hour
      int interval2 = timeDifference.inSeconds - 3600;

      // set another interval at the same time of the eta date
      int interval3 = timeDifference.inSeconds;

      if (interval > 5) {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(
              _individualTasksCRUD.individualTasks[index]['id']),
          title: 'Task Reminder',
          body: 'Have you finished this task: ${_nameController.text}?',
          scheduled: true,
          interval: interval,
        );
      }

      if (interval2 > 5) {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(
                  _individualTasksCRUD.individualTasks[index]['id']) +
              1,
          title: 'Task Reminder',
          body: 'Have you finished this task: ${_nameController.text}?',
          scheduled: true,
          interval: interval2,
        );
      }

      if (interval3 > 5) {
        // schedule notification
        await NotificationService.showNotification(
          id: stringToUniqueInt(
                  _individualTasksCRUD.individualTasks[index]['id']) +
              2,
          title: 'Task Reminder',
          body: 'Have you finished this task: ${_nameController.text}?',
          scheduled: true,
          interval: interval3,
        );
      }
    }

    setState(() {
      _individualTasksCRUD.individualTasks[index]['title'] =
          _nameController.text.trim();
      _individualTasksCRUD.individualTasks[index]['description'] =
          _descriptionController.text.trim();
      _individualTasksCRUD.individualTasks[index]['color'] =
          _colorController.text.trim();
      _individualTasksCRUD.individualTasks[index]['priority'] =
          _priorityController.text.trim() == ''
              ? 'Low'
              : _priorityController.text.trim();
      _individualTasksCRUD.individualTasks[index]['estimatedDate'] =
          convertStringToIso8601(_dateController.text.trim());
      _nameController.clear();
      _descriptionController.clear();
      _colorController.clear();
      _priorityController.clear();
      _dateController.clear();
    });
    if (!mounted) return;
    Navigator.pop(context);
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
    if (_individualTasksBox.get('IndividualTasksList') == null ||
        _individualTasksBox.get('IndividualTasksList').isEmpty) {
      getDataFromDB();
    } else {
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
                      child: AnimationLimiter(
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          header: const ClassicHeader(),
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              // reorder list by eta date
                              _individualTasksCRUD.individualTasks.sort(
                                (a, b) => DateTime.parse(a['estimatedDate'])
                                    .compareTo(
                                        DateTime.parse(b['estimatedDate'])),
                              );

                              int colorInt = int.parse(
                                  _individualTasksCRUD.individualTasks[index]
                                      ['color'],
                                  radix: 16);

                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: TaskCard(
                                      taskName: _individualTasksCRUD
                                          .individualTasks[index]['title'],
                                      taskDetails: _individualTasksCRUD
                                              .individualTasks[index]
                                          ['description'],
                                      color: colorInt,
                                      taskStatus: _individualTasksCRUD
                                          .individualTasks[index]['status'],
                                      priority: _individualTasksCRUD
                                          .individualTasks[index]['priority'],
                                      taskId: _individualTasksCRUD
                                          .individualTasks[index]['id'],
                                      creationDate: _individualTasksCRUD
                                              .individualTasks[index]
                                          ['creationDate'],
                                      estimatedDate: _individualTasksCRUD
                                              .individualTasks[index]
                                          ['estimatedDate'],
                                      onChanged: (value) =>
                                          statusChanged(value, index),
                                      deleteFunction: (context) =>
                                          deleteTask(index),
                                      editFunction: (context) =>
                                          editTask(index),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount:
                                _individualTasksCRUD.individualTasks.length,
                          ),
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
