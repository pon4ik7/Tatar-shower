import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/screens/pref-screens/pref_2_screen.dart';
import 'package:tatar_shower/onboarding/onboarding_data.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';

void main() {
  Widget makeTestableWidget(Widget child, {Locale? locale}) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingData(),
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
        routes: {'/pref3': (context) => Scaffold(body: Text('Pref3 Screen'))},
      ),
    );
  }

  testWidgets('PreferencesScreen2 рендерит опции и позволяет выбрать одну', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PreferencesScreen2(), locale: const Locale('ru')),
    );

    expect(find.text('Каждый день'), findsOneWidget);
    expect(find.text('Только по рабочим дням'), findsOneWidget);
    expect(find.text('Другое'), findsOneWidget);

    await tester.tap(find.text('Каждый день'));
    await tester.pump();

    final selectedCircle = find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final decoration = widget.decoration as BoxDecoration;
        return decoration.shape == BoxShape.circle && decoration.color != null;
      }
      return false;
    });
    expect(selectedCircle, findsWidgets);
  });

  testWidgets('Кнопка Next переводит на /pref3 при выборе опции', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PreferencesScreen2(), locale: const Locale('ru')),
    );

    await tester.tap(find.text('Каждый день'));
    await tester.pump();

    await tester.tap(find.text('Дальше'));
    await tester.pumpAndSettle();

    expect(find.text('Pref3 Screen'), findsOneWidget);
  });

  testWidgets('Кнопка Next показывает SnackBar, если опция не выбрана', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PreferencesScreen2(), locale: const Locale('ru')),
    );

    await tester.tap(find.text('Дальше'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final context = tester.element(find.byType(PreferencesScreen2));
    final loc = AppLocalizations.of(context)!;

    expect(find.text(loc.choose_option), findsOneWidget);
  });

  testWidgets('Диалог выбора дней появляется при выборе "Другое" и работает', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PreferencesScreen2(), locale: const Locale('ru')),
    );

    await tester.tap(find.text('Другое'));
    await tester.pumpAndSettle();

    expect(find.text('Понедельник'), findsOneWidget);
    expect(find.text('Вторник'), findsOneWidget);

    await tester.tap(find.text('Понедельник'));
    await tester.pump();
    await tester.tap(find.text('Пятница'));
    await tester.pump();

    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Понедельник'), findsOneWidget);
    expect(find.textContaining('Пятница'), findsOneWidget);
  });

  testWidgets(
    'Диалог выбора дней показывает SnackBar, если не выбран ни один день',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(PreferencesScreen2(), locale: const Locale('ru')),
      );

      await tester.tap(find.text('Другое'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Сохранить'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final context = tester.element(find.byType(Dialog));
      final loc = AppLocalizations.of(context)!;

      expect(find.text(loc.choose_option), findsOneWidget);
    },
  );
}
