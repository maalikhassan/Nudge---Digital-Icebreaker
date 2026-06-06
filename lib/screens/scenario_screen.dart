import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/nudge_provider.dart';
import 'handover_screen.dart';

class ScenarioScreen extends StatelessWidget {
  const ScenarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<NudgeProvider>();

    // The 4 scenarios as a list of maps
    final scenarios = [
      {'key': 'train', 'icon': '🚌', 'label': l10n.onTrain},
      {'key': 'cafe',  'icon': '☕', 'label': l10n.atCafe},
      {'key': 'class', 'icon': '📚', 'label': l10n.inClass},
      {'key': 'wait',  'icon': '⏳', 'label': l10n.waitingRoom},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        title: Text(l10n.selectScenario,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // GridView renders the scenario cards in a 2-column grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // 2 columns
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: scenarios.length,
                itemBuilder: (context, index) {
                  final s = scenarios[index];
                  return _ScenarioCard(
                    icon: s['icon']!,
                    label: s['label']!,
                    onTap: () {
                      provider.setScenario(s['key']!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HandoverScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A card widget for each scenario
class _ScenarioCard extends StatelessWidget {
  final String icon, label;
  final VoidCallback onTap; // VoidCallback = a function that takes no args
  const _ScenarioCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.15),
              blurRadius: 12, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: Color(0xFF4A148C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}