import 'package:flutter/material.dart';
import 'package:todo_app/services/http_requests.dart';
import 'package:todo_app/services/user_info_crud.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'package:todo_app/widgets/dialogs.dart';
import 'package:todo_app/widgets/textfields.dart';

import '../widgets/global_snackbar.dart';
import 'change_password_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _is2FAEnabled = false;
  bool _isAuthenticationEnabled = false;

  bool _is2FALoading = false;
  bool _isBioAuthLoading = false;

  _changePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );
  }

  _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to delete your account? Your tasks will be deleted as well.',
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
                    text: 'Delete',
                    color: 0xFFFF0000,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      showLoadingDialog('Deleting Account...', context);

                      // final response = await deleteAccount();

                      Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
    _is2FAEnabled = UserInfoCRUD().get2FAEnabled();
    _isAuthenticationEnabled = UserInfoCRUD().getAuthEnabled();
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
              'Username',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            PrimaryTextField(
                hintText: UserInfoCRUD().getUsername(), enabled: false),
            const SizedBox(height: 20),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            PrimaryTextField(
                hintText: UserInfoCRUD().getEmail(), enabled: false),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
                text: 'Change Password', onPressed: _changePassword),
            const SizedBox(height: 20),
            const Divider(
              thickness: 0.1,
              indent: 10,
              endIndent: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.security_outlined,
                color: Color(0xFF757D8B),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_is2FALoading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  SizedBox(width: _is2FALoading ? 10 : 0),
                  Switch(
                    value: _is2FAEnabled,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool value) async {
                      if (_is2FALoading) return;
                      setState(() {
                        _is2FALoading = true;
                      });
                      final newValue = await toggle2FA();

                      if (newValue == ReturnTypes.fail ||
                          newValue == ReturnTypes.error) {
                        showGlobalSnackBar('Failed to toggle 2FA.');
                        return;
                      } else if (newValue == ReturnTypes.invalidToken) {
                        if (!mounted) return;
                        invalidTokenResponse(context);
                        return;
                      }

                      UserInfoCRUD().set2FA(newValue);

                      setState(() {
                        _is2FAEnabled = newValue;
                        _is2FALoading = false;
                      });
                    },
                  ),
                ],
              ),
              title: const Text(
                'Enable 2FA',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              textColor: Colors.grey[800],
            ),
            ListTile(
              leading: const Icon(
                Icons.fingerprint,
                color: Color(0xFF757D8B),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isBioAuthLoading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  SizedBox(width: _isBioAuthLoading ? 10 : 0),
                  Switch(
                    value: _isAuthenticationEnabled,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool value) async {
                      if (_isBioAuthLoading) return;
                      setState(() {
                        _isBioAuthLoading = true;
                      });
                      final newValue = await toggleBiometricAuth();

                      if (newValue == ReturnTypes.fail ||
                          newValue == ReturnTypes.error) {
                        showGlobalSnackBar(
                            'Failed to toggle biometric authentication.');
                        return;
                      } else if (newValue == ReturnTypes.invalidToken) {
                        if (!mounted) return;
                        invalidTokenResponse(context);
                        return;
                      }

                      UserInfoCRUD().setAuth(newValue);

                      setState(() {
                        _isAuthenticationEnabled = newValue;
                        _isBioAuthLoading = false;
                      });
                    },
                  ),
                ],
              ),
              title: const Text(
                'Enable Biometric Authentication',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              textColor: Colors.grey[800],
            ),
            const Divider(
              thickness: 0.1,
              indent: 10,
              endIndent: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.no_accounts_rounded,
                color: Colors.red,
              ),
              title: const Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: _deleteAccount,
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
