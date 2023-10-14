import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            const Text(
              'Name',
              style: TextStyle(
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
            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
