import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/nudge_provider.dart';
import 'stranger_screen.dart';

// This is the screen YOU see before handing the phone to the stranger.
class HandoverScreen extends StatelessWidget {
  const HandoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<NudgeProvider>();

    // If app is in handover mode, show the stranger's screen
    if (provider.handoverMode) {
      return const StrangerScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        title: const Text('Nudge',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('🤳', style: TextStyle(fontSize: 80),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            const Text(
              'Ready to break the ice?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.handoverHint,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 48),
            // The big button — triggers handover mode
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B1FA2),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
              ),
              onPressed: () async {
                await provider.enterHandoverMode();
                // No Navigator.push needed — widget rebuilds because
                // provider.handoverMode changed, and we show StrangerScreen
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_forward_rounded, size: 28),
                  SizedBox(width: 10),
                  Text('Hand it over!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}