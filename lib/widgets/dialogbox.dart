import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:todo_app/widgets/buttons.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController colorController;
  final VoidCallback onAdd;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.nameController,
    required this.onAdd,
    required this.onCancel,
    required this.descriptionController,
    required this.colorController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Task Name',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Task Description',
              ),
            ),
            PrimaryButton(
                text: 'Choose Color',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(18.0),
                        title: const Text("Color picker"),
                        content: MaterialColorPicker(
                          onColorChange: (Color color) {
                            String colorString = color.toString();
                            String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
                            colorController.text = valueString;
                          },
                          selectedColor: Colors.red,
                          colors: const [
                            Colors.red,
                            Colors.deepOrange,
                            Colors.yellow,
                            Colors.lightGreen
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('SUBMIT'),
                          ),
                        ],
                      );
                    },
                  );
                }),
            // MaterialColorPicker(
            //   onColorChange: (Color color) {
            //     var hex = '#${color.value.toRadixString(16)}';
            //     colorController.text = hex;
            //   },
            //   selectedColor: Colors.red,
            //   colors: const [
            //     Colors.red,
            //     Colors.deepOrange,
            //     Colors.yellow,
            //     Colors.lightGreen
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DialogButton(text: 'Add', onPressed: onAdd),
                DialogButton(text: 'Cancel', onPressed: onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
