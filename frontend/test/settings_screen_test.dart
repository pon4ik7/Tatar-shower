import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/fonts.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/main-screens/settings-screens/settings_screen.dart';

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

void main() {
  Widget createTestWidget(Widget child, {NavigatorObserver? observer}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ru')],
      home: child,
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        '/settingsLanguage': (context) =>
            const Scaffold(body: Text('Language Screen')),
        '/settingsMode': (context) => const Scaffold(body: Text('Mode Screen')),
      },
    );
  }

  testWidgets('should display all settings buttons', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SettingsScreen()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsScreen));
    final loc = AppLocalizations.of(context)!;

    expect(find.text(loc.change_the_language), findsOneWidget);
    expect(find.text(loc.change_the_mode), findsOneWidget);
    expect(find.text(loc.notification_enabled), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should navigate to language screen on first button press', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final mockObserver = MockNavigatorObserver();

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(
      createTestWidget(const SettingsScreen(), observer: mockObserver),
    );
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsScreen));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.text(loc.change_the_language));
    await tester.pumpAndSettle();

    expect(find.text('Language Screen'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should navigate to mode screen on second button press', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final mockObserver = MockNavigatorObserver();

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(
      createTestWidget(const SettingsScreen(), observer: mockObserver),
    );
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsScreen));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.text(loc.change_the_mode));
    await tester.pumpAndSettle();

    expect(find.text('Mode Screen'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should toggle notification state on third button press', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SettingsScreen()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsScreen));
    final loc = AppLocalizations.of(context)!;

    // enabled by default
    expect(find.text(loc.notification_enabled), findsOneWidget);

    // tap to disable
    await tester.tap(find.text(loc.notification_enabled));
    await tester.pumpAndSettle();
    expect(find.text(loc.notification_disabled), findsOneWidget);

    // tap to enable
    await tester.tap(find.text(loc.notification_disabled));
    await tester.pumpAndSettle();
    expect(find.text(loc.notification_enabled), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should have proper widget structure', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SettingsScreen()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(3));

    addTearDown(tester.view.resetPhysicalSize);
  });
}
