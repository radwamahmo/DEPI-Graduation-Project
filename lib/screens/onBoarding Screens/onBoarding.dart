//! صفحات التعريف بالتطبيق تظهر مرة واحدة عند فتح التطبيق لاول مرة -> بسنت سعيد
import 'package:event_countdown/screens/onBoarding%20Screens/boarding1.dart';
import 'package:event_countdown/screens/onBoarding%20Screens/boarding2.dart';
import 'package:event_countdown/screens/onBoarding%20Screens/boarding3.dart';
import 'package:event_countdown/screens/onBoarding%20Screens/boarding5.dart';
import 'package:event_countdown/screens/splash.dart';
import 'package:event_countdown/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding1 extends StatefulWidget {
  OnBoarding1({super.key});

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  PageController _controller = PageController();

  bool onLastPage = false;

  Future<void> _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(children: [
        //! الصفحات
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 3);
            });
          },
          children: [
            Boarding1(),
            Boarding2(),
            Boarding3(),
            // Boarding4(),
            Boarding5(),
          ],
        ),

        //! تخطي المقدمة
        onLastPage
            ? Container()
            : GestureDetector(
                onTap: () => _controller.jumpToPage(4),
                child: Container(
                  alignment: Alignment(0.75, -0.82),
                  child: Text(
                    "Skip >",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),

        //! التنقل بين الصفحات
        Container(
          alignment: Alignment(0, 0.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: WormEffect(
                  dotColor: Color.fromARGB(255, 119, 119, 213),
                  activeDotColor: Color(0xff0d1345),
                ),
              ),
              onLastPage
                  ? Button(
                      buttonText: "Let's Go!",
                      onPressed: () => _completeOnboarding(context),
                    )
                  : Button(
                      buttonText: "Next",
                      onPressed: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.bounceInOut);
                      }),
            ],
          ),
        ),
      ]),
    );
  }
}
