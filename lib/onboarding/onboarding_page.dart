import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_buttons.dart';
import '../welcome_page.dart';
// если у тебя есть welcome_page.dart
// если welcome_page.dart нет или называется иначе — поменяешь импорт

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 36),

              // Title
              Text(
                'Your second brain',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Plan your day. Track habits. Improve sleep.\nAll in one calm place.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondary.withOpacity(0.85),
                      height: 1.35,
                    ),
              ),

              const Spacer(),

              // Simple "illustration" placeholder (no image yet)
              // Later we can replace this with an image asset background.
              Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 64,
                    color: AppColors.accent.withOpacity(0.9),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Continue button (green)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: primaryGreenButtonStyle(),
                  onPressed: () {
                    // пока просто идём на WelcomePage (или на следующий onboarding экран)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomePage()),
                    );
                  },
                  child: const Text('Continue'),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'You can change everything later in settings.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondary.withOpacity(0.7),
                    ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
