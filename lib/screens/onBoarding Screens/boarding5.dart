import 'package:flutter/material.dart';

class Boarding5 extends StatelessWidget {
  const Boarding5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(          
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              //الصورة

              Image.asset('assets/images/woohoo.gif', width: 280, height: 280),
              SizedBox(height: 50),

              // العنوان
              Text(
                "Let's Dive in!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              //الوصف
              Text(
                "Get started and enjoy all the features waiting for you!",
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
