import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/nudge_provider.dart';
import 'home_screen.dart';

// ── ResultScreen v2 ───────────────────────────────────────────
// NEW: AI icebreaker display, countdown timer, save to history
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    // When screen loads, save interaction. AI is optional via reveal button.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NudgeProvider>();
      provider.saveInteraction();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<NudgeProvider>();

    if (provider.declined) return _DeclinedView(l10n: l10n, provider: provider);
    return _AcceptedView(l10n: l10n, provider: provider);
  }
}

// ── Accepted: show timer + AI icebreaker ──────────────────────
class _AcceptedView extends StatefulWidget {
  final AppLocalizations l10n;
  final NudgeProvider provider;
  const _AcceptedView({required this.l10n, required this.provider});
  @override
  State<_AcceptedView> createState() => _AcceptedViewState();
}

class _AcceptedViewState extends State<_AcceptedView> {
  late int _secondsLeft;
  bool _timerStarted = false;
  bool _handedBack = false;
  bool _aiRevealed = false;
  bool _warningBuzzed = false;
  bool _finishedBuzzed = false;
  // We use a simple Stopwatch approach with periodic Timer
  // import 'dart:async' needed at top of file

  @override
  void initState() {
    super.initState();
    final mins = widget.provider.timeAvailableMinutes ?? 10;
    _secondsLeft = mins * 60;
  }

  Future<void> _tripleHapticPulse() async {
    for (var i = 0; i < 3; i++) {
      await HapticFeedback.heavyImpact();
      if (i < 2) {
        await Future.delayed(const Duration(milliseconds: 160));
      }
    }
  }

  void _startTimer() {
    if (_timerStarted) return;
    _timerStarted = true;
    // Dart's Timer.periodic fires every second
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;  // widget was disposed, stop
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 60 && !_warningBuzzed) {
        _warningBuzzed = true;
        _tripleHapticPulse();
      }
      if (_secondsLeft <= 0 && !_finishedBuzzed) {
        _finishedBuzzed = true;
        _tripleHapticPulse();
      }
      return _secondsLeft > 0;     // return false to stop loop
    });
  }

  String get _formattedTime {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color get _timerColor {
    if (_secondsLeft <= 60) return const Color(0xFFB71C1C); // urgent red
    return const Color(0xFF1A237E); // default indigo
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NudgeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _handedBack
              ? _buildOwnerView(provider)
              : _buildPassBackView(provider),
        ),
      ),
    );
  }

  Widget _buildPassBackView(NudgeProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('✅', style: TextStyle(fontSize: 64), textAlign: TextAlign.center),
        const SizedBox(height: 14),
        const Text(
          'Nice choice!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A148C),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Show this to the person who gave the phone.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            provider.selectedTopic ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A148C),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B1FA2),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () => setState(() => _handedBack = true),
          child: const Text(
            'Got the phone back',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerView(NudgeProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('🎉', style: TextStyle(fontSize: 64), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        const Text(
          'You are all set!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A148C),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.l10n.topicChosen,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            provider.selectedTopic ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A148C),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!_aiRevealed)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4A148C),
                  side: const BorderSide(color: Color(0xFF7B1FA2)),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  setState(() => _aiRevealed = true);
                  await provider.fetchAIIcebreaker();
                },
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Reveal AI icebreaker'),
              ),
              const SizedBox(height: 6),
              const Text(
                'Optional: skip this if you already have your own topic.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7B1FA2), Color(0xFF1A237E)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  '✨ AI Icebreaker',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                provider.aiLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        provider.aiIcebreaker ?? 'Hey! Nice to meet you 😊',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _startTimer, // tap to start counting down
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _timerColor, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  _timerStarted ? 'Time left' : 'Tap to start timer',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  _formattedTime,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: _timerColor,
                    fontFamily: 'Courier New',
                  ),
                ),
                if (_secondsLeft <= 60 && _timerStarted)
                  const Text(
                    '⏰ Almost time — wrap it up!',
                    style: TextStyle(color: Color(0xFFB71C1C), fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B1FA2),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () async {
            await provider.reset();
            if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
          child: Text(widget.l10n.startOver, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class _DeclinedView extends StatelessWidget {
  final AppLocalizations l10n;
  final NudgeProvider provider;
  const _DeclinedView({required this.l10n, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('😊', style: TextStyle(fontSize: 80),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Text(l10n.thanksMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C))),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B1FA2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  await provider.reset();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                },
                child: Text(l10n.startOver,
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
