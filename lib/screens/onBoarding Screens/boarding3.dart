import 'package:flutter/material.dart';

class Boarding3 extends StatelessWidget {
  const Boarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              // الصورة

              Image.asset('assets/images/bell.gif', width: 280, height: 280),
              // العنوان

              SizedBox(height: 50),

              Text(
                "Get Notified!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // الوصف

              Text(
                "Stay on top of your schedule with instant notifications for all your upcoming events!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
