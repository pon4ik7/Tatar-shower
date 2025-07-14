import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/main-screens/main_screen.dart';
import 'package:tatar_shower/screens/main-screens/settings-screens/settings_screen.dart';
import 'package:tatar_shower/screens/main-screens/timer-screens/set_timer_screen.dart';
import 'package:tatar_shower/screens/main-screens/tabs.dart';

Future<void> _pumpTabs(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Tabs(),
    ),
  );
  await tester.pump(); // первый кадр
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tabs widget', () {
    testWidgets('первый экран — MainScreen, три иконки в баре', (tester) async {
      await _pumpTabs(tester);

      // выбран MainScreen
      expect(find.byType(MainScreen), findsOneWidget);

      // в BottomNavigationBar ровно три ImageIcon
      expect(find.byType(ImageIcon), findsNWidgets(3));
    });

    testWidgets('переключение между тремя вкладками', (tester) async {
      await _pumpTabs(tester);

      final icons = find.byType(ImageIcon);

      // → 2-я вкладка (SetTimerScreen)
      await tester.tap(icons.at(1));
      await tester.pumpAndSettle();
      expect(find.byType(SetTimerScreen), findsOneWidget);

      // → 3-я вкладка (SettingsScreen)
      await tester.tap(icons.at(2));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
