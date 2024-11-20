import 'package:event_countdown/generated/l10n.dart';
import 'package:event_countdown/data/event_provider.dart';
import 'package:event_countdown/screens/notifications/local_notification_service.dart';
import 'package:event_countdown/screens/onBoarding%20Screens/onBoarding.dart';
import 'package:event_countdown/data/provider_drawer.dart';
import 'package:event_countdown/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //! نتحقق اذا كان المستخدم فتح التطبيق قبل كده ولا لا --  بسنت سعيد
  Locale _locale = Locale('en'); // اللغة الافتراضية
  bool _seenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language') ?? 'en';  // اللغة الافتراضية هي الإنجليزية إذا لم يكن هناك لغة محفوظة
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  void changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  Future<void> _checkOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? seen = prefs.getBool('seenOnboarding') ?? false;

    setState(() {
      _seenOnboarding = seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    //!  زودت جزء ال ( mode theme)
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          locale: _locale,
          //!    تحديد لغة التطبيق
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,

          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            // fontFamily: "SF",
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.purple,
              surface: const Color(0xffBFBFDB),
              primary: Color(0xff1A1A4B),
            ),

            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),


            useMaterial3: true,
          ),
          highContrastTheme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: _seenOnboarding ? SplashScreen() : OnBoarding1(),
        );
      },
    );
  }
}
