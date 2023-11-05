import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<String> _list = [
  'Low',
  'Medium',
  'High',
];

class PriorityDropdown extends StatelessWidget {
  final TextEditingController priorityController;
  final bool validateOnChange;
  final String? Function(String?)? validator;

  const PriorityDropdown({
    super.key,
    required this.priorityController,
    required this.validateOnChange,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Priority',
      items: _list,
      // initialItem: _list[0],
      onChanged: (value) {
        priorityController.text = value;
      },
      closedBorder: Border.all(
        color: const Color(0xFFDEE3EB),
        width: 2,
      ),
      closedBorderRadius: const BorderRadius.all(Radius.circular(10)),
      closedFillColor: const Color(0xFFF4F5F7),
      expandedFillColor: const Color(0xFFF4F5F7),
      expandedBorder: Border.all(
        color: const Color(0xFFDEE3EB),
        width: 2,
      ),
      expandedBorderRadius: const BorderRadius.all(Radius.circular(10)),
      errorStyle: const TextStyle(
        height: 1,
        fontSize: 0,
      ),
      closedErrorBorder: Border.all(
        color: const Color(0xFFB61834),
        width: 1,
      ),
      closedErrorBorderRadius: const BorderRadius.all(Radius.circular(10)),
      validateOnChange: validateOnChange,
      validator: validator,
    );
  }
}
