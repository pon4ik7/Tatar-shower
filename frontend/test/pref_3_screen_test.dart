import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/screens/pref-screens/pref_3_screen.dart';
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
        routes: {'/pref4': (context) => Scaffold(body: Text('Pref4 Screen'))},
      ),
    );
  }

  testWidgets('PreferencesScreen3 рендерит опции и позволяет выбрать одну', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PreferencesScreen3(), locale: const Locale('ru')),
    );

    expect(find.text('Утром (8:00)'), findsOneWidget);
    expect(find.text('Вечером (19:00)'), findsOneWidget);
    expect(find.text('Другое'), findsOneWidget);

    await tester.tap(find.text('Вечером (19:00)'));
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

  testWidgets('Кнопка Next переводит на /pref4 при выборе опции', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PreferencesScreen3(), locale: const Locale('ru')),
    );

    await tester.tap(find.text('Утром (8:00)'));
    await tester.pump();

    await tester.tap(find.text('Дальше'));
    await tester.pumpAndSettle();

    expect(find.text('Pref4 Screen'), findsOneWidget);
  });

  testWidgets('Кнопка Next показывает SnackBar, если опция не выбрана', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PreferencesScreen3(), locale: const Locale('ru')),
    );

    await tester.tap(find.text('Дальше'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final context = tester.element(find.byType(PreferencesScreen3));
    final loc = AppLocalizations.of(context)!;

    expect(find.text(loc.choose_option), findsOneWidget);
  });

  testWidgets(
    'Диалог выбора времени появляется при выборе "Другое" и сохраняет время',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(PreferencesScreen3(), locale: const Locale('ru')),
      );

      await tester.tap(find.text('Другое'));
      await tester.pumpAndSettle();

      expect(find.text('Отменить'), findsOneWidget);
      expect(find.text('Сохранить'), findsOneWidget);

      await tester.tap(find.text('Сохранить'));
      await tester.pumpAndSettle();

      final timePattern = RegExp(r'(\d{1,2}:\d{2} (AM|PM))|(\d{1,2}:\d{2})');
      final customTimeFinder = find.byWidgetPredicate((widget) {
        if (widget is Text) {
          return timePattern.hasMatch(widget.data ?? '');
        }
        return false;
      });
      expect(customTimeFinder, findsWidgets);
    },
  );
}
