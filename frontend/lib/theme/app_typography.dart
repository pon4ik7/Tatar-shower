// lib/theme/app_typography.dart
import 'package:flutter/material.dart';

/// Все ваши вариации шрифтов и размеров.
/// Мы определим их в текстовых темах для light и dark.
class AppTypography {
  // RussoOne
  static const _russo = 'RussoOne';
  // Inter
  static const _inter = 'Inter';

  /// Размеры
  static const double _r40 = 40;
  static const double _r24 = 24;
  static const double _r20 = 20;
  static const double _r14 = 14;
  static const double _r12 = 12;

  static const double _i20 = 20;
  static const double _i16 = 16;
  static const double _i15 = 15;
  static const double _i14 = 14;
  static const double _i13 = 13;
  static const double _i12 = 12;
  static const double _i11 = 11;

  /// Текстовая тема для светлой схемы
  static TextTheme lightTextTheme(
    Color primary,
    Color onBackground,
  ) => TextTheme(
    // RussoOne40 FF405282
    displayLarge: TextStyle(fontFamily: _russo, fontSize: _r40, color: primary),
    // RussoOne40 FFFFFFFF
    displayMedium: TextStyle(
      fontFamily: _russo,
      fontSize: _r40,
      color: Colors.white,
    ),
    // RussoOne24 FFFFFFFF
    displaySmall: TextStyle(
      fontFamily: _russo,
      fontSize: _r24,
      color: Colors.white,
    ),
    // RussoOne24 FF405282
    headlineLarge: TextStyle(
      fontFamily: _russo,
      fontSize: _r24,
      color: primary,
    ),
    // RussoOne20 FF405282
    headlineMedium: TextStyle(
      fontFamily: _russo,
      fontSize: _r20,
      color: primary,
    ),
    // RussoOne20 FFFFFFFF
    headlineSmall: TextStyle(
      fontFamily: _russo,
      fontSize: _r20,
      color: Colors.white,
    ),
    // RussoOne14 FF000000
    titleLarge: TextStyle(
      fontFamily: _russo,
      fontSize: _r14,
      color: Colors.black,
    ),
    // RussoOne12 FF000000
    titleMedium: TextStyle(
      fontFamily: _russo,
      fontSize: _r12,
      color: Colors.black,
    ),

    // Inter20 FF000000
    bodyLarge: TextStyle(
      fontFamily: _inter,
      fontSize: _i20,
      color: Colors.black,
    ),
    // Inter20 FF405282
    bodyMedium: TextStyle(fontFamily: _inter, fontSize: _i20, color: primary),
    // Inter16 FF405282
    bodySmall: TextStyle(fontFamily: _inter, fontSize: _i16, color: primary),

    // Inter15 FF000000
    labelLarge: TextStyle(
      fontFamily: _inter,
      fontSize: _i15,
      color: Colors.black,
    ),
    // Inter14 FF000000
    labelMedium: TextStyle(
      fontFamily: _inter,
      fontSize: _i14,
      color: Colors.black,
    ),
    // Inter13 FF405282
    labelSmall: TextStyle(fontFamily: _inter, fontSize: _i13, color: primary),

    // Для самых мелких
    // Inter12 FF000000
    titleSmall: TextStyle(
      fontFamily: _inter,
      fontSize: _i12,
      color: Colors.black,
    ),
    // Inter11 FF405282
    //caption: TextStyle(fontFamily: _inter, fontSize: _i11, color: primary),
  );

  /// Текстовая тема для тёмной схемы
  /// здесь мы меняем только те цвета, что отличаются
  static TextTheme darkTextTheme(Color primary, Color onBackground) {
    // В тёмной теме primary обычно тот же, меняем onBackground на белый
    return lightTextTheme(primary, onBackground).copyWith(
      // RussoOne40 FFFFFFFF вместо FF405282
      displayLarge: TextStyle(
        fontFamily: _russo,
        fontSize: _r40,
        color: onBackground,
      ),
      // RussoOne24 FFFFFFFF вместо FF405282
      headlineLarge: TextStyle(
        fontFamily: _russo,
        fontSize: _r24,
        color: onBackground,
      ),
      // RussoOne20 FFFFFFFF вместо FF405282
      headlineMedium: TextStyle(
        fontFamily: _russo,
        fontSize: _r20,
        color: onBackground,
      ),
      // Inter20 FF405282 вместо FF000000
      bodyLarge: TextStyle(fontFamily: _inter, fontSize: _i20, color: primary),
      // Inter16 FF405282 вместо FF000000
      bodySmall: TextStyle(fontFamily: _inter, fontSize: _i16, color: primary),
      // Inter13 FF405282 вместо FF000000
      labelSmall: TextStyle(fontFamily: _inter, fontSize: _i13, color: primary),
      // Inter11 FF000000 вместо FF405282 — если нужен чёрный текст на тёмном фоне
      //caption: TextStyle(fontFamily: _inter, fontSize: _i11, color: onBackground),
    );
  }
}
