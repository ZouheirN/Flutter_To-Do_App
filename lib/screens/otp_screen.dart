import 'package:count_down_time/count_down_time.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:todo_app/services/user_info_crud.dart';

import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String username;
  final String email;

  const OTPScreen({super.key, required this.username, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _status = '';
  bool _isCountDownFinished = false;

  void _requestOTP() {
    // TODO logic for requesting OTP

    print('OTP Sent for ${widget.email}');

    setState(() {
      _isCountDownFinished = false;
    });
  }

  void _checkOTP(pin) {
    setState(() {
      _status = 'Checking OTP...';
    });

    //TODO logic for checking OTP

    //Delay for 2 sec
    Future.delayed(const Duration(seconds: 2), () {
      //Save data to userInfo
      userInfoCRUD().writeUserInfo(widget.username, widget.email);

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      // setState(() {
      //   _status = 'Wrong OTP. Try again';
      // });
    });
  }

  @override
  void initState() {
    _requestOTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One-Time Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'Enter the OTP sent to your email',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 20),
              // const Text(
              //   'You email starts with: ',
              //   style: TextStyle(fontSize: 16),
              // ),
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
                onCompleted: _checkOTP,
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
              const SizedBox(height: 100),
              if (_isCountDownFinished == false)
                const Text(
                  'Didn\'t receive the OTP? You can request another one in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                )
              else
                TextButton(
                  onPressed: _requestOTP,
                  child: Text(
                    'Request a new OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              if (_isCountDownFinished == false)
                CountDownTime.minutes(
                  onTimeOut: () {
                    setState(() {
                      _isCountDownFinished = true;
                    });
                  },
                  timeStartInMinutes: 1,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
