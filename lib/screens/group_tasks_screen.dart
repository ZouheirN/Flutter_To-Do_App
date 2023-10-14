import 'package:flutter/material.dart';

import '../widgets/card.dart';

class GroupTasksScreen extends StatelessWidget {
  const GroupTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Row(
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
            const SizedBox(height: 20),
            TaskCard(color: Colors.red,),
            TaskCard(color: Colors.purple,),
            TaskCard(color: Colors.yellow,),

          ],
        ),
      ),
    );
  }
}
