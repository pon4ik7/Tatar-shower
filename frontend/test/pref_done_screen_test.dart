import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tatar_shower/screens/pref-screens/pref_done_screen.dart';
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
        routes: {'/tabs': (context) => Scaffold(body: Text('Tabs Screen'))},
      ),
    );
  }

  testWidgets('PreferencesDoneScreen отображает основные элементы', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(
        const PreferencesDoneScreen(),
        locale: const Locale('ru'),
      ),
    );

    expect(
      find.text('Готово! Начните свое холодное приключение!'),
      findsOneWidget,
    );

    expect(find.byType(ElevatedButton), findsOneWidget);

    expect(find.byType(Image), findsNWidgets(3));
  });

  testWidgets('Кнопка Start отображается и активна, если не загружается', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(
        const PreferencesDoneScreen(),
        locale: const Locale('ru'),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать');
    expect(startButton, findsOneWidget);
    expect(tester.widget<ElevatedButton>(startButton).onPressed, isNotNull);
  });
}
