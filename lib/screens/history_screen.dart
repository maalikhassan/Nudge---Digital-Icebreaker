import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/nudge_provider.dart';
import '../models/interaction.dart';

// ── HistoryScreen — shows all past nudge interactions ─────────
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NudgeProvider>();
    final history = provider.history;

    // ── Stats: total connections, most used scenario ───────────
    final connected = history.where((i) => i.outcome == 'connected').length;
    final declined  = history.where((i) => i.outcome == 'declined').length;
    final scenarioCounts = <String, int>{};
    for (final i in history) {
      scenarioCounts[i.scenario] = (scenarioCounts[i.scenario] ?? 0) + 1;
    }
    final topScenario = scenarioCounts.isEmpty ? '—'
        : scenarioCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b).key;

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        title: const Text('Your Nudge History',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [

          // ── Stats summary bar ────────────────────────────────
          Container(
            color: const Color(0xFF7B1FA2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(label: 'Connections', value: '$connected', icon: '🤝'),
                _StatChip(label: 'Declined', value: '$declined', icon: '👋'),
                _StatChip(label: 'Top Spot', value: topScenario, icon: '📍'),
              ],
            ),
          ),

          // ── Interaction list ─────────────────────────────────
          Expanded(
            child: history.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('👋', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text('No nudges yet!',
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                  Text('Go break some ice 🧊',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                return _InteractionCard(interaction: history[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── One interaction card in the list ─────────────────────────
class _InteractionCard extends StatelessWidget {
  final Interaction interaction;
  const _InteractionCard({required this.interaction});

  @override
  Widget build(BuildContext context) {
    final isConnected = interaction.outcome == 'connected';
    final dateStr = DateFormat('MMM d, yyyy  h:mm a').format(interaction.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Big emoji column
            Text(interaction.scenarioIcon, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 14),
            // Info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isConnected ? interaction.topic : 'Declined',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(dateStr,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  if (interaction.plannedMinutes != null)
                    Text('Planned: ${interaction.plannedMinutes} min',
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            // Outcome badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isConnected
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isConnected ? '🤝 Chat' : '👋 Pass',
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold,
                  color: isConnected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE65100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small stat display widget ─────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label, value, icon;
  const _StatChip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}