import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/dashboard/dashboard_screen.dart';
import 'package:task_manager/utils/toast_utils.dart';
import 'package:task_manager/utils/validators.dart';
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
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
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

                // Welcome Back heading
                Text(
                  "Welcome Back!",
                  style: theme.textTheme.headlineMedium,
                ),

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
                ),
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
                ),

                const SizedBox(height: 24),


                // Log In button
                SizedBox(
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
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
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
