import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<String> _list = [
  'Low',
  'Medium',
  'High',
];

class PriorityDropdown extends StatelessWidget {
  final TextEditingController priorityController;

  const PriorityDropdown({Key? key, required this.priorityController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Priority',
      items: _list,
      initialItem: _list[0],
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
    );
  }
}
