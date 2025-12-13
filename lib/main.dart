import 'package:flutter/material.dart';

// ===== Palette =====
const Color kBg = Color(0xFFF3F4F6);      // light gray background
const Color kText = Color(0xFF111827);    // almost black
const Color kMuted = Color(0xFF6B7280);   // muted gray
const Color kPrimary = Color(0xFF5A8F3E); // calm green
const Color kSurface = Colors.white;

void main() {
  runApp(const LifeAssistantApp());
}

// ===== App root =====
class LifeAssistantApp extends StatelessWidget {
  const LifeAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Life Assistant',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBg,

        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimary,
          brightness: Brightness.light,
        ).copyWith(
          primary: kPrimary,
          surface: kSurface,
        ),

        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: kText,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: kMuted,
          ),
        ),
      ),

      home: const WelcomePage(),
    );
  }
}

// ===== Welcome Screen =====
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // ===== Title + subtitle (NO white card) =====
              Column(
                children: const [
                  Text(
                    'Life Assistant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: kPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Plan your day.\nTrack habits.\nChat with AI.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: kMuted,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ===== LOGIN BUTTON =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ===== CREATE ACCOUNT BUTTON =====
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: const BorderSide(color: kPrimary),
                  ),
                  child: const Text(
                    'Create account',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

