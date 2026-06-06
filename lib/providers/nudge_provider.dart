import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// NudgeProvider holds ALL the app's state.
// It extends ChangeNotifier — which means when we call notifyListeners(),
// every widget listening to this provider will rebuild with new data.
class NudgeProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String? _selectedScenario;
  String? _selectedTopic;
  bool _handoverMode = false; // true = phone has been handed over
  bool _declined = false;     // true = stranger said 'no thanks'
  bool _accepted = false;     // true = stranger picked a topic

  // Getters — read-only access to private state
  Locale get locale => _locale;
  String? get selectedScenario => _selectedScenario;
  String? get selectedTopic => _selectedTopic;
  bool get handoverMode => _handoverMode;
  bool get declined => _declined;
  bool get accepted => _accepted;

  NudgeProvider() { _loadSavedLocale(); }

  // Load previously saved language from device storage
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale') ?? 'en';
    _locale = Locale(code);
    notifyListeners();
  }

  // Switch app language and save choice
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    notifyListeners(); // triggers rebuild of all listening widgets
  }

  void setScenario(String scenario) {
    _selectedScenario = scenario;
    notifyListeners();
  }

  // Called when user taps 'Hand phone over'
  // Enables wakelock so screen stays on
  Future<void> enterHandoverMode() async {
    _handoverMode = true;
    await WakelockPlus.enable(); // screen stays on!
    notifyListeners();
  }

  void strangertopicChosen(String topic) {
    _selectedTopic = topic;
    _accepted = true;
    notifyListeners();
  }

  void strangerDeclined() {
    _declined = true;
    notifyListeners();
  }

  // Reset everything back to start
  Future<void> reset() async {
    _selectedScenario = null;
    _selectedTopic = null;
    _handoverMode = false;
    _declined = false;
    _accepted = false;
    await WakelockPlus.disable();
    notifyListeners();
  }
}
