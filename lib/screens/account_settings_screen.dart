import 'package:flutter/material.dart';
import 'package:todo_app/services/user_info_crud.dart';
import 'package:todo_app/widgets/buttons.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool is2FAEnabled = false;

  @override
  void initState() {
    super.initState();
    is2FAEnabled = UserInfoCRUD().getUsername() == 'zouheir';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Full Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                filled: true,
                fillColor: Color(0xFFF4F5F7),
                hintText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFFDEE3EB), width: 2),
                ),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                filled: true,
                fillColor: Color(0xFFF4F5F7),
                hintText: 'name@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFFDEE3EB), width: 2),
                ),
              ),
              enabled: false,
            ),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SecondaryButton(text: 'Change Password', onPressed: () {}),
            const SizedBox(height: 20),
            const Divider(
              thickness: 0.1,
              indent: 10,
              endIndent: 10,
            ),
            ListTile(
              leading: const Icon(Icons.security_outlined, color: Color(0xFF757D8B),),
              trailing: Switch(
                value: is2FAEnabled,
                activeColor: Theme.of(context).primaryColor,
                // thumbColor: MaterialStateProperty.all(Colors.white),
                // inactiveThumbColor: Colors.black,
                onChanged: (bool value) {
                  //TODO set 2fa in userinfo

                  setState(() {
                    is2FAEnabled = value;
                  });
                },
              ),
              title: const Text(
                'Enable 2FA',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              textColor: Colors.grey[800],
            ),
            // ListTile(
            //   leading: const Icon(Icons.manage_accounts),
            //   iconColor: Colors.grey,
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   title: const Text('Change Username'),
            //   textColor: Colors.grey[800],
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: const Icon(Icons.manage_accounts),
            //   iconColor: Colors.grey,
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   title: const Text('Change Password'),
            //   textColor: Colors.grey[800],
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: const Icon(Icons.manage_accounts),
            //   iconColor: Colors.grey,
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   title: const Text('Change Email'),
            //   textColor: Colors.grey[800],
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: const Icon(Icons.manage_accounts),
            //   iconColor: Colors.grey,
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   title: const Text('Change Phone Number'),
            //   textColor: Colors.grey[800],
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: const Icon(Icons.manage_accounts),
            //   iconColor: Colors.grey,
            //   trailing: const Icon(Icons.arrow_forward_ios),
            //   title: const Text('Change Profile Picture'),
            //   textColor: Colors.grey[800],
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
