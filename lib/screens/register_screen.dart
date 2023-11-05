import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/otp_screen.dart';
import 'package:todo_app/widgets/buttons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final FancyPasswordController _passwordValidatorController = FancyPasswordController();
  final _confirmPassController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_isLoading) return;

      setState(() {
        _isLoading = true;
      });

      //TODO check if username and email are unique

      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 50),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Create Account',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Username',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                filled: true,
                                fillColor: Color(0xFFF4F5F7),
                                hintText: 'Enter your username',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFDEE3EB), width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }

                                final bool usernameValid = RegExp(
                                        r"^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$")
                                    .hasMatch(value);

                                if (!usernameValid) {
                                  return 'Please enter a valid username';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                filled: true,
                                fillColor: Color(0xFFF4F5F7),
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFDEE3EB), width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }

                                final bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);

                                if (!emailValid) {
                                  return 'Please enter a valid email';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            FancyPasswordField(
                              controller: _passController,
                              passwordController: _passwordValidatorController,
                              validationRules: {
                                DigitValidationRule(),
                                UppercaseValidationRule(),
                                LowercaseValidationRule(),
                                SpecialCharacterValidationRule(),
                                MinCharactersValidationRule(8),
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }

                                return _passwordValidatorController.areAllRulesValidated
                                    ? null
                                    : 'Please validate all rules';
                              },
                              validationRuleBuilder: (rules, value) {
                                return SizedBox(
                                  height: 120,
                                  child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: rules.map(
                                      (rule) {
                                        final ruleValidated =
                                            rule.validate(value);
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              ruleValidated
                                                  ? Icons.check
                                                  : Icons.close,
                                              color: ruleValidated
                                                  ? Colors.green
                                                  : Colors.red,
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                filled: true,
                                fillColor: Color(0xFFF4F5F7),
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFDEE3EB), width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _confirmPassController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                filled: true,
                                fillColor: Color(0xFFF4F5F7),
                                hintText: 'Enter your password again',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Color(0xFFDEE3EB), width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }

                                if (value != _passController.text) {
                                  return 'Password does not match';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Spacer(),
                            const SizedBox(
                              height: 20,
                            ),
                            PrimaryButton(
                              text: 'Register',
                              onPressed: _register,
                              isLoading: _isLoading,
                            ),
                          ],
                        ),
                      ),
                    ),
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
