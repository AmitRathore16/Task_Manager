import 'package:flutter/material.dart';
import '../app/theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Logo
              Row(
                children: [
                  Image.network(
                    "https://dummyimage.com/40x40/ffffff/000000.png&text=DT",
                    height: 36,
                  ),
                  const SizedBox(width: 10),
                  Text("DayTask", style: textTheme.titleLarge),
                ],
              ),

              SizedBox(height: size.height * 0.06),

              /// Illustration
              Center(
                child: Image.network(
                  "https://dummyimage.com/600x400/cccccc/000000.png&text=Illustration",
                  height: size.height * 0.32,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              /// Big Heading
              RichText(
                text: TextSpan(
                  style: textTheme.headlineLarge,
                  children: const [
                    TextSpan(text: "Manage your\nTask with "),
                    TextSpan(
                      text: "DayTask",
                      style: TextStyle(color: AppTheme.accentGold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text("Let’s Start"),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
