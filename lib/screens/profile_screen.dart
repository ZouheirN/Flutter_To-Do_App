import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/account_settings_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';
import 'package:todo_app/services/individual_tasks_crud.dart';
import 'package:todo_app/services/notifications.dart';
import 'package:todo_app/services/user_info_crud.dart';

import '../widgets/buttons.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final IndividualTasksCRUD _individualTasksCRUD = IndividualTasksCRUD();

  void _logout(BuildContext context) {
    // show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DialogButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  DialogButton(
                    text: 'Logout',
                    color: 0xFFFF0000,
                    onPressed: () async {
                      UserInfoCRUD().deleteUserInfo();
                      IndividualTasksCRUD().deleteAllIndividualTasks();

                      //cancel all notifications
                      NotificationService.cancelAllNotifications();

                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _accountSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AccountSettingsScreen(),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Finished':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Unfinished':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    _individualTasksCRUD.loadIndividualTasks();
    Map<String, int> statusCounts = {
      'Finished': 0,
      'In Progress': 0,
      'Unfinished': 0
    };

    // Count the occurrences of each status
    for (var task in _individualTasksCRUD.individualTasks) {
      String status = task['status'];
      if (statusCounts.containsKey(status)) {
        statusCounts[status] = statusCounts[status]! + 1;
      }
    }

    // Generate pie chart data
    List<PieChartSectionData> pieChartData = statusCounts.entries.map((entry) {
      String status = entry.key;
      int count = entry.value;

      return PieChartSectionData(
        color: getStatusColor(status),
        value: count.toDouble(),
        title: '$count',
        radius: 100,
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage('https://i.imgur.com/BoN9kdC.png'),
                    // backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: GestureDetector(
                  //     onTap: () {},
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //           border: Border.all(
                  //             width: 3,
                  //             color: Colors.white,
                  //           ),
                  //           borderRadius: const BorderRadius.all(
                  //             Radius.circular(
                  //               50,
                  //             ),
                  //           ),
                  //           color: Colors.white,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               offset: const Offset(1, 3),
                  //               color: Colors.black.withOpacity(
                  //                 0.1,
                  //               ),
                  //               blurRadius: 3,
                  //             ),
                  //           ]),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(2.0),
                  //         child: Icon(
                  //           Icons.edit,
                  //           color: Theme.of(context).primaryColor,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              UserInfoCRUD().getUsername(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.manage_accounts_outlined),
              iconColor: Colors.grey,
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Account'),
              textColor: Colors.grey[800],
              onTap: () => _accountSettings(context),
            ),
            // ListTile(
            //   leading: const Icon(Icons.groups),
            //   iconColor: Colors.grey,
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   title: const Text('Manage Friends'),
            //   textColor: Colors.grey[800],
            //   onTap: () => _accountSettings(context),
            // ),
            const Divider(
              thickness: 0.1,
              indent: 10,
              endIndent: 10,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              iconColor: Colors.grey,
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Log Out'),
              textColor: Colors.grey[800],
              onTap: () => _logout(context),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              width: 220,
              child: PieChart(
                PieChartData(
                  sections: pieChartData,
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  startDegreeOffset: -90,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_individualTasksCRUD.individualTasks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                      color: getStatusColor('Finished'),
                      text: 'Finished',
                      isSquare: false,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: getStatusColor('In Progress'),
                      text: 'In Progress',
                      isSquare: false,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: getStatusColor('Unfinished'),
                      text: 'Unfinished',
                      isSquare: false,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
