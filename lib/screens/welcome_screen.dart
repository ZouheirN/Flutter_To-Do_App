import 'package:flutter/material.dart';
import 'package:todo_app/screens/register_screen.dart';
import 'package:todo_app/widgets/buttons.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold),
                children: [
                  const TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Todo List App',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          PrimaryButton(
              text: 'Login',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                );
              }),
          const SizedBox(height: 20),
          PrimaryButton(text: 'Register', onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const RegisterScreen()),
            );
          }),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
