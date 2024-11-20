//! صفحة السبلاش تظهر مع فتح التطبيق -> بسنت سعيد

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:event_countdown/screens/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        "assets/images/splash.gif",
        fit: BoxFit.cover,
      ),
      splashIconSize: 400,
      duration: 2400,
      nextScreen: HomeScreen(),
      backgroundColor: const Color(0xffF5F3F5),
    );
  }
}
