import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'app_buttons.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F8FA), Color(0xFFF1F6F2)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),

                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x1A111827)),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF2F6B4F),
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  "Life Assistant",
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Habit tracker, calendar and AI assistant\nin one app.",
                  style: TextStyle(
                    fontSize: 15.5,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),

                const Spacer(),

                AppButton(
                  text: "Create account",
                  variant: AppButtonVariant.primary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                AppButton(
                  text: "Log in",
                  variant: AppButtonVariant.secondary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                Center(
                  child: Text(
                    "Everything can be changed later in settings.",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.black.withOpacity(0.45),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

