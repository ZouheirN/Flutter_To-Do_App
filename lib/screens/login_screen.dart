import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:todo_app/screens/otp_screen.dart';
import 'package:todo_app/services/user_info_crud.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'package:todo_app/widgets/dialogs.dart';

import '../services/http_requests.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isLoading = false;
  String _status = '';
  final _formKey = GlobalKey<FormState>();
  final _usernameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_formKey.currentState!.validate()) {
      if (_isLoading) return;

      setState(() {
        _isLoading = true;
        _status = '';
      });

      final usernameOrEmail = _usernameOrEmailController.text.trim();
      final password = _passwordController.text;

      // Hash the password
      final String hashedPassword = BCrypt.hashpw(
          password, BCrypt.gensalt(secureRandom: Random(password.length)));

      // check if credentials are correct and get token and user info
      final response =
          await checkCredentialsAndGetToken(usernameOrEmail, hashedPassword);

      if (response == ReturnTypes.fail) {
        setState(() {
          _isLoading = false;
          _status = 'Invalid Credentials';
        });
        return;
      } else if (response == ReturnTypes.error) {
        setState(() {
          _isLoading = false;
          _status = 'An Error Occurred, Please Try Again';
        });
        return;
      }

      debugPrint(response.toString());
      final token = response['token'];
      final username = response['username'];
      final email = response['email'];
      final is2FAEnabled = response['is2FAEnabled'];
      final isBiometricAuthEnabled = response['isBiometricAuthEnabled'];
      final isVerified = response['isVerified'];

      setState(() {
        _isLoading = false;
        _status = '';
      });

      if (!isVerified) {
        // check if user is verified, if not then move to otp screen
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                token: token,
                isNotVerifiedFromLogin: true,
              ),
            ),
          );
        }
      } else if (is2FAEnabled) {
        // if user enabled 2fa, then move to otp. If not, then save userInfo and move to home
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                token: token,
                isNotVerifiedFromLogin: false,
              ),
            ),
          );
        }
      } else {
        //Save data to userInfo
        UserInfoCRUD().setUserInfo(
          username: username,
          email: email,
          is2FAEnabled: is2FAEnabled,
          isBiometricAuthEnabled: isBiometricAuthEnabled,
          token: token,
        );

        if (context.mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(
                isFirstTimeLoggingIn: true,
              ),
            ),
          );
        }
      }
    }
  }

  void _forgetPassword() {
    showForgotPasswordDialog(context);
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
                        child: AutofillGroup(
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
                                autofillHints: const [
                                  AutofillHints.username,
                                  AutofillHints.email
                                ],
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
                                    return 'Please enter your username or email';
                                  }

                                  value = trim(value);
                                  value = escape(value);

                                  bool usernameValid = false;

                                  if (isAscii(value) || isEmail(value)) {
                                    usernameValid = true;
                                  }

                                  if (!usernameValid) {
                                    return 'Please enter a valid username or email';
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
                                autofillHints: const [AutofillHints.password],
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
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  _status,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
