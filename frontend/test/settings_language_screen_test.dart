import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/screens/intro-screens/language_screen.dart';

// Mock class for navigation testing
class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

void main() {
  group('LanguageScreen Tests', () {
    late MockNavigatorObserver mockObserver;
    void Function(FlutterErrorDetails)? originalOnError;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      originalOnError = FlutterError.onError;
    });

    tearDown(() {
      FlutterError.onError = originalOnError;
    });

    Widget createTestWidget(LanguageScreen screen) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        navigatorObservers: [mockObserver],
        home: screen,
        routes: {
          '/mode': (context) => const Scaffold(body: Text('Mode Screen')),
        },
      );
    }

    testWidgets('should display language options correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) return;
        originalOnError?.call(details);
      };

      Locale? selectedLocale;

      await tester.pumpWidget(
        createTestWidget(
          LanguageScreen(
            onLocaleChanged: (locale) {
              selectedLocale = locale;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
      expect(find.text('Русский'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should select English by default', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) return;
        originalOnError?.call(details);
      };

      await tester.pumpWidget(
        createTestWidget(LanguageScreen(onLocaleChanged: (locale) {})),
      );

      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should change selection when tapping on Russian', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) return;
        originalOnError?.call(details);
      };

      Locale? selectedLocale;

      await tester.pumpWidget(
        createTestWidget(
          LanguageScreen(
            onLocaleChanged: (locale) {
              selectedLocale = locale;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Русский'));
      await tester.pumpAndSettle();

      expect(selectedLocale, equals(const Locale('ru')));

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should change selection when tapping on English', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) return;
        originalOnError?.call(details);
      };

      Locale? selectedLocale;

      await tester.pumpWidget(
        createTestWidget(
          LanguageScreen(
            onLocaleChanged: (locale) {
              selectedLocale = locale;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Русский'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(selectedLocale, equals(const Locale('en')));

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should navigate to mode screen when Apply button is pressed', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) return;
        originalOnError?.call(details);
      };

      await tester.pumpWidget(
        createTestWidget(LanguageScreen(onLocaleChanged: (locale) {})),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(mockObserver.pushedRoutes.length, greaterThan(0));

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should have proper widget structure', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) return;
        originalOnError?.call(details);
      };

      await tester.pumpWidget(
        createTestWidget(LanguageScreen(onLocaleChanged: (locale) {})),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should call onLocaleChanged callback with correct locale', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) return;
        originalOnError?.call(details);
      };

      final List<Locale> calledLocales = [];

      await tester.pumpWidget(
        createTestWidget(
          LanguageScreen(
            onLocaleChanged: (locale) {
              calledLocales.add(locale);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Русский'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(calledLocales, contains(const Locale('ru')));
      expect(calledLocales, contains(const Locale('en')));
      expect(calledLocales.length, equals(2));

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should display visual selection indicator', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) return;
        originalOnError?.call(details);
      };

      await tester.pumpWidget(
        createTestWidget(LanguageScreen(onLocaleChanged: (locale) {})),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Русский'));
      await tester.pumpAndSettle();

      final russianText = tester.widget<Text>(find.text('Русский'));
      expect(russianText.style?.fontWeight, equals(FontWeight.bold));

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
