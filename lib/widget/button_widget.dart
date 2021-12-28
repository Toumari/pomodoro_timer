import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;
  final Color backgroundColor;

  ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      this.color = Colors.white,
      this.backgroundColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
          onPressed: () {
            onClicked();
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 15.0, color: color),
          )),
    );
  }
}
