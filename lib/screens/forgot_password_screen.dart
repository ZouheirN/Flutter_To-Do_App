import 'package:flutter/material.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'package:todo_app/widgets/textfields.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String status = '';

  _submit() {
    setState(() {
      status = 'Sending email...';
    });

    // todo send email to user

    setState(() {
      status = 'Email sent!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, bottom: 20, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    PrimaryTextField(
                      textController: _emailController,
                      hintText: 'Enter your email',
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(text: 'Submit', onPressed: _submit),
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
                )
        ),
      ),
    );
  }
}
