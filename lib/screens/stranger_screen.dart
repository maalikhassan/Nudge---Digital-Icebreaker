import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/nudge_provider.dart';
import 'result_screen.dart';

// ── StrangerScreen v2 ─────────────────────────────────────────
// NEW: scenario-specific topics + time selection + AI icebreaker
class StrangerScreen extends StatefulWidget {
  const StrangerScreen({super.key});

  @override
  State<StrangerScreen> createState() => _StrangerScreenState();
}

class _StrangerScreenState extends State<StrangerScreen> {
  final TextEditingController _customMinutesController = TextEditingController();

  @override
  void dispose() {
    _customMinutesController.dispose();
    super.dispose();
  }

  void _applyCustomMinutes(NudgeProvider provider) {
    final raw = _customMinutesController.text.trim();
    final parsed = int.tryParse(raw);
    if (parsed == null || parsed < 1 || parsed > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid time between 1 and 120 minutes.'),
        ),
      );
      return;
    }
    provider.setTimeAvailable(parsed);
    FocusScope.of(context).unfocus();
  }

  // Returns topics relevant to the chosen scenario
  // This is the 'intelligent' part — input (scenario) → output (relevant topics)
  List<Map<String, String>> _topicsForScenario(String? scenario, AppLocalizations l10n) {
    switch (scenario) {
      case 'train':
        return [
          {'icon': '🎵', 'label': l10n.topic_music},
          {'icon': '🌍', 'label': l10n.topic_travel},
          {'icon': '📱', 'label': l10n.topic_tech},
          {'icon': '😂', 'label': l10n.topic_memes},
        ];
      case 'cafe':
        return [
          {'icon': '☕', 'label': l10n.topic_coffee},
          {'icon': '🍜', 'label': l10n.topic_food},
          {'icon': '💼', 'label': l10n.topic_work},
          {'icon': '📚', 'label': l10n.topic_books},
        ];
      case 'class':
        return [
          {'icon': '🎓', 'label': l10n.topic_studies},
          {'icon': '💡', 'label': l10n.topic_career},
          {'icon': '🎮', 'label': l10n.topic_gaming},
          {'icon': '🏏', 'label': l10n.topic_sports},
        ];
      default: // waiting room
        return [
          {'icon': '📺', 'label': l10n.topic_shows},
          {'icon': '✈️', 'label': l10n.topic_travel},
          {'icon': '🎵', 'label': l10n.topic_music},
          {'icon': '😎', 'label': l10n.topic_vibes},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<NudgeProvider>();
    final topics = _topicsForScenario(provider.selectedScenario, l10n);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(  // allows scrolling if content is tall
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text('👋', style: TextStyle(fontSize: 56),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(l10n.greeting,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C))),
              const SizedBox(height: 8),
              Text(l10n.iceBreakPrompt,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 28),

              // ── NEW: Time availability picker ──────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(l10n.howMuchTime,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600,
                            color: Color(0xFF4A148C))),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [5, 10, 15, 20].map((mins) =>
                          _TimeChip(minutes: mins),
                      ).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customMinutesController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Custom minutes (try 1 for viva demo)',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => _applyCustomMinutes(provider),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B1FA2),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(80, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _applyCustomMinutes(provider),
                          child: const Text('Set'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Scenario-aware topic buttons ───────────────────
              Text(l10n.topicsLabel,
                  style: const TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 12),
              ...topics.map((topic) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDE7F6),
                    foregroundColor: const Color(0xFF4A148C),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    provider.strangerTopicChosen(topic['label']!);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const ResultScreen()));
                  },
                  child: Row(children: [
                    Text(topic['icon']!, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Text(topic['label']!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ]),
                ),
              )),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  provider.strangerDeclined();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const ResultScreen()));
                },
                child: Text(l10n.noThanks,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Time chip widget — one button for each time option ─────────
class _TimeChip extends StatelessWidget {
  final int minutes;
  const _TimeChip({required this.minutes});

  @override
  Widget build(BuildContext context) {
    // consumer to watch selected time from provider
    return Consumer<NudgeProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.timeAvailableMinutes == minutes;
        return GestureDetector(
          onTap: () => provider.setTimeAvailable(minutes),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7B1FA2) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF7B1FA2) : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Text('${minutes}m',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.bold, fontSize: 15,
              ),
            ),
          ),
        );
      },
    );
  }
}