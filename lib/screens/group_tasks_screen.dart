import 'package:flutter/material.dart';

import '../widgets/card.dart';

class GroupTasksScreen extends StatelessWidget {
  const GroupTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TaskCard(color: Colors.red,),
            TaskCard(color: Colors.purple,),
            TaskCard(color: Colors.yellow,),

          ],
        ),
      ),
    );
  }
}
