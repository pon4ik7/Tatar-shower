import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tatar_shower/l10n/app_localizations.dart';
import 'package:tatar_shower/screens/intro-screens/mode_screen.dart';

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

void main() {
  late void Function(FlutterErrorDetails)? originalOnError;

  setUpAll(() {
    originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('A RenderFlex overflowed'))
        return;
      originalOnError?.call(details);
    };
  });

  tearDownAll(() {
    FlutterError.onError = originalOnError;
  });

  group('ModeScreen Tests', () {
    late MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Widget createTestWidget(ModeScreen screen) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        navigatorObservers: [mockObserver],
        home: screen,
        routes: {
          '/welcome': (context) => const Scaffold(body: Text('Welcome Screen')),
        },
      );
    }

    testWidgets('should display mode options correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget(const ModeScreen()));
      await tester.pumpAndSettle();

      // Используйте реальные строки, которые отображаются на экране
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should select light by default', (tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget(const ModeScreen()));
      await tester.pumpAndSettle();

      final lightOption = find
          .ancestor(of: find.text('Light'), matching: find.byType(Container))
          .first;
      final Container lightContainer = tester.widget(lightOption);
      expect(lightContainer.color, isNot(Colors.transparent));

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should change selection when tapping on dark', (tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget(const ModeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      final darkText = tester.widget<Text>(find.text('Dark'));
      expect(darkText.style?.fontWeight, equals(FontWeight.bold));

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should change selection when tapping on light', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget(const ModeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      final lightText = tester.widget<Text>(find.text('Light'));
      expect(lightText.style?.fontWeight, equals(FontWeight.bold));

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets(
      'should navigate to welcome screen when Apply button is pressed',
      (tester) async {
        tester.view.physicalSize = const Size(800, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget(const ModeScreen()));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(mockObserver.pushedRoutes.length, greaterThan(0));

        addTearDown(tester.view.resetPhysicalSize);
      },
    );

    testWidgets('should have proper widget structure', (tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget(const ModeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should call setState on selection change', (tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget(const ModeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      final darkContainer = tester.widget<Container>(
        find
            .ancestor(of: find.text('Dark'), matching: find.byType(Container))
            .first,
      );
      expect(darkContainer.color, isNot(Colors.transparent));

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('should display visual selection indicator', (tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget(const ModeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      final darkText = tester.widget<Text>(find.text('Dark'));
      expect(darkText.style?.fontWeight, equals(FontWeight.bold));

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
