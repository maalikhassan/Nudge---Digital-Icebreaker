import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/nudge_provider.dart';
import 'scenario_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController drives the logo fade-in
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward(); // start animation when screen loads
  }

  @override
  void dispose() {
    _controller.dispose(); // ALWAYS dispose controllers to free memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<NudgeProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Gradient background — top is deep purple, bottom is indigo
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF1A237E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    children: [
                      const Text('👋', style: TextStyle(fontSize: 72)),
                      const SizedBox(height: 16),
                      Text(
                        l10n.appTitle,
                        style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold,
                          color: Colors.white, letterSpacing: 4,
                        ),
                      ),
                      Text(
                        l10n.tagline,
                        style: TextStyle(
                          fontSize: 16, color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                // Language selector buttons
                Text(
                  'Select your language / භාෂාව / மொழி',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _langButton(provider, const Locale('en'), '🇬🇧 EN'),
                    const SizedBox(width: 12),
                    _langButton(provider, const Locale('si'), '🇱🇰 සිං'),
                    const SizedBox(width: 12),
                    _langButton(provider, const Locale('ta'), '🇮🇳 தமிழ்'),
                  ],
                ),
                const SizedBox(height: 48),
                // Main CTA button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A148C),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScenarioScreen()),
                  ),
                  child: Text(
                    l10n.selectScenario,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget: one language button
  Widget _langButton(NudgeProvider provider, Locale locale, String label) {
    final isSelected = provider.locale == locale;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(
            color: isSelected ? Colors.white : Colors.white38,
            width: isSelected ? 2.5 : 1,
          ),
          backgroundColor: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: () => provider.setLocale(locale),
        child: Text(label, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}
