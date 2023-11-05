import 'package:flutter/material.dart';
import 'package:todo_app/screens/register_screen.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
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
                      text: 'ToDo Buddy',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 90),
            Image.asset('assets/images/logo.png',
                height: 200, width: 200, fit: BoxFit.contain),
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
            Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 5, right: 15),
                  child: const Divider(
                    color: Color(0xFFDEE3EB),
                    height: 10,
                  ),
                ),
              ),
              const Text('or', style: TextStyle(color: Color(0xFF757D8B))),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 15, right: 5),
                  child: const Divider(
                    color: Color(0xFFDEE3EB),
                    height: 10,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            PrimaryButton(
                text: 'Register',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
