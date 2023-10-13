import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('One-Time Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Enter the OTP sent to your email',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'You email starts with: ',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 100),
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
              onCompleted: (pin) {
                setState(() {
                  _status = 'Checking OTP...';
                });

                //TODO logic for checking OTP

                //Delay for 2 sec
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    _status = 'Wrong OTP. Try again';
                  });
                });
              },
            ),
            const SizedBox(height: 50),
            Text(
              _status,
              style: TextStyle(
                color: _status == 'Wrong OTP. Try again'
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
