import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Color color;

  const TaskCard({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
            const ListTile(
              title: Text('Task Name'),
              subtitle: Text('Task Details'),
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
    );
  }
}
