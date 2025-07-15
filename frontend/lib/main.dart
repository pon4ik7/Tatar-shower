import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatar_shower/screens/main-screens/tabs.dart';
import "l10n/app_localizations.dart";
import 'package:tatar_shower/screens/intro-screens/language_screen.dart';
import 'package:tatar_shower/screens/intro-screens/mode_screen.dart';
import 'package:tatar_shower/screens/intro-screens/welcome_screen.dart';
import 'package:tatar_shower/screens/reg-auth-screens/sign_up_screen.dart';
import 'package:tatar_shower/screens/reg-auth-screens/log_in_screen.dart';
import 'package:tatar_shower/screens/pref-screens/pref_1_screen.dart';
import 'package:tatar_shower/screens/pref-screens/pref_2_screen.dart';
import 'package:tatar_shower/screens/pref-screens/pref_3_screen.dart';
import 'package:tatar_shower/screens/pref-screens/pref_4_screen.dart';
import 'package:tatar_shower/screens/pref-screens/pref_5_screen.dart';
import 'package:tatar_shower/screens/pref-screens/pref_done_screen.dart';
import 'package:tatar_shower/screens/main-screens/settings-screens/settings_language_screen.dart';
import 'package:tatar_shower/screens/main-screens/settings-screens/settings_mode_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tatar_shower/services/push_notification_service.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'onboarding/onboarding_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => OnboardingData(),
      child: const MyApp(),
    ),
  );
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
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),
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
        '/pref1': (context) => PreferencesScreen1(),
        '/pref2': (context) => PreferencesScreen2(),
        '/pref3': (context) => PreferencesScreen3(),
        '/pref4': (context) => PreferencesScreen4(),
        '/pref5': (context) => PreferencesScreen5(),
        '/prefDone': (context) => PreferencesDoneScreen(),
        '/tabs': (context) => Tabs(),
        '/settingsLanguage': (context) => SettingsLanguage(
          onLocaleChanged: _setLocale,
          currentLocale: _locale == const Locale('en') ? 'eu' : 'ru',
        ),
        '/settingsMode': (context) => SettingsMode(),
      },
    );
  }
}
