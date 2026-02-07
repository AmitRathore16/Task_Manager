import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/utils/toast_utils.dart';
import 'package:task_manager/utils/validators.dart';
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.task_alt,
                      color: AppTheme.primaryGold,
                      size: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // DayTask title
                Text(
                  "DayTask",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                  ),
                ),

                const SizedBox(height: 40),

                // Create your account heading
                Text(
                  "Create your account",
                  style: theme.textTheme.headlineMedium,
                ),

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
                ),
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
                ),

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
                ),
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
                ),

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
                ),
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
                    suffixIcon: IconButton(
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
                ),

                const SizedBox(height: 24),

                // Terms and Conditions checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                      ),
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
                ),

                const SizedBox(height: 32),


                // Sign Up button
                SizedBox(
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
                ),

                const SizedBox(height: 32),

                // Google sign-in button
                SizedBox(
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
