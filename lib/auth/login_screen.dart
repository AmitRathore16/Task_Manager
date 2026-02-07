import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/dashboard/dashboard_screen.dart';
import 'package:task_manager/utils/toast_utils.dart';
import 'package:task_manager/utils/validators.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/theme.dart';
import 'auth_service.dart';
import 'signup_screen.dart';

final authServiceProvider = Provider((ref) => AuthService());

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);

    try {
      await ref.read(authServiceProvider).signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        ToastUtils.showSuccess(context, 'Login successful!');
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      }

    } on AuthException catch (e) {
      if (mounted) {
        ToastUtils.showError(context, e.message);
      }    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, 'Login failed: ${e.toString()}');
      }    }

    if (mounted) {
      setState(() => _loading = false);
    }  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.textWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.06),

                // Logo placeholder - user will replace with actual image
                Image.asset(
                  'assets/logo.png',
                  width: 85,
                  height: 85,
                  fit: BoxFit.contain,
                ).animate().fadeIn(duration: 500.ms).scale(delay: 100.ms),



                const SizedBox(height: 40),

                // Welcome Back heading
                Text(
                  "Welcome Back!",
                  style: theme.textTheme.headlineMedium,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 40),

                // Email Address label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email Address",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppTheme.textLightGray : const Color(0xFF666666),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 8),

                // Email input field with icon
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTheme.textWhite : AppTheme.pureBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: "fazzzil72@gmail.com",
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: isDark ? AppTheme.textLightGray : const Color(0xFF999999),
                    ),
                  ),
                ).animate().fadeIn(delay: 450.ms).slideX(begin: -0.1, end: 0),

                const SizedBox(height: 24),

                // Password label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppTheme.textLightGray : const Color(0xFF666666),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 8),

                // Password input field with icon and visibility toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: Validators.validatePassword,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTheme.textWhite : AppTheme.pureBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: isDark ? AppTheme.textLightGray : const Color(0xFF999999),
                    ),
                    suffixIcon: _AnimatedIconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: isDark ? AppTheme.textLightGray : const Color(0xFF999999),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ).animate().fadeIn(delay: 550.ms).slideX(begin: -0.1, end: 0),

                const SizedBox(height: 16),

                // Forgot Password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      "Forgot Password?",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppTheme.textLightGray : const Color(0xFF666666),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 24),


                // Log In button with animation
                _AnimatedButton(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      child: _loading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.pureBlack,
                          ),
                        ),
                      )
                          : const Text("Log In"),
                    ),
                  ),
                ).animate().fadeIn(delay: 650.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // "Or continue with" divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark ? AppTheme.dividerColor : const Color(0xFFCCCCCC),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Or continue with",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppTheme.textMutedGray : const Color(0xFF999999),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark ? AppTheme.dividerColor : const Color(0xFFCCCCCC),
                        thickness: 1,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),

                const SizedBox(height: 32),

                // Google sign-in button
                _AnimatedButton(
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement Google sign-in
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google icon placeholder
                          Icon(
                            Icons.g_mobiledata,
                            size: 28,
                            color: isDark ? AppTheme.textWhite : AppTheme.pureBlack,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Google",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 750.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 32),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppTheme.textMutedGray : const Color(0xFF666666),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const SignupScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOutCubic;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(position: offsetAnimation, child: FadeTransition(opacity: animation, child: child));
                            },
                            transitionDuration: const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                          .shimmer(delay: 3000.ms, duration: 1500.ms, color: AppTheme.primaryGold.withOpacity(0.3)),
                    ),
                  ],
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable animated button wrapper
class _AnimatedButton extends StatefulWidget {
  final Widget child;

  const _AnimatedButton({required this.child});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

// Animated icon button
class _AnimatedIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const _AnimatedIconButton({required this.icon, required this.onPressed});

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: IconButton(
          icon: widget.icon,
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
