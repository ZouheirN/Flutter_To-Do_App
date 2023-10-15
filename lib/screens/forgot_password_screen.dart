import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'package:todo_app/widgets/textfields.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _OTPSent = false;
  String _status = '';

  Future<void> _sendOTP() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    //TODO send OTP to email

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _OTPSent = true;
    });
  }

  Future<void> _checkOTP(pin) async {
    setState(() {
      _status = 'Checking OTP...';
    });

    //TODO logic for checking OTP

    //Delay for 2 sec
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _status = 'Wrong OTP. Try again';
    });

    setState(() {
      _status = 'Password has been successfully reset! Please login again';
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              PrimaryTextField(
                textController: _emailController,
                hintText: 'Enter your email',
              ),
              const SizedBox(height: 20),
              if (!_OTPSent)
                PrimaryButton(
                  text: 'Send OTP',
                  onPressed: _sendOTP,
                  isLoading: _isLoading,
                )
              else
                const SecondaryButton(text: 'OTP SENT', onPressed: null),
              const SizedBox(height: 20),
              if (_OTPSent)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'If an account matches the email address, an email will be sent with the OTP.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OTPTextField(
                      length: 5,
                      otpFieldStyle: OtpFieldStyle(
                        backgroundColor: const Color(0xFFF4F5F7),
                        borderColor: const Color(0xFFDEE3EB),
                        focusBorderColor: const Color(0xFF24A09B),
                      ),
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 40,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      onChanged: (s) {
                        if (s.length < 5) {
                          setState(() {
                            _status = '';
                          });
                        }
                      },
                      onCompleted: _checkOTP,
                    ),
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        _status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _status == 'Wrong OTP. Try again'
                              ? Colors.red
                              : Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
