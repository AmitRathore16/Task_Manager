import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_manager/app/theme_provider.dart';
import 'package:task_manager/auth/splash_screen.dart';
import 'package:task_manager/providers/task_provider.dart';
import '../app/theme.dart';
import '../auth/auth_service.dart';
import 'task_model.dart';
import 'task_tile.dart';
import 'add_edit_task_dialog.dart';

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
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentUser?.email?.split('@')[0] ?? 'User',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      // Theme toggle and Profile icon
                      Row(
                        children: [
                          // Night mode toggle button
                          GestureDetector(
                            onTap: () {
                              ref.read(themeModeProvider.notifier).toggleTheme();
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.inputFieldBgDark
                                    : AppTheme.lightBg3,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                color: isDark
                                    ? AppTheme.secondaryGold
                                    : AppTheme.primaryGold,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Profile icon
                          GestureDetector(
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
                          ),
                        ],
                      ),
                    ],
                  ),                  const SizedBox(height: 20),

                  // Search bar and filter (dummy - no functionality)
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
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Filter button (dummy)
                      Container(
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
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks yet',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isDark
                                  ? AppTheme.textMutedGray
                                  : const Color(0xFF999999),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first task',
                            style: theme.textTheme.bodyMedium,
                          ),
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
                      // Pending tasks section
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
                        ),
                        const SizedBox(height: 16),
                        ...pendingTasks.map((task) => TaskTile(task: task)),
                        const SizedBox(height: 24),
                      ],

                      // Completed tasks section
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
                        ),
                        const SizedBox(height: 16),
                        ...completedTasks.map((task) => TaskTile(task: task)),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddEditTaskDialog(context);
        },
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
    );
  }
}
