import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:todo_app/services/user_info_crud.dart';
import 'package:todo_app/widgets/global_snackbar.dart';

import '../services/http_requests.dart';
import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final String token;
  final bool isNotVerifiedFromLogin;

  const OTPScreen(
      {super.key,
      required this.email,
      required this.isNotVerifiedFromLogin,
      required this.token});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _status = '';
  bool _isCountDownFinished = false;
  bool _isFieldDisabled = false;

  // Future<void> _requestOTP() async {
  //   // TODO logic for requesting OTP
  //   await requestOTP(email);
  //
  //   setState(() {
  //     _isCountDownFinished = false;
  //   });
  // }

  Future<void> _checkOTP(pin) async {
    setState(() {
      _status = 'Checking OTP...';
      _isFieldDisabled = true;
    });

    // logic for checking OTP
    final otpStatus = await checkOTP(pin, widget.email, widget.token);

    // if OTP is correct, get all the other user info from DB
    if (otpStatus == ReturnTypes.error) {
      setState(() {
        _status = '';
        _isFieldDisabled = false;
      });
      showGlobalSnackBar('Something went wrong. Please try again later.');
      return;
    } else if (otpStatus == ReturnTypes.fail) {
      setState(() {
        _status = 'Wrong OTP. Try again';
        _isFieldDisabled = false;
      });
      return;
    } else if (otpStatus == ReturnTypes.invalidToken) {
      if (!mounted) return;
      invalidTokenResponse(context);
      return;
    }

    UserInfoCRUD().setUserInfo(
      username: otpStatus['username'],
      email: otpStatus['email'],
      is2FAEnabled: otpStatus['is2FAEnabled'],
      isBiometricAuthEnabled: otpStatus['isBiometricAuthEnabled'],
      token: otpStatus['token'],
    );

    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(
          isFirstTimeLoggingIn: true,
        ),
      ),
    );
  }

  // @override
  // void initState() {
  //   _requestOTP();
  //   super.initState();
  // }

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
              if (widget.isNotVerifiedFromLogin)
                const Text(
                  'Your account is not verified yet. Please enter the OTP sent to your email to verify your account',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              else
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
              Pinput(
                enabled: !_isFieldDisabled,
                length: 6,
                onCompleted: _checkOTP,
                onChanged: (value) {
                  if (value.length < 6) {
                    setState(() {
                      _status = '';
                    });
                  }
                },
                focusedPinTheme: PinTheme(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF4F5F7),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    )),
                defaultPinTheme: PinTheme(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF4F5F7),
                      border: Border.all(
                        color: const Color(0xFFDEE3EB),
                      ),
                    )),
              ),
              // OTPTextField(
              //   length: 5,
              //   otpFieldStyle: OtpFieldStyle(
              //     backgroundColor: const Color(0xFFF4F5F7),
              //     borderColor: const Color(0xFFDEE3EB),
              //     focusBorderColor: const Color(0xFF24A09B),
              //   ),
              //   width: MediaQuery.of(context).size.width,
              //   fieldWidth: 40,
              //   style: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w700,
              //   ),
              //   textFieldAlignment: MainAxisAlignment.spaceAround,
              //   fieldStyle: FieldStyle.box,
              //   onChanged: (s) {
              //     if (s.length < 5) {
              //       setState(() {
              //         _status = '';
              //       });
              //     }
              //   },
              //   onCompleted: _checkOTP,
              // ),
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
              // const SizedBox(height: 100),
              // if (_isCountDownFinished == false)
              //   const Text(
              //     'Didn\'t receive the OTP? You can request another one in',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 18,
              //       // fontWeight: FontWeight.bold,
              //     ),
              //   )
              // else
              //   TextButton(
              //     onPressed: _requestOTP,
              //     child: Text(
              //       'Request a new OTP',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //           color: Theme.of(context).primaryColor),
              //     ),
              //   ),
              // if (_isCountDownFinished == false)
              //   CountDownTime.minutes(
              //     onTimeOut: () {
              //       setState(() {
              //         _isCountDownFinished = true;
              //       });
              //     },
              //     timeStartInMinutes: 1,
              //     textStyle: const TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
