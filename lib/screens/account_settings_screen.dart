import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              iconColor: Colors.grey,
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Change Username'),
              textColor: Colors.grey[800],
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              iconColor: Colors.grey,
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Change Password'),
              textColor: Colors.grey[800],
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              iconColor: Colors.grey,
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Change Email'),
              textColor: Colors.grey[800],
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              iconColor: Colors.grey,
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Change Phone Number'),
              textColor: Colors.grey[800],
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              iconColor: Colors.grey,
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Change Profile Picture'),
              textColor: Colors.grey[800],
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
