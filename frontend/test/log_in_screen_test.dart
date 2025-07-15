import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tatar_shower/screens/reg-auth-screens/log_in_screen.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';

void main() {
  Widget makeTestableWidget(Widget child, {Locale? locale}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
      routes: {
        '/tabs': (context) => Scaffold(body: Text('Tabs Screen')),
        '/signup': (context) => Scaffold(body: Text('Signup Screen')),
      },
    );
  }

  testWidgets('LogInScreen отображает нужные элементы', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(const LogInScreen(), locale: const Locale('ru')),
    );

    // Проверяем заголовок
    final context = tester.element(find.byType(Scaffold));
    final loc = AppLocalizations.of(context)!;
    expect(find.text(loc.log_in), findsWidgets); // Заголовок и кнопка входа

    // Проверяем поля ввода через подсказки
    expect(find.widgetWithText(TextField, loc.username), findsOneWidget);
    expect(find.widgetWithText(TextField, loc.password), findsOneWidget);

    // Проверяем наличие кнопки "Войти"
    expect(find.widgetWithText(ElevatedButton, loc.log_in), findsOneWidget);

    // Ссылки "Нет аккаунта" и "Забыли пароль"
    expect(
      find.widgetWithText(TextButton, loc.not_have_account),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextButton, loc.forgot_password),
      findsOneWidget,
    );
  });

  testWidgets('Кнопка входа переводит на /tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(const LogInScreen(), locale: const Locale('ru')),
    );

    final context = tester.element(find.byType(Scaffold));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.widgetWithText(ElevatedButton, loc.log_in));
    await tester.pumpAndSettle();

    expect(find.text('Tabs Screen'), findsOneWidget);
  });

  testWidgets('Кнопка "Нет аккаунта" переводит на /signup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(const LogInScreen(), locale: const Locale('ru')),
    );

    final context = tester.element(find.byType(Scaffold));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.widgetWithText(TextButton, loc.not_have_account));
    await tester.pumpAndSettle();

    expect(find.text('Signup Screen'), findsOneWidget);
  });

  testWidgets('Кнопка "Забыли пароль" не вызывает переход', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(const LogInScreen(), locale: const Locale('ru')),
    );

    final context = tester.element(find.byType(Scaffold));
    final loc = AppLocalizations.of(context)!;

    await tester.tap(find.widgetWithText(TextButton, loc.forgot_password));
    await tester.pumpAndSettle();

    // Остаёмся на экране логина (виден хотя бы один TextField)
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
