import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:todo_app/widgets/buttons.dart';
import 'package:todo_app/widgets/priority_dropdown.dart';
import 'package:todo_app/widgets/textfields.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController colorController;
  final TextEditingController priorityController;
  final TextEditingController dateController;
  final VoidCallback onAdd;
  final VoidCallback onCancel;
  final GlobalKey<FormState> formKey;

  const DialogBox({
    super.key,
    required this.nameController,
    required this.onAdd,
    required this.onCancel,
    required this.descriptionController,
    required this.colorController,
    required this.priorityController,
    required this.formKey,
    required this.dateController,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  int colorInt = int.parse('ff24a09b', radix: 16);

  @override
  void initState() {
    widget.colorController.text = 'ff24a09b';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        // height: 400,
        width: 400,
        child: Form(
          key: widget.formKey,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DialogTextField(
                  textController: widget.nameController,
                  hintText: 'Task Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DialogTextField(
                  textController: widget.descriptionController,
                  hintText: 'Task Description',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task description';
                    }
                    return null;
                  },
                ),
                PriorityDropdown(
                  priorityController: widget.priorityController,
                  // Run validation on item selected
                  validateOnChange: true,
                  // Function to validate if the current selected item is valid or not
                  validator: (value) =>
                      value == null ? 'Please select a priority' : null,
                ),
                DateTextField(textController: widget.dateController),
                const SizedBox(height: 12),
                DialogButton(
                    text: 'Color',
                    color: colorInt,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(18.0),
                            title: const Text("Choose Color"),
                            content: MaterialColorPicker(
                              onColorChange: (Color color) {
                                String colorString = color.toString();
                                String valueString =
                                    colorString.split('(0x')[1].split(')')[0];
                                widget.colorController.text = valueString;
                              },
                              selectedColor: Theme.of(context).primaryColor,
                              colors: [
                                createMaterialColor(const Color(0xFF24A09B)),
                                createMaterialColor(Colors.blue),
                                createMaterialColor(Colors.red),
                                createMaterialColor(Colors.green),
                                createMaterialColor(Colors.purple),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    colorInt = int.parse(
                                        widget.colorController.text,
                                        radix: 16);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text('SUBMIT'),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DialogButton(text: 'Add', onPressed: widget.onAdd),
                    DialogButton(
                      text: 'Cancel',
                      onPressed: widget.onCancel,
                      color: 0xFFFF0000,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
