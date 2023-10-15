import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/forgot_password_screen.dart';
import 'package:todo_app/screens/otp_screen.dart';
import 'package:todo_app/services/user_info_crud.dart';
import 'package:todo_app/widgets/buttons.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      if (_isLoading) return;

      setState(() {
        _isLoading = true;
      });

      final usernameOrEmail = _usernameOrEmailController.text.trim();
      final password = _passwordController.text;

      // Hash the password
      final String hashedPassword = BCrypt.hashpw(
          password, BCrypt.gensalt(secureRandom: Random(password.length)));
      print('Password: $password');
      print('Hashed Password: $hashedPassword');

      //TODO check if credentials are correct

      final bool isEmail = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(usernameOrEmail);

      if (isEmail) {
        //TODO get username from DB
      } else {
        //TODO get email from DB
      }

      //TODO Check if user enabled 2FA
      bool? is2FAEnabled = false;

      setState(() {
        _isLoading = false;
      });

      // if user enabled 2fa, then move to otp. If not, then save userInfo and move to home
      if (is2FAEnabled) {
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                username: usernameOrEmail,
                // TODO get email from DB
                email: '',
              ),
            ),
          );
        }
      } else {
        //Save data to userInfo
        UserInfoCRUD().setUserInfo(usernameOrEmail, '');
        if (context.mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    }
  }

  void _forgetPassword() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
  }

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                      'Welcome Back!',
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
                              'Username or Email',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _usernameOrEmailController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                filled: true,
                                fillColor: Color(0xFFF4F5F7),
                                hintText: 'Enter your username or email',
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
                              'Password',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                          () => _obscureText = !_obscureText);
                                    },
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                    )),
                                filled: true,
                                fillColor: const Color(0xFFF4F5F7),
                                hintText: 'Enter your password',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                enabledBorder: const OutlineInputBorder(
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
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _forgetPassword,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              text: 'Login',
                              onPressed: _login,
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
