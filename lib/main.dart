import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';
import 'providers/nudge_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NudgeApp());
}

class NudgeApp extends StatelessWidget {
  const NudgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provider wraps the whole app so any screen can access NudgeProvider
      create: (_) => NudgeProvider(),
      child: Consumer<NudgeProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Nudge',
            debugShowCheckedModeBanner: false,
            // i18n setup — tells Flutter which languages we support
            locale: provider.locale,
            supportedLocales: const [
              Locale('en'), // English
              Locale('si'), // Sinhala
              Locale('ta'), // Tamil
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF7C3AED), // purple
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}