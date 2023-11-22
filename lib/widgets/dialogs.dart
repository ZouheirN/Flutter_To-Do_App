import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:string_validator/string_validator.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'package:todo_app/widgets/textfields.dart';

import '../screens/otp_screen.dart';

void showLoadingDialog(String text, BuildContext context) => showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(text, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );

void showTextDialog(String title, String text, BuildContext context) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogButton(
                text: text,
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );

void showForgotPasswordDialog(BuildContext context) {
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Forgot Password?", textAlign: TextAlign.center),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter your email to reset it"),
            const SizedBox(height: 10),
            PrimaryTextField(
              hintText: 'Enter your email',
              textController: textController,
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Please enter your email';
                }

                if (!isEmail(p0)) {
                  return 'Please enter a valid email';
                }

                return null;
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DialogButton(
                  text: 'Cancel',
                  color: 0xFFFF0000,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                DialogButton(
                  text: 'Submit',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return OTPScreen(
                              isResettingPassword: true,
                              email: textController.text.trim(),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
