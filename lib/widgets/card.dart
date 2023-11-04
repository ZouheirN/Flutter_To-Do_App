import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskCard extends StatelessWidget {
  final String taskId;
  final String taskName;
  final String taskDetails;
  final int color;
  final String taskStatus;
  final String priority;
  Function(int?)? onChanged;
  Function(BuildContext)? deleteFunction;

  TaskCard({
    super.key,
    required this.color,
    required this.taskName,
    required this.taskDetails,
    required this.taskStatus,
    required this.onChanged,
    required this.deleteFunction,
    required this.priority,
    required this.taskId,
  });

  int priorityToInt(String priority) {
    switch (priority) {
      case 'Low':
        return 0;
      case 'Medium':
        return 1;
      case 'High':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(8),
            )
          ],
        ),
        child: Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Color(color),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        taskName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: taskStatus == 'Finished'
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      AnimatedToggleSwitch<int>.size(
                        current: priorityToInt(priority),
                        onChanged: onChanged,
                        loading: false,
                        values: const [0, 1, 2],
                        spacing: 5,
                        selectedIconScale: 0.8,
                        iconList: const [
                          Icon(Icons.hourglass_empty,
                              size: 30, color: Colors.red),
                          Icon(Icons.hourglass_full,
                              size: 30, color: Colors.orange),
                          Icon(Icons.check_circle,
                              size: 30, color: Colors.green),
                        ],
                        style: const ToggleStyle(
                          borderColor: Color(0xFFDEE3EB),
                        ),
                      )
                      // Checkbox(
                      //   value: taskCompleted,
                      //   onChanged: onChanged,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(2.0),
                      //   ),
                      //   side: MaterialStateBorderSide.resolveWith(
                      //     (states) =>
                      //         const BorderSide(width: 1.0, color: Colors.white),
                      //   ),
                      //   activeColor: Colors.white,
                      //   checkColor: Color(color),
                      // ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(taskDetails),
                // subtitle: Text('Task Details'),
              ),
              const Divider(thickness: 0.1, indent: 20, endIndent: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date'),
                    Text('Some options'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
