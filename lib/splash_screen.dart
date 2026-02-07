import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'app/theme.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppTheme.darkBackground : AppTheme.textWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              Image.asset(
                'assets/logo.png',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              )
                  .animate().fadeIn(duration: 500.ms).scale(delay: 100.ms),


              const SizedBox(height: 30),

              Center(
                child: Image.asset(
                  'assets/image.png',
                  width: size.width * 0.85,
                  fit: BoxFit.contain,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

              const Spacer(),

              RichText(
                text: TextSpan(
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    color: isDark
                        ? AppTheme.textWhite
                        : AppTheme.pureBlack,
                  ),
                  children: [
                    const TextSpan(text: "Manage\nyour\nTask with\n"),
                    TextSpan(
                      text: "DayTask",
                      style: TextStyle(
                        fontFamily: 'Pilat',
                        fontSize: 56,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                        const LoginScreen(),
                        transitionsBuilder:
                            (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        transitionDuration:
                        const Duration(milliseconds: 400),
                      ),
                    );
                  },
                  child: const Text(
                    "Let’s Start",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
