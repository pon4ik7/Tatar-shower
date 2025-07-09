import 'package:flutter/material.dart';
import 'package:tatar_shower/screens/intro-screens/language_screen.dart';
import 'package:tatar_shower/screens/intro-screens/mode_screen.dart';
import 'package:tatar_shower/screens/intro-screens/welcome_screen.dart';
import 'package:tatar_shower/screens/reg-auth-screens/sign_up_screen.dart';
import 'package:tatar_shower/screens/reg-auth-screens/log_in_screen.dart';
import "l10n/app_localizations.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _setLocale(Locale newLocale) {
    setState(() => _locale = newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback:
          (Locale? deviceLocale, Iterable<Locale> supported) {
            if (deviceLocale != null) {
              switch (deviceLocale.languageCode) {
                case 'en':
                  return const Locale('en');
                case 'ru':
                  return const Locale('ru');
              }
            }
            return const Locale('en');
          },
      debugShowCheckedModeBanner: false,
      initialRoute: '/language',
      routes: {
        '/language': (context) => LanguageScreen(onLocaleChanged: _setLocale),
        '/mode': (context) => ModeScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LogInScreen(),
      },
    );
  }
}
