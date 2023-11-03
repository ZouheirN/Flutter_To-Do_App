import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/services/individual_tasks_crud.dart';

import '../widgets/card.dart';
import '../widgets/dialogbox.dart';
import '../widgets/skeleton_shimmer.dart';

class IndividualTasksScreen extends StatefulWidget {
  IndividualTasksScreen({
    super.key,
  });

  @override
  State<IndividualTasksScreen> createState() => _IndividualTasksScreenState();
}

class _IndividualTasksScreenState extends State<IndividualTasksScreen> {
  late bool _isLoading;

  // late bool _isEmpty = false;
  final _individualTasksBox = Hive.box('individualTasks');
  final IndividualTasksCRUD _individualTasksCRUD = IndividualTasksCRUD();

  // dialog box variables
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController();

  void getData() async {
    await Future.delayed(const Duration(seconds: 1));

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

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      _individualTasksCRUD.individualTasks[index]['taskCompleted'] = value!;
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
        onAdd: () => addNewTask(),
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void addNewTask() {
    setState(() {
      _individualTasksCRUD.individualTasks.add({
        'taskName': _nameController.text,
        'taskDetails': _descriptionController.text,
        'color': _colorController.text,
        'taskCompleted': false,
      });
      _nameController.clear();
      _descriptionController.clear();
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewTask();
        },
        tooltip: 'Add Todo',
        hoverColor: const Color(0xFF096B67),
        focusColor: const Color(0xFF24A09B),
        splashColor: const Color(0xFF064E4B),
        child: const Icon(Icons.add),
      ),
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
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        int colorInt = int.parse(
                            _individualTasksCRUD.individualTasks[index]
                                ['color'],
                            radix: 16);

                        return TaskCard(
                          taskName: _individualTasksCRUD.individualTasks[index]
                              ['taskName'],
                          taskDetails: _individualTasksCRUD
                              .individualTasks[index]['taskDetails'],
                          color: colorInt,
                          taskCompleted: _individualTasksCRUD
                              .individualTasks[index]['taskCompleted'],
                          onChanged: (value) => checkBoxChanged(value, index),
                          deleteFunction: (context) => deleteTask(index),
                        );
                      },
                      itemCount: _individualTasksCRUD.individualTasks.length,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
