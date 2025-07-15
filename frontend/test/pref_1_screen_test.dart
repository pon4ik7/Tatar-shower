import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/screens/pref-screens/pref_1_screen.dart';
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
        routes: {
          '/pref2': (context) => Scaffold(body: Text('Pref2 Screen')),
          '/tabs': (context) => Scaffold(body: Text('Tabs Screen')),
        },
      ),
    );
  }

  testWidgets(
    'Кнопка Next показывает SnackBar, если опция не выбрана (русский)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(PreferencesScreen1(), locale: const Locale('ru')),
      );
      await tester.tap(find.text('Дальше'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final context = tester.element(find.byType(PreferencesScreen1));
      final loc = AppLocalizations.of(context)!;

      expect(find.text(loc.choose_option), findsOneWidget);
    },
  );

  testWidgets('Next button shows SnackBar if no option is selected (english)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(PreferencesScreen1(), locale: const Locale('en')),
    );
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final context = tester.element(find.byType(PreferencesScreen1));
    final loc = AppLocalizations.of(context)!;

    expect(find.text(loc.choose_option), findsOneWidget);
  });
}
