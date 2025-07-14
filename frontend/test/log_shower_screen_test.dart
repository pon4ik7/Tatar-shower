import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/models/shower_model.dart';
import 'package:tatar_shower/screens/main-screens/timer-screens/log_shower_screen.dart';

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];
  final List<Route<dynamic>> poppedRoutes = [];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }

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
      routes: {'/tabs': (context) => const Scaffold(body: Text('Tabs Screen'))},
    );
  }

  ShowerLog testLog = ShowerLog(
    date: DateTime(2024, 6, 1, 8, 30),
    totalDuration: const Duration(minutes: 12, seconds: 34),
    coldDuration: const Duration(minutes: 2, seconds: 5),
  );

  testWidgets('should display all stats and buttons', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(ShowerResultScreen(log: testLog)));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    // Date label (check for month and day)
    final formattedDate = DateFormat.MMMMd('en').format(testLog.date);
    expect(find.text(formattedDate), findsOneWidget);

    // Duration
    expect(find.text('12:34'), findsOneWidget);
    // Cold duration
    expect(find.text('02:05'), findsOneWidget);

    // Buttons
    expect(find.widgetWithText(ElevatedButton, 'Log shower'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Cancel'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should navigate to /tabs when Cancel is pressed', (
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
      createTestWidget(
        ShowerResultScreen(log: testLog),
        observer: mockObserver,
      ),
    );
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    await tester.tap(find.widgetWithText(ElevatedButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Tabs Screen'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should have correct widget structure', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(ShowerResultScreen(log: testLog)));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Row), findsWidgets);
    expect(find.byType(Column), findsWidgets);
    expect(find.byType(ElevatedButton), findsNWidgets(2));

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should format durations correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    final log = ShowerLog(
      date: DateTime(2024, 6, 1, 8, 30),
      totalDuration: const Duration(minutes: 0, seconds: 9),
      coldDuration: const Duration(minutes: 0, seconds: 5),
    );

    await tester.pumpWidget(createTestWidget(ShowerResultScreen(log: log)));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    expect(find.text('00:09'), findsOneWidget);
    expect(find.text('00:05'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });
}
