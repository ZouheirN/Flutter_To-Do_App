import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/services/http_requests.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'package:todo_app/widgets/global_snackbar.dart';
import 'package:todo_app/widgets/textfields.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FancyPasswordController _passwordValidatorController =
      FancyPasswordController();
  String status = '';
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isLoading) return;

      setState(() {
        _isLoading = true;
      });

      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;

      // Hash the password
      final String hashedOldPassword = BCrypt.hashpw(oldPassword,
          BCrypt.gensalt(secureRandom: Random(oldPassword.length)));

      final String hashedNewPassword = BCrypt.hashpw(newPassword,
          BCrypt.gensalt(secureRandom: Random(newPassword.length)));

      // todo change password
      final dynamic result = 0;

      if (result == ReturnTypes.fail) {
        setState(() {
          status = 'Failed to change password';
          _isLoading = false;
        });
      } else if (result == ReturnTypes.error) {
        setState(() {
          status = 'An error occurred';
          _isLoading = false;
        });
      } else if (result == ReturnTypes.invalidToken) {
        invalidTokenResponse(context);
        return;
      }

      showGlobalSnackBar('Password changed successfully, please login again');
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _passwordValidatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, bottom: 20, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Old Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                PrimaryTextField(
                  textController: _oldPasswordController,
                  hintText: 'Enter your old password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your old password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'New Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FancyPasswordField(
                  controller: _newPasswordController,
                  passwordController: _passwordValidatorController,
                  validationRules: {
                    DigitValidationRule(),
                    UppercaseValidationRule(),
                    LowercaseValidationRule(),
                    // SpecialCharacterValidationRule(),
                    MinCharactersValidationRule(8),
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }

                    return _passwordValidatorController.areAllRulesValidated
                        ? null
                        : 'Please validate all rules';
                  },
                  validationRuleBuilder: (rules, value) {
                    return SizedBox(
                      height: 120,
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: rules.map(
                          (rule) {
                            final ruleValidated = rule.validate(value);
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  ruleValidated ? Icons.check : Icons.close,
                                  color:
                                      ruleValidated ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  rule.name,
                                  style: TextStyle(
                                    color: ruleValidated
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    );
                  },
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    filled: true,
                    fillColor: Color(0xFFF4F5F7),
                    hintText: 'Enter your new password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide:
                          BorderSide(color: Color(0xFFDEE3EB), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Confirm Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                PrimaryTextField(
                  textController: _confirmPasswordController,
                  hintText: 'Confirm your new password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Change',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
