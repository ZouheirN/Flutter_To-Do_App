import 'package:flutter/material.dart';
import 'package:todo_app/screens/account_settings_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';
import 'package:todo_app/services/user_info_crud.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) {
    userInfoCRUD().deleteuserInfo();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }

  void _accountSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AccountSettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                // backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              userInfoCRUD().getUsername(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
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
          ],
        ),
      ),
    );
  }
}
