import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:todo_app/screens/group_tasks_screen.dart';
import 'package:todo_app/screens/individual_tasks_screen.dart';
import 'package:todo_app/screens/otp_screen.dart';
import 'package:todo_app/screens/settings_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    IndividualTasksScreen(),
    GroupTasksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.grey,
            activeColor: Theme.of(context).primaryColor,
            tabBackgroundColor: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            gap: 8,
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.person,
                text: 'Individual Tasks',
              ),
              GButton(
                icon: Icons.group,
                text: 'Group Tasks',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1) ? FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}
