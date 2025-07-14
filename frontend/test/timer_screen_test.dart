// test/timer_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/main-screens/timer-screens/timer_screen.dart';

Future<void> _pumpTimer(
  WidgetTester tester, {
  Duration cold = const Duration(seconds: 3),
  Duration warm = const Duration(seconds: 3),
  int periods = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      // ←--- добавили делегаты локализации
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: TimerScreen(
        coldDuration: cold,
        warmDuration: warm,
        periods: periods,
      ),
    ),
  );
  await tester.pump(); // первый кадр
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimerScreen smoke-tests', () {
    testWidgets('экран строится и показывает начальное время', (tester) async {
      await _pumpTimer(tester);
      expect(find.text('00:03'), findsOneWidget); // проверяем только таймер
    });

    testWidgets('таймер уменьшается на секунду', (tester) async {
      await _pumpTimer(tester);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:02'), findsOneWidget);
    });
  });
}
