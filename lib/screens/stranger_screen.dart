import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/nudge_provider.dart';
import 'result_screen.dart';

// This is what the STRANGER sees when the phone is handed to them.
// The screen is high-contrast, big text, friendly.
class StrangerScreen extends StatelessWidget {
  const StrangerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<NudgeProvider>();

    // Topic options as list
    final topics = [
      {'icon': '🎵', 'label': l10n.topic1},
      {'icon': '🍜', 'label': l10n.topic2},
      {'icon': '💼', 'label': l10n.topic3},
      {'icon': '😎', 'label': l10n.topic4},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Big friendly greeting
              Text(l10n.greeting,
                  style: const TextStyle(fontSize: 56),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(
                l10n.iceBreakPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20, color: Color(0xFF4A148C),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              Text(l10n.topicsLabel,
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 16),
              // Topic buttons — one for each option
              ...topics.map((topic) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDE7F6),
                    foregroundColor: const Color(0xFF4A148C),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    provider.strangertopicChosen(topic['label']!);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ResultScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Text(topic['icon']!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text(topic['label']!,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )),
              const Spacer(),
              // Decline button — low-pressure exit for the stranger
              TextButton(
                onPressed: () {
                  provider.strangerDeclined();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultScreen()),
                  );
                },
                child: Text(
                  l10n.noThanks,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
