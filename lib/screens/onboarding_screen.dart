import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';
import 'package:todo_app/services/onboard_crud.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        next: const Icon(Icons.arrow_forward_ios),
        done: const Text('Done'),
        skip: const Text('Skip'),
        showSkipButton: true,
        onDone: () {
          OnboardCRUD().setOnboardFinished();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            ),
          );
        },
        pages: [
          PageViewModel(
            title: 'Welcome to ToDo Buddy',
            body: 'Are you ready to manage your tasks? Let\'s get started!',
            image: Image.network(
                'https://img.freepik.com/free-vector/personal-goals-checklist-concept-illustration_114360-13205.jpg?w=740&t=st=1699182839~exp=1699183439~hmac=2a5aebba537b4078d0a93efe2916dc5b9fad61ec1b2775e063c1d948d08d25c5'),
            decoration: const PageDecoration(
              imagePadding: EdgeInsets.only(top: 80),
              bodyTextStyle: TextStyle(
                fontSize: 20,
              ),
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PageViewModel(
            title: 'Get Those Tasks Done!',
            body: 'Your tasks are synced across all your devices!',
            image: Image.network(
                'https://img.freepik.com/free-vector/task-management-abstract-concept-illustration_335657-2127.jpg?w=740&t=st=1697353835~exp=1697354435~hmac=fc8dd658c95463a95ac1ef0f4c8122dde0a673e814b9e1a20649a5d70a9e0b20'),
            decoration: const PageDecoration(
              imagePadding: EdgeInsets.only(top: 80),
              bodyTextStyle: TextStyle(
                fontSize: 20,
              ),
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PageViewModel(
            title: 'Security Is Our Number One Priority',
            body: 'We use the latest security technologies to keep your data safe!',
            image: Image.network(
                'https://img.freepik.com/free-vector/cloud-computing-security-abstract-concept-illustration_335657-2105.jpg?w=740&t=st=1697555708~exp=1697556308~hmac=e90e87e2949c50294d78dadf76111205b599410b0fd9a9763da434a0f403ac09'),
            decoration: const PageDecoration(
              imagePadding: EdgeInsets.only(top: 80),
              bodyTextStyle: TextStyle(
                fontSize: 20,
              ),
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
