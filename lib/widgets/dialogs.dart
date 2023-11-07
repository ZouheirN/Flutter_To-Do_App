import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo_app/widgets/buttons.dart';

void showLoadingDialog(String text, BuildContext context) => showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(text, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );

void showTextDialog(String title, String text, BuildContext context) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(title, textAlign: TextAlign.center),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DialogButton(text: text, onPressed: () {
          Navigator.pop(context);
        })
      ],
    ),
  ),
);