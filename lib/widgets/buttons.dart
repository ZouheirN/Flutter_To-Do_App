import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF24A09B),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 20, color: Colors.white)),
    );
  }
}
