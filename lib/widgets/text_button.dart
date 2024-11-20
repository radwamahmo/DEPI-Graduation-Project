import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TButton extends StatelessWidget {
  TButton({super.key, required this.buttonText, required this.onPressed});

  String buttonText;
  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(color: Color(0xff0d1345), fontSize: 16),
      ),
    );
  }
}
