import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @choose_the_language.
  ///
  /// In en, this message translates to:
  /// **'Choose the language'**
  String get choose_the_language;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @choose_the_mode.
  ///
  /// In en, this message translates to:
  /// **'Choose the mode'**
  String get choose_the_mode;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @cold_shower_training.
  ///
  /// In en, this message translates to:
  /// **'COLD SHOWER TRAINING'**
  String get cold_shower_training;

  /// No description provided for @build_habit.
  ///
  /// In en, this message translates to:
  /// **'Build the cold shower habit and improve your well-being'**
  String get build_habit;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get get_started;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @e_mail.
  ///
  /// In en, this message translates to:
  /// **'e-mail'**
  String get e_mail;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get have_account;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get log_in;

  /// No description provided for @not_have_account.
  ///
  /// In en, this message translates to:
  /// **'Do not have an account? Sign Up'**
  String get not_have_account;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgor the password? Change it'**
  String get forgot_password;

  /// No description provided for @why_take_shower.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to take cold showers?'**
  String get why_take_shower;

  /// No description provided for @improve_health.
  ///
  /// In en, this message translates to:
  /// **'Improve health'**
  String get improve_health;

  /// No description provided for @increase_discipline.
  ///
  /// In en, this message translates to:
  /// **'Increase discipline'**
  String get increase_discipline;

  /// No description provided for @waking_up_easier.
  ///
  /// In en, this message translates to:
  /// **'Waking up easier'**
  String get waking_up_easier;

  /// No description provided for @challenge_yourself.
  ///
  /// In en, this message translates to:
  /// **'Challenge yourself'**
  String get challenge_yourself;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @how_often_take_shower.
  ///
  /// In en, this message translates to:
  /// **'How often do you want to take cold showers?'**
  String get how_often_take_shower;

  /// No description provided for @every_day.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get every_day;

  /// No description provided for @times_per_week.
  ///
  /// In en, this message translates to:
  /// **'3 times per week'**
  String get times_per_week;

  /// No description provided for @only_weekdays.
  ///
  /// In en, this message translates to:
  /// **'Only on weekdays'**
  String get only_weekdays;

  /// No description provided for @when_remind.
  ///
  /// In en, this message translates to:
  /// **'When should I remind you to exercise?'**
  String get when_remind;

  /// No description provided for @moring.
  ///
  /// In en, this message translates to:
  /// **'In the morning (8:00)'**
  String get moring;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'In the evening (19:00)'**
  String get evening;

  /// No description provided for @practice_before.
  ///
  /// In en, this message translates to:
  /// **'Have you practiced cold showers before?'**
  String get practice_before;

  /// No description provided for @no_practice.
  ///
  /// In en, this message translates to:
  /// **'No, it\'s the first time'**
  String get no_practice;

  /// No description provided for @tried.
  ///
  /// In en, this message translates to:
  /// **'Tried it a couple of times'**
  String get tried;

  /// No description provided for @practice_regularly.
  ///
  /// In en, this message translates to:
  /// **'Practice regularly'**
  String get practice_regularly;

  /// No description provided for @minimum_streak.
  ///
  /// In en, this message translates to:
  /// **'What is the minimum streak you want to achieve?'**
  String get minimum_streak;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get week;

  /// No description provided for @two_weeks.
  ///
  /// In en, this message translates to:
  /// **'14 days'**
  String get two_weeks;

  /// No description provided for @three_weeks.
  ///
  /// In en, this message translates to:
  /// **'21 days'**
  String get three_weeks;

  /// No description provided for @your_streak.
  ///
  /// In en, this message translates to:
  /// **'enter your streak'**
  String get your_streak;

  /// No description provided for @done_prefs.
  ///
  /// In en, this message translates to:
  /// **'Done! Start your first cold adventure!'**
  String get done_prefs;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
