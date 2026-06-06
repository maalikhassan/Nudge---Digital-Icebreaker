import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

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
    Locale('si'),
    Locale('ta')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Nudge'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Break the ice'**
  String get tagline;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Hi! Which language do you prefer?'**
  String get selectLanguage;

  /// No description provided for @selectScenario.
  ///
  /// In en, this message translates to:
  /// **'Where are you right now?'**
  String get selectScenario;

  /// No description provided for @onTrain.
  ///
  /// In en, this message translates to:
  /// **'On a Train / Bus'**
  String get onTrain;

  /// No description provided for @atCafe.
  ///
  /// In en, this message translates to:
  /// **'At a Cafe'**
  String get atCafe;

  /// No description provided for @inClass.
  ///
  /// In en, this message translates to:
  /// **'In Class / Lecture'**
  String get inClass;

  /// No description provided for @waitingRoom.
  ///
  /// In en, this message translates to:
  /// **'Waiting Room'**
  String get waitingRoom;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hey! 👋'**
  String get greeting;

  /// No description provided for @iceBreakPrompt.
  ///
  /// In en, this message translates to:
  /// **'Someone next to you thought you might want to chat.'**
  String get iceBreakPrompt;

  /// No description provided for @topicsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pick a topic to start with:'**
  String get topicsLabel;

  /// No description provided for @topic1.
  ///
  /// In en, this message translates to:
  /// **'Music & Movies'**
  String get topic1;

  /// No description provided for @topic2.
  ///
  /// In en, this message translates to:
  /// **'Food & Places'**
  String get topic2;

  /// No description provided for @topic3.
  ///
  /// In en, this message translates to:
  /// **'Work / Studies'**
  String get topic3;

  /// No description provided for @topic4.
  ///
  /// In en, this message translates to:
  /// **'Just vibing, no agenda'**
  String get topic4;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks, I\'m good'**
  String get noThanks;

  /// No description provided for @thanksMessage.
  ///
  /// In en, this message translates to:
  /// **'No worries! Have a great day 😊'**
  String get thanksMessage;

  /// No description provided for @chatStarted.
  ///
  /// In en, this message translates to:
  /// **'Great! Show this to each other 👇'**
  String get chatStarted;

  /// No description provided for @topicChosen.
  ///
  /// In en, this message translates to:
  /// **'You chose:'**
  String get topicChosen;

  /// No description provided for @startOver.
  ///
  /// In en, this message translates to:
  /// **'Start Over'**
  String get startOver;

  /// No description provided for @handoverHint.
  ///
  /// In en, this message translates to:
  /// **'Hand the phone to them →'**
  String get handoverHint;
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
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
