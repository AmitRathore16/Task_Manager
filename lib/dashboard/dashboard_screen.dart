import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/app/theme_provider.dart';
import 'package:task_manager/splash_screen.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/theme.dart';
import '../auth/auth_service.dart';
import 'task_tile.dart';
import 'edit_task_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tasksAsync = ref.watch(taskListProvider);
    final currentUser = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.textWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.secondaryGold,
                            ),
                          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
                          const SizedBox(height: 4),
                          Text(
                            currentUser?.email?.split('@')[0] ?? 'User',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 24,
                            ),
                          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: -0.2, end: 0),
                        ],
                      ),
                      Row(
                        children: [
                          _AnimatedThemeToggle(
                            isDark: isDark,
                            onTap: () {
                              ref.read(themeModeProvider.notifier).toggleTheme();
                            },
                          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).scale(delay: 200.ms),
                          const SizedBox(width: 12),
                          _AnimatedIconContainer(
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.textWhite,
                                  title: Text(
                                    'Sign Out',
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  content: Text(
                                    'Are you sure you want to sign out?',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: const Text('Sign Out'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SplashScreen(),
                                  ),
                                );
                                await AuthService().signOut();
                              }
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryGold,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: AppTheme.pureBlack,
                                size: 24,
                              ),
                            ),
                          ).animate().fadeIn(delay: 300.ms, duration: 400.ms).scale(delay: 300.ms),
                        ],
                      ),
                    ],
                  ),                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.inputFieldBg
                                : AppTheme.lightBg3,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: isDark
                                    ? AppTheme.textMutedGray
                                    : const Color(0xFF999999),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Search tasks',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? AppTheme.textMutedGray
                                      : const Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideX(begin: -0.1, end: 0),
                      ),
                      const SizedBox(width: 12),
                      _AnimatedIconContainer(
                        onTap: () {},
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: AppTheme.pureBlack,
                            size: 20,
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms, duration: 400.ms).scale(delay: 500.ms),
                    ],
                  ),
                ],
              ),
            ),

            // Task list
            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_outlined,
                            size: 80,
                            color: isDark
                                ? AppTheme.textMutedGray
                                : const Color(0xFFCCCCCC),
                          ).animate().fadeIn(duration: 600.ms).scale(delay: 100.ms),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks yet',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isDark
                                  ? AppTheme.textMutedGray
                                  : const Color(0xFF999999),
                            ),
                          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first task',
                            style: theme.textTheme.bodyMedium,
                          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                        ],
                      ),
                    );
                  }

                  final pendingTasks = tasks
                      .where((t) => !t.isCompleted)
                      .toList();
                  final completedTasks = tasks
                      .where((t) => t.isCompleted)
                      .toList();

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      if (pendingTasks.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pending Tasks',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryGold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${pendingTasks.length}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.secondaryGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
                        const SizedBox(height: 16),
                        ...pendingTasks.asMap().entries.map((entry) {
                          final index = entry.key;
                          final task = entry.value;
                          return TaskTile(task: task)
                              .animate()
                              .fadeIn(delay: (index * 50).ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0, delay: (index * 50).ms);
                        }),
                        const SizedBox(height: 24),
                      ],

                      if (completedTasks.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Completed Tasks',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                                color: isDark
                                    ? AppTheme.textMutedGray
                                    : const Color(0xFF999999),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.textMutedGray.withOpacity(0.2)
                                    : const Color(0xFFCCCCCC).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${completedTasks.length}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? AppTheme.textMutedGray
                                      : const Color(0xFF999999),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
                        const SizedBox(height: 16),
                        ...completedTasks.asMap().entries.map((entry) {
                          final index = entry.key;
                          final task = entry.value;
                          return TaskTile(task: task)
                              .animate()
                              .fadeIn(delay: (index * 50).ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0, delay: (index * 50).ms);
                        }),
                        const SizedBox(height: 24),
                      ],
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.secondaryGold,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading tasks',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _AnimatedFAB(
        onPressed: () {
          showAddEditTaskDialog(context);
        },
      ).animate().fadeIn(delay: 600.ms, duration: 500.ms).scale(delay: 600.ms),
    );
  }
}

class _AnimatedThemeToggle extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _AnimatedThemeToggle({required this.isDark, required this.onTap});

  @override
  State<_AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<_AnimatedThemeToggle> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(_AnimatedThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark != widget.isDark) {
      _rotationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: widget.isDark
                ? AppTheme.inputFieldBgDark
                : AppTheme.lightBg3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: RotationTransition(
            turns: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
            ),
            child: Icon(
              widget.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: widget.isDark
                  ? AppTheme.secondaryGold
                  : AppTheme.primaryGold,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedIconContainer extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _AnimatedIconContainer({required this.onTap, required this.child});

  @override
  State<_AnimatedIconContainer> createState() => _AnimatedIconContainerState();
}

class _AnimatedIconContainerState extends State<_AnimatedIconContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

class _AnimatedFAB extends StatefulWidget {
  final VoidCallback onPressed;

  const _AnimatedFAB({required this.onPressed});

  @override
  State<_AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<_AnimatedFAB> {
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
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: FloatingActionButton.extended(
          onPressed: widget.onPressed,
          backgroundColor: AppTheme.secondaryGold,
          icon: const Icon(Icons.add, color: AppTheme.pureBlack),
          label: const Text(
            'Add Task',
            style: TextStyle(
              color: AppTheme.pureBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
