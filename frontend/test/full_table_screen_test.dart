import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/main-screens/full_table_screen.dart';

Future<void> _pumpScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const FullTableScreen(),
    ),
  );

  await tester.pump(); // первый кадр
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FullTableScreen smoke-tests', () {
    testWidgets('экран строится и показывает таблицу', (tester) async {
      await _pumpScreen(tester);

      // Заголовок AppBar
      expect(find.byType(AppBar), findsOneWidget);
      // Таблица
      expect(find.byType(DataTable), findsOneWidget);
      // Первая дата
      expect(find.text('Jul 7'), findsOneWidget);
    });

    testWidgets('присутствуют все 4 «рыбные» строки', (tester) async {
      await _pumpScreen(tester);

      const dates = ['Jul 7', 'Jul 4', 'Jul 1', 'Jun 28'];
      for (final d in dates) {
        expect(find.text(d), findsOneWidget);
      }
    });

    testWidgets('экран допускает горизонтальный скролл', (tester) async {
      await _pumpScreen(tester);

      final scroll = find.byWidgetPredicate(
        (w) =>
            w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
      );
      expect(scroll, findsOneWidget);
    });
  });
}
