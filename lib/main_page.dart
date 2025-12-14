import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'welcome_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout logic here (clear token etc)
              
              // Go back to Welcome
               Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomePage()), 
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.check_circle, size: 80, color: AppColors.primary),
             const SizedBox(height: 16),
             Text(
              "You are logged in!",
              style: Theme.of(context).textTheme.headlineSmall,
             ),
          ],
        ),
      ),
    );
  }
}
