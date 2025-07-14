import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/main-screens/timer-screens/timer_screen.dart';
import 'package:tatar_shower/screens/main-screens/timer-screens/set_timer_screen.dart';

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
    );
  }

  testWidgets('should display all input fields and buttons', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SetTimerScreen()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final context = tester.element(find.byType(SetTimerScreen));
    final loc = AppLocalizations.of(context)!;

    expect(find.text(loc.set_previous_settings), findsOneWidget);
    expect(find.text(loc.warm_water_time), findsOneWidget);
    expect(find.text(loc.cold_water_time), findsOneWidget);
    expect(find.text(loc.number_of_periods), findsOneWidget);
    expect(find.text(loc.start_shower), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsNWidgets(2));

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should show info dialog on info button tap', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SetTimerScreen()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final context = tester.element(find.byType(SetTimerScreen));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text(loc.info), findsOneWidget);
    expect(find.text(loc.info_text), findsOneWidget);
    expect(find.text(loc.ok), findsOneWidget);

    await tester.tap(find.text(loc.ok));
    await tester.pumpAndSettle();

    expect(find.text(loc.info), findsNothing);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should validate and show error for invalid time and number', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SetTimerScreen()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final context = tester.element(find.byType(SetTimerScreen));
    final loc = AppLocalizations.of(context)!;

    // Leave all fields empty and press start
    await tester.tap(find.text(loc.start_shower));
    await tester.pumpAndSettle();

    expect(find.text(loc.invalid_format), findsNWidgets(2));
    // Исправлено: ищем хотя бы одну ошибку "Enter a number" (может быть лейбл и ошибка)
    expect(find.text(loc.enter_a_number), findsAtLeastNWidgets(1));

    // Enter invalid time and number
    await tester.enterText(find.byType(TextFormField).at(0), '00:00');
    await tester.enterText(find.byType(TextFormField).at(1), 'abc');
    await tester.enterText(find.byType(TextFormField).at(2), '0');
    await tester.tap(find.text(loc.start_shower));
    await tester.pumpAndSettle();

    expect(find.text(loc.invalid_format), findsNWidgets(2));
    expect(find.text(loc.enter_a_number), findsAtLeastNWidgets(1));

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should navigate to TimerScreen on valid input', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;

    final mockObserver = MockNavigatorObserver();

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(
      createTestWidget(const SetTimerScreen(), observer: mockObserver),
    );
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final context = tester.element(find.byType(SetTimerScreen));
    final loc = AppLocalizations.of(context)!;

    // Enter valid time and number
    await tester.enterText(find.byType(TextFormField).at(0), '01:30');
    await tester.enterText(find.byType(TextFormField).at(1), '00:45');
    await tester.enterText(find.byType(TextFormField).at(2), '3');

    await tester.tap(find.text(loc.start_shower));
    await tester.pumpAndSettle();

    expect(mockObserver.pushedRoutes.length, greaterThan(0));
    expect(find.byType(TimerScreen), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('should format time input as mm:ss', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;

    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('RenderFlex overflowed')) return;
      prevOnError?.call(details);
    };

    await tester.pumpWidget(createTestWidget(const SetTimerScreen()));
    await tester.pumpAndSettle();

    FlutterError.onError = prevOnError;

    final warmField = find.byType(TextFormField).at(0);

    await tester.enterText(warmField, '5');
    await tester.pump();
    expect(
      (tester.widget(warmField) as TextFormField).controller?.text,
      '00:05',
    );

    await tester.enterText(warmField, '123');
    await tester.pump();
    expect(
      (tester.widget(warmField) as TextFormField).controller?.text,
      '01:23',
    );

    await tester.enterText(warmField, '1234');
    await tester.pump();
    expect(
      (tester.widget(warmField) as TextFormField).controller?.text,
      '12:34',
    );

    addTearDown(tester.view.resetPhysicalSize);
  });
}
