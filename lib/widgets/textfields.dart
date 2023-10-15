import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final TextEditingController? textController;
  final String hintText;
  final bool enabled;

  const PrimaryTextField({
    super.key,
    this.textController,
    required this.hintText,
    this.enabled = true,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {

  @override
  void dispose() {
    widget.textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        filled: true,
        fillColor: const Color(0xFFF4F5F7),
        hintText: widget.hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFFDEE3EB), width: 2),
        ),
      ),
      enabled: widget.enabled,
    );
  }
}
