import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;

  const PrimaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isLoading = false});

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
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(text,
              style: const TextStyle(fontSize: 20, color: Colors.white)),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final bool isLoading;

  const SecondaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed == null ? null : () => onPressed!(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFDFDFD),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFDEE3EB), width: 2),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(text,
              style: const TextStyle(fontSize: 20, color: Color(0xFF757D8B))),
    );
  }
}

class DialogButton extends StatelessWidget {
  final String text;
  final int? color;
  VoidCallback onPressed;

  DialogButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color == null ? Theme.of(context).primaryColor : Color(color!),
      child: Text(text),
    );
  }
}
