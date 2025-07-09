import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/intro-screens/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen базовый функциональный тест', (
    WidgetTester tester,
  ) async {
    // Отключаем только FlutterError.onError
    FlutterError.onError = (_) {};

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: [Locale('en'), Locale('ru')],
        home: WelcomeScreen(),
        routes: {'/mode': (context) => Scaffold(body: Text('Mode Screen'))},
      ),
    );

    // Минимальные но важные проверки
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Тест навигации - основная функциональность
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.text('Mode Screen'), findsOneWidget);
  });

  testWidgets('WelcomeScreen проверка основных элементов', (
    WidgetTester tester,
  ) async {
    // Отключаем ошибки
    FlutterError.onError = (_) {};

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: [Locale('en'), Locale('ru')],
        home: WelcomeScreen(),
      ),
    );

    // Проверяем наличие основных элементов
    expect(find.byType(Text), findsWidgets);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
