import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/main-screens/settings-screens/settings_mode_screen.dart';

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> poppedRoutes = [];
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    poppedRoutes.add(route);
    super.didPop(route, previousRoute);
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
    );
  }

  testWidgets('should display mode options correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SettingsMode()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsMode));
    final loc = AppLocalizations.of(context)!;

    expect(find.text(loc.light), findsOneWidget);
    expect(find.text(loc.dark), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should select light by default', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SettingsMode()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsMode));
    final loc = AppLocalizations.of(context)!;

    final lightOption = find
        .ancestor(of: find.text(loc.light), matching: find.byType(Container))
        .first;
    final Container lightContainer = tester.widget(lightOption);
    expect(lightContainer.color, isNot(Colors.transparent));

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should change selection when tapping on dark', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SettingsMode()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsMode));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.text(loc.dark));
    await tester.pumpAndSettle();

    final darkText = tester.widget<Text>(find.text(loc.dark));
    expect(darkText.style?.fontWeight, equals(FontWeight.bold));

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should change selection when tapping on light', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SettingsMode()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsMode));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.text(loc.dark));
    await tester.pumpAndSettle();

    await tester.tap(find.text(loc.light));
    await tester.pumpAndSettle();

    final lightText = tester.widget<Text>(find.text(loc.light));
    expect(lightText.style?.fontWeight, equals(FontWeight.bold));

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should pop when Apply button is pressed', (
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
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsMode()));
            },
            child: const Text('Open SettingsMode'),
          ),
        ),
        navigatorObservers: [mockObserver],
      ),
    );
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    await tester.tap(find.text('Open SettingsMode'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsMode), findsOneWidget);

    final BuildContext context = tester.element(find.byType(SettingsMode));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(SettingsMode), findsNothing);

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

    await tester.pumpWidget(createTestWidget(const SettingsMode()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Stack), findsWidgets);
    expect(find.byType(InkWell), findsWidgets);
    expect(find.byType(ElevatedButton), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should display visual selection indicator', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SettingsMode()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final BuildContext context = tester.element(find.byType(SettingsMode));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.text(loc.dark));
    await tester.pumpAndSettle();

    final darkText = tester.widget<Text>(find.text(loc.dark));
    expect(darkText.style?.fontWeight, equals(FontWeight.bold));

    addTearDown(tester.view.resetPhysicalSize);
  });
}
