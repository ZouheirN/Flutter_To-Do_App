import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final String taskId;
  final String taskName;
  final String taskDetails;
  final int color;
  final String taskStatus;
  final String priority;
  final String creationDate;
  final String estimatedDate;
  final FutureOr<void> Function(int)? onChanged;
  final Function(BuildContext)? deleteFunction;

  const TaskCard({
    super.key,
    required this.color,
    required this.taskName,
    required this.taskDetails,
    required this.taskStatus,
    required this.onChanged,
    required this.deleteFunction,
    required this.priority,
    required this.taskId,
    required this.creationDate,
    required this.estimatedDate,
  });

  int statusToInt(String status) {
    switch (status) {
      case 'Unfinished':
        return 0;
      case 'In Progress':
        return 1;
      case 'Finished':
        return 2;
      default:
        return 0;
    }
  }

  // String convertISO8601ToReadableString(String iso8601String) {
  //   // Parse the ISO 8601 date string
  //   DateTime dateTime = DateTime.parse(iso8601String).toUtc();
  //
  //   // Converting to local time
  //   dateTime = dateTime.toLocal();
  //
  //   // Format the DateTime as a readable string
  //   final formattedString = DateFormat('MMMM d, y - HH:mm').format(dateTime);
  //
  //   return formattedString;
  // }

  String formatDateString(String inputString) {
    DateTime dateTime = DateTime.parse(inputString);

    // if (toLocal) {
    dateTime = dateTime.toLocal();
    // }
    return DateFormat('E MMM d, y - HH:mm').format(dateTime);
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
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                taskName,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Priority: $priority',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedToggleSwitch<int>.rolling(
                        current: statusToInt(taskStatus),
                        onChanged: onChanged,
                        values: const [0, 1, 2],
                        spacing: 0,
                        iconList: const [
                          Icon(Icons.hourglass_empty_rounded, size: 30),
                          Icon(Icons.hourglass_top_rounded, size: 30),
                          Icon(Icons.hourglass_full_rounded, size: 30),
                        ],
                        style: ToggleStyle(
                          borderColor: const Color(0xFFDEE3EB),
                          backgroundColor: const Color(0xFFF4F5F7),
                          indicatorColor: Color(color),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(taskDetails),
                // subtitle: Text('Task Details'),
              ),
              const Divider(thickness: 0.1, indent: 20, endIndent: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Created On: ${formatDateString(creationDate)}'),
                        Text(
                            'Estimated Date: ${formatDateString(estimatedDate)}'),
                      ],
                    ),
                    // Text('Priority: $priority'),
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
