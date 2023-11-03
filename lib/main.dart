import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/onboarding_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.white,
  //   systemNavigationBarDividerColor: Colors.white,
  // ));

  // open boxes
  var userInfoBox = await Hive.openBox('userInfo');
  var onboard = await Hive.openBox('onboard');
  await Hive.openBox('individualTasks');

  // print(userInfoBox.containsKey('username'));
  // print(userInfoBox.get('username'));

  runApp(
    MyApp(
      isOnboardFinished: onboard.containsKey('finished'),
      isLoggedIn: userInfoBox.containsKey('username'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isOnboardFinished;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isOnboardFinished,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF24A09B),
          // secondary: Color(0xFF24A09B),
          // background: Color(0xF4F5F7FF),
          // surface: Color(0xFF1E1E1E),
          // outline: Color(0xFF323333),
        ),
        useMaterial3: true,
      ),
      home: isOnboardFinished
          ? isLoggedIn
              ? const HomeScreen()
              : const WelcomeScreen()
          : const OnboardingScreen(),
    );
  }
}
