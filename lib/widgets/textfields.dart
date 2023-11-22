import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

class PrimaryTextField extends StatefulWidget {
  final TextEditingController? textController;
  final String hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final bool? obscureText;

  const PrimaryTextField({
    super.key,
    this.textController,
    required this.hintText,
    this.enabled = true,
    this.validator,
    this.obscureText,
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
      obscureText: widget.obscureText ?? false,
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
      validator: widget.validator,
    );
  }
}

class DialogTextField extends StatefulWidget {
  final TextEditingController? textController;
  final String hintText;
  final String? Function(String?)? validator;

  const DialogTextField({
    super.key,
    this.textController,
    required this.hintText,
    required this.validator,
  });

  @override
  State<DialogTextField> createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<DialogTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      validator: widget.validator,
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
    );
  }
}

class DateTextField extends StatefulWidget {
  final TextEditingController? textController;

  const DateTextField({super.key, required this.textController});

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      validator: (value) {
        value = widget.textController?.text;
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        filled: true,
        fillColor: const Color(0xFFF4F5F7),
        hintText: widget.textController?.text == ''
            ? 'Estimated Date'
            : widget.textController?.text,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFFDEE3EB), width: 2),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today_outlined),
          onPressed: () {
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              minTime: DateTime.now(),
              onConfirm: (date) {
                setState(() {
                  DateTime dateTime = DateTime.parse(date.toString());
                  String formattedString =
                      DateFormat('E MMM d, y - HH:mm').format(dateTime);
                  widget.textController?.text = formattedString;
                });
              },
              currentTime: DateTime.now(),
              locale: LocaleType.en,
            );
          },
        ),
      ),
    );
  }
}
