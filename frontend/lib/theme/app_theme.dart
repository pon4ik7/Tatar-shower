import 'package:flutter/material.dart';

@immutable
class AppAssets extends ThemeExtension<AppAssets> {
  final String background;
  final String calendar;
  final String clock;
  final String frozen;
  final String liquid;
  final String run;
  final String shower;
  final String splash;
  final String target;

  const AppAssets({
    required this.background,
    required this.calendar,
    required this.clock,
    required this.frozen,
    required this.liquid,
    required this.run,
    required this.shower,
    required this.splash,
    required this.target,
  });

  @override
  AppAssets copyWith({
    String? background,
    String? calendar,
    String? clock,
    String? frozen,
    String? liquid,
    String? run,
    String? shower,
    String? splash,
    String? target,
  }) {
    return AppAssets(
      background: background ?? this.background,
      calendar: calendar ?? this.calendar,
      clock: clock ?? this.clock,
      frozen: frozen ?? this.frozen,
      liquid: liquid ?? this.liquid,
      run: run ?? this.run,
      shower: shower ?? this.shower,
      splash: splash ?? this.splash,
      target: target ?? this.target,
    );
  }

  @override
  AppAssets lerp(ThemeExtension<AppAssets>? other, double t) {
    if (other is! AppAssets) return this;
    return t < 0.5 ? this : other;
  }
}

final ThemeData lightTheme = ThemeData(
  primaryColorLight: Color(0xFFFFFFFF),
  primaryColorDark: Color(0xFF0D0B44),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'RussoOne',
      fontSize: 40,
      color: Color(0xFF405292),
    ),
    displayMedium: TextStyle(
      fontFamily: 'RussoOne',
      fontSize: 24,
      color: Color(0xFFFFFFFF),
    ),
    displaySmall: TextStyle(
      fontFamily: 'RussoOne',
      fontSize: 20,
      color: Color(0xFF405292),
    ),
  ),
);
