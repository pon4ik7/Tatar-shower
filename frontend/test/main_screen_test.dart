import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/main-screens/main_screen.dart';
import 'package:tatar_shower/screens/main-screens/full_table_screen.dart';

Future<void> _pumpMain(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScreen(),
    ),
  );
  await tester.pump(); // первый кадр
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MainScreen smoke-tests', () {
    testWidgets('экран строится и показывает диаграмму + таблицу', (
      tester,
    ) async {
      await _pumpMain(tester);

      // Число «7» в центре круговой диаграммы
      expect(find.text('7'), findsOneWidget);

      // Таблица с душами
      expect(find.byType(DataTable), findsOneWidget);

      // Проверяем, что все 4 строки-заглушки на месте
      const dates = ['Jul 7', 'Jul 4', 'Jul 1', 'Jun 28'];
      for (final d in dates) {
        expect(find.text(d), findsOneWidget);
      }
    });

    testWidgets('тап по таблице открывает FullTableScreen', (tester) async {
      await _pumpMain(tester);

      // Тап по DataTable (обёрнут GestureDetector'ом)
      await tester.tap(find.byType(DataTable));
      await tester.pumpAndSettle();

      // Ожидаем переход
      expect(find.byType(FullTableScreen), findsOneWidget);
    });
  });
}
