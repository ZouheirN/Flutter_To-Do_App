import 'package:flutter/material.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:todo_app/screens/group_tasks_screen.dart';
import 'package:todo_app/screens/individual_tasks_screen.dart';
import 'package:todo_app/screens/settings_screen.dart';
import 'package:todo_app/services/local_auth_api.dart';
import 'package:todo_app/services/user_info_crud.dart';
import 'package:todo_app/widgets/buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isAuthenticated = false;

  final List<Widget> _widgetOptions = [
    IndividualTasksScreen(),
    const GroupTasksScreen(),
    const SettingsScreen(),
  ];

  void _authenticateOnStart() async {
    final isAuthenticated = await LocalAuthApi.authenticate();

    if (isAuthenticated) {
      setState(() {
        _isAuthenticated = true;
      });
    }
  }

  @override
  void initState() {
    if (UserInfoCRUD().getAuthEnabled()) {
      _authenticateOnStart();
    } else {
      _isAuthenticated = true;
    }
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You have Biometric Authentication enabled. Please authenticate to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                    text: 'Authenticate', onPressed: _authenticateOnStart),
              ],
            ),
          ),
        ),
      );
    }

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
      // floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           if (_selectedIndex == 0) {
      //             createNewTask();
      //             // IndividualTasksCRUD().addIndividualTask('taskName', 'taskDetails');
      //           } else if (_selectedIndex == 1) {}
      //         },
      //         tooltip: 'Add Todo',
      //         hoverColor: const Color(0xFF096B67),
      //         focusColor: const Color(0xFF24A09B),
      //         splashColor: const Color(0xFF064E4B),
      //         child: const Icon(Icons.add),
      //       )
      //     : null,
    );
  }
}
