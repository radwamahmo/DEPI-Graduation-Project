//! ويدجت يعاد استخدامها-- زرار -> بسنت سعيد

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({super.key, required this.buttonText, required this.onPressed});
  String buttonText;
  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        minWidth: 0,
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(color: Color(0xffbfbfdb), fontSize: 16),
        ),
        color: Color(0xff0d1345),
      ),
    );
  }
}
