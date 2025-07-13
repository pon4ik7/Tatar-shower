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

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'confirm password'**
  String get confirm_password;

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

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @newShower.
  ///
  /// In en, this message translates to:
  /// **'New shower'**
  String get newShower;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @coldDuration.
  ///
  /// In en, this message translates to:
  /// **'Cold shower'**
  String get coldDuration;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @showers.
  ///
  /// In en, this message translates to:
  /// **'showers'**
  String get showers;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @recentShowers.
  ///
  /// In en, this message translates to:
  /// **'Resent showers'**
  String get recentShowers;

  /// No description provided for @change_the_language.
  ///
  /// In en, this message translates to:
  /// **'Change the language'**
  String get change_the_language;

  /// No description provided for @change_the_mode.
  ///
  /// In en, this message translates to:
  /// **'Change the mode'**
  String get change_the_mode;

  /// No description provided for @notification_enabled.
  ///
  /// In en, this message translates to:
  /// **'Notification Enabled'**
  String get notification_enabled;

  /// No description provided for @notification_disabled.
  ///
  /// In en, this message translates to:
  /// **'Notification disabled'**
  String get notification_disabled;

  /// No description provided for @error_username_short.
  ///
  /// In en, this message translates to:
  /// **'From 5 to 30 characters'**
  String get error_username_short;

  /// No description provided for @error_password_short.
  ///
  /// In en, this message translates to:
  /// **'At least 5 characters'**
  String get error_password_short;

  /// No description provided for @error_passwords_must_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get error_passwords_must_match;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @enter_your_streak.
  ///
  /// In en, this message translates to:
  /// **'Enter your streak'**
  String get enter_your_streak;

  /// No description provided for @error_enter_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get error_enter_number;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @choose_option.
  ///
  /// In en, this message translates to:
  /// **'Choose option'**
  String get choose_option;
  
  /// No description provided for @start_shower.
  ///
  /// In en, this message translates to:
  /// **'Start shower'**
  String get start_shower;

  /// No description provided for @stop_shower.
  ///
  /// In en, this message translates to:
  /// **'Stop shower'**
  String get stop_shower;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @set_previous_settings.
  ///
  /// In en, this message translates to:
  /// **'Set previous settings'**
  String get set_previous_settings;

  /// No description provided for @cold_water_time.
  ///
  /// In en, this message translates to:
  /// **'Cold water time'**
  String get cold_water_time;

  /// No description provided for @warm_water_time.
  ///
  /// In en, this message translates to:
  /// **'Warm water time'**
  String get warm_water_time;

  /// No description provided for @number_of_periods.
  ///
  /// In en, this message translates to:
  /// **'Number of periods'**
  String get number_of_periods;

  /// No description provided for @invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get invalid_format;

  /// No description provided for @enter_a_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get enter_a_number;

  /// No description provided for @cold_water.
  ///
  /// In en, this message translates to:
  /// **'Cold water'**
  String get cold_water;

  /// No description provided for @warm_water.
  ///
  /// In en, this message translates to:
  /// **'Warm water'**
  String get warm_water;

  /// No description provided for @time_is_out.
  ///
  /// In en, this message translates to:
  /// **'Time is out'**
  String get time_is_out;

  /// No description provided for @rounds_left.
  ///
  /// In en, this message translates to:
  /// **'Rounds left: {count}'**
  String rounds_left(Object count);

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @info_text.
  ///
  /// In en, this message translates to:
  /// **'Set the time for warm and cold water, choose how many periods you want, and click Start shower.'**
  String get info_text;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @log_shower.
  ///
  /// In en, this message translates to:
  /// **'Log shower'**
  String get log_shower;

  /// No description provided for @mm_ss.
  ///
  /// In en, this message translates to:
  /// **'mm:ss'**
  String get mm_ss;
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
