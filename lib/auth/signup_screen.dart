import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/utils/toast_utils.dart';
import 'package:task_manager/utils/validators.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/theme.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_agreedToTerms) {
      ToastUtils.showWarning(context, 'Please agree to the Terms & Conditions to continue');
      return;
    }

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);

    try {
      await ref.read(authServiceProvider).signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        ToastUtils.showSuccess(context, 'Account created successfully! Please login.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(context, 'Signup failed: ${e.toString()}');
      }    }
    if (mounted) {

      setState(() => _loading = false);
    }

  }

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

                const SizedBox(height: 16),

                const SizedBox(height: 40),

                // Create your account heading
                Text(
                  "Create your account",
                  style: theme.textTheme.headlineMedium,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 40),

                // Full Name label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Full Name",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppTheme.textLightGray : const Color(0xFF666666),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 8),

                // Full Name input field with icon
                TextFormField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTheme.textWhite : AppTheme.pureBlack,
                  ),
                  validator: Validators.validateName,

                  decoration: InputDecoration(
                    hintText: "Fazil Laghari",
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: isDark ? AppTheme.textLightGray : const Color(0xFF999999),
                    ),
                  ),
                ).animate().fadeIn(delay: 450.ms).slideX(begin: -0.1, end: 0),

                const SizedBox(height: 24),

                // Email Address label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email Address",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppTheme.textLightGray : const Color(0xFF666666),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const SizedBox(height: 8),

                // Email input field with icon
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTheme.textWhite : AppTheme.pureBlack,
                  ),
                  validator: Validators.validateEmail,
                  decoration: InputDecoration(
                    hintText: "fazzzil72@gmail.com",
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: isDark ? AppTheme.textLightGray : const Color(0xFF999999),
                    ),
                  ),
                ).animate().fadeIn(delay: 550.ms).slideX(begin: -0.1, end: 0),

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
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 8),

                // Password input field with icon and visibility toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTheme.textWhite : AppTheme.pureBlack,
                  ),
                  validator: Validators.validatePassword,
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
                ).animate().fadeIn(delay: 650.ms).slideX(begin: -0.1, end: 0),

                const SizedBox(height: 24),

                // Terms and Conditions checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AnimatedCheckbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppTheme.textMutedGray : const Color(0xFF666666),
                            ),
                            children: [
                              const TextSpan(text: "I have read & agreed to DayTask "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: AppTheme.secondaryGold,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(text: ",\n"),
                              TextSpan(
                                text: "Terms & Condition",
                                style: TextStyle(
                                  color: AppTheme.secondaryGold,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms),

                const SizedBox(height: 32),


                // Sign Up button with animation
                _AnimatedButton(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signup,
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
                          : const Text("Sign Up"),
                    ),
                  ),
                ).animate().fadeIn(delay: 750.ms).slideY(begin: 0.2, end: 0),

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
                ).animate().fadeIn(delay: 800.ms),

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
                ).animate().fadeIn(delay: 850.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 32),

                // Log in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppTheme.textMutedGray : const Color(0xFF666666),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Log In",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                          .shimmer(delay: 3000.ms, duration: 1500.ms, color: AppTheme.primaryGold.withOpacity(0.3)),
                    ),
                  ],
                ).animate().fadeIn(delay: 900.ms),

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

// Animated checkbox
class _AnimatedCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _AnimatedCheckbox({required this.value, required this.onChanged});

  @override
  State<_AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<_AnimatedCheckbox> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onChanged(!widget.value);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: widget.value,
            onChanged: widget.onChanged,
          ),
        ).animate(target: widget.value ? 1 : 0)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 200.ms, curve: Curves.elasticOut),
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
