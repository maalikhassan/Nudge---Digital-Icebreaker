// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nudge';

  @override
  String get tagline => 'Break the ice';

  @override
  String get selectLanguage => 'Hi! Which language do you prefer?';

  @override
  String get selectScenario => 'Where are you right now?';

  @override
  String get onTrain => 'On a Train / Bus';

  @override
  String get atCafe => 'At a Cafe';

  @override
  String get inClass => 'In Class / Lecture';

  @override
  String get waitingRoom => 'Waiting Room';

  @override
  String get greeting => 'Hey! 👋';

  @override
  String get iceBreakPrompt =>
      'Someone next to you thought you might want to chat.';

  @override
  String get topicsLabel => 'Pick a topic to start with:';

  @override
  String get topic1 => 'Music & Movies';

  @override
  String get topic2 => 'Food & Places';

  @override
  String get topic3 => 'Work / Studies';

  @override
  String get topic4 => 'Just vibing, no agenda';

  @override
  String get noThanks => 'No thanks, I\'m good';

  @override
  String get thanksMessage => 'No worries! Have a great day 😊';

  @override
  String get chatStarted => 'Great! Show this to each other 👇';

  @override
  String get topicChosen => 'You chose:';

  @override
  String get startOver => 'Start Over';

  @override
  String get handoverHint => 'Hand the phone to them →';
}
