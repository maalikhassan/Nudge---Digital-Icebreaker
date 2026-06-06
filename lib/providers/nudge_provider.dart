// nudge_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:http/http.dart' as http;
import '../models/interaction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


// ── NudgeProvider v2 ──────────────────────────────────────────
// NEW in v2: timeAvailable, aiIcebreaker, interactionHistory
class NudgeProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String? _selectedScenario;
  String? _selectedTopic;
  int? _timeAvailableMinutes;        // NEW: how long stranger has
  bool _handoverMode = false;
  bool _declined = false;
  bool _accepted = false;
  String? _aiIcebreaker;             // NEW: Groq-generated line
  bool _aiLoading = false;           // NEW: is API call in progress
  List<Interaction> _history = [];   // NEW: all past interactions
  DateTime? _chatStartTime;          // NEW: when conversation started

  // Getters
  Locale get locale => _locale;
  String? get selectedScenario => _selectedScenario;
  String? get selectedTopic => _selectedTopic;
  int? get timeAvailableMinutes => _timeAvailableMinutes;
  bool get handoverMode => _handoverMode;
  bool get declined => _declined;
  bool get accepted => _accepted;
  String? get aiIcebreaker => _aiIcebreaker;
  bool get aiLoading => _aiLoading;
  List<Interaction> get history => List.unmodifiable(_history);
  DateTime? get chatStartTime => _chatStartTime;

  NudgeProvider() {
    _loadSavedLocale();
    _loadHistory();   // NEW: load history from device on app start
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = Locale(prefs.getString('locale') ?? 'en');
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  void setScenario(String scenario) {
    _selectedScenario = scenario;
    notifyListeners();
  }

  // NEW: stranger sets how many minutes they have
  void setTimeAvailable(int minutes) {
    _timeAvailableMinutes = minutes;
    notifyListeners();
  }

  Future<void> enterHandoverMode() async {
    _handoverMode = true;
    await WakelockPlus.enable();
    notifyListeners();
  }

  void strangerTopicChosen(String topic) {
    _selectedTopic = topic;
    _accepted = true;
    _chatStartTime = DateTime.now();  // NEW: record when chat begins
    notifyListeners();
  }

  void strangerDeclined() {
    _selectedTopic = null;
    _accepted = false;
    _chatStartTime = null;
    _declined = true;
    notifyListeners();
  }

  // NEW: call Groq API to generate a custom icebreaker line
  Future<void> fetchAIIcebreaker() async {
    if (_selectedScenario == null || _selectedTopic == null) return;
    _aiLoading = true;
    _aiIcebreaker = null;
    notifyListeners();

    try {
      final prompt = '''
You are a friendly social coach. Give ONE short, natural, funny opening
line (max 2 sentences) to start a conversation with a stranger.
Context: they are in a '$_selectedScenario' setting.
Topic chosen: '$_selectedTopic'.
Time they have: ${_timeAvailableMinutes ?? 10} minutes.
Make it warm, low-pressure, and conversation-starting. No cringe.
Only reply with the opening line itself, nothing else.''';

      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          // API key is loaded from the .env file.
          'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY']}',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',  // currently supported Groq model
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 80,
          'temperature': 0.8,  // 0=serious, 1=creative
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _aiIcebreaker = data['choices'][0]['message']['content'].trim();
      } else {
        _aiIcebreaker = 'Hey! Nice to meet you 😊';  // fallback
      }
    } catch (e, stackTrace) {
      // If API fails (no internet etc.), use a friendly fallback
      print("❌ GROQ API ERROR: $e");
      print("❌ STACKTRACE: $stackTrace");
      _aiIcebreaker = 'Hey! I thought it would be nice to say hi 😊';

    }

    _aiLoading = false;
    notifyListeners();
  }

  // NEW: save a completed interaction to history
  Future<void> saveInteraction() async {
    if (_selectedScenario == null) return;
    // Connected interactions require a chosen topic, declined interactions do not.
    if (!_declined && _selectedTopic == null) return;

    // Calculate actual duration if we have a start time
    int? actualMinutes;
    if (_chatStartTime != null) {
      final dur = DateTime.now().difference(_chatStartTime!);
      actualMinutes = dur.inMinutes;
    }

    final interaction = Interaction(
      timestamp: DateTime.now(),
      scenario: _selectedScenario!,
      topic: _selectedTopic ?? 'Declined',
      plannedMinutes: _timeAvailableMinutes,
      actualMinutes: actualMinutes,
      outcome: _declined ? 'declined' : 'connected',
    );

    _history.insert(0, interaction);  // newest first
    await _persistHistory();
    notifyListeners();
  }

  // Save history list to device storage as JSON
  Future<void> _persistHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_history.map((i) => i.toJson()).toList());
    await prefs.setString('interaction_history', encoded);
  }

  // Load history from device storage on app start
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('interaction_history');
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      _history = decoded.map((j) => Interaction.fromJson(j)).toList();
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _selectedScenario = null;
    _selectedTopic = null;
    _timeAvailableMinutes = null;
    _handoverMode = false;
    _declined = false;
    _accepted = false;
    _aiIcebreaker = null;
    _aiLoading = false;
    _chatStartTime = null;
    await WakelockPlus.disable();
    notifyListeners();
  }
}

