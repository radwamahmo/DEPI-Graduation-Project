import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Boarding2 extends StatelessWidget {
  const Boarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 120),
              //الصورة

              Lottie.asset('assets/images/animation1.json',
                  width: 280, height: 310),
              //العنوان

              SizedBox(height: 55),

              Text(
                "Stay Organized!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              //الوصف
              Text(
                "Effortlessly manage your events and deadlines all in one place\nset reminders and never miss a moment!",
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
