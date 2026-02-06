import 'package:flutter/material.dart';
import '../app/theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.textWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Logo at top left with DayTask text BELOW it
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Placeholder logo - user will replace with actual image
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.task_alt,
                                  color: AppTheme.primaryGold,
                                  size: 32,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "DayTask",
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.04),

                        // Illustration placeholder - user will replace with actual image
                        Center(
                          child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.3,
                            constraints: const BoxConstraints(
                              maxHeight: 350,
                              maxWidth: 350,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person_outline,
                                size: 100,
                                color: AppTheme.primaryGold.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Main heading with "Manage your Task with DayTask"
                        // Using Pilat font for this section
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: isDark ? AppTheme.textWhite : AppTheme.pureBlack,
                            ),
                            children: [
                              const TextSpan(text: "Manage\nyour\nTask with\n"),
                              TextSpan(
                                text: "DayTask",
                                style: TextStyle(
                                  color: AppTheme.primaryGold,
                                  fontFamily: 'Pilat',
                                  fontSize: 61,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Let's Start button
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
                            child: const Text("Let's Start"),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
